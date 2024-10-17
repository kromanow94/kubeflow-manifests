#!/bin/bash
set -e

cat <<EOF
This script will create 'kubeflow' namespace configured with istio injection and
install helm releases for each kubeflow dependency and kubeflow itself.

This script will also install the Helm Releases for each dependency in the
correct order and will wait until the dependencies are ready.

Press 'Ctrl'+'C' to cancel.
Waiting 10 seconds...
EOF
sleep 10
set -x

# Create namespaces #
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  labels:
    istio-injection: enabled
  name: kubeflow
EOF

# If we're using '.Values.knativeIntegration.knativeServing.enabled: true', this namespace
# must exist before we deploy 'kubeflow' Helm Chart.
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  labels:
  name: knative-serving
EOF

# If we're using '.Values.knativeIntegration.knativeEventing.enabled: true', this namespace
# must exist before we deploy 'kubeflow' Helm Chart.
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  labels:
  name: knative-eventing
EOF

# Create secret with database credentials for KFP and MySQL
export DB_CONFIG_SECRET_NAME=db-credentials
kubectl apply -f "secret.${DB_CONFIG_SECRET_NAME}.yaml"

# Create mlpipeline-minio-artifact K8s Secret holding secrets for KFP and MinIO.
export OBJECTSTORE_CONFIG_SECRET_NAME=mlpipeline-minio-artifact
kubectl apply -f "secret.${OBJECTSTORE_CONFIG_SECRET_NAME}.yaml"

# MySQL #
helm upgrade --install mysql mysql \
    --namespace kubeflow \
    --repo https://charts.bitnami.com/bitnami \
    --version 9.21.2 \
    --values values.mysql.yaml \
    --wait

# MinIO #
helm upgrade --install minio minio \
    --namespace kubeflow \
    --repo https://charts.bitnami.com/bitnami \
    --version 13.7.0 \
    --values values.minio.yaml \
    --wait

# cert-manager #
helm upgrade --install cert-manager cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --repo https://charts.jetstack.io \
    --version v1.14.3 \
    --values values.cert-manager.yaml \
    --wait

# Dex #
helm upgrade --install dex dex \
    --namespace dex \
    --create-namespace \
    --repo https://charts.dexidp.io \
    --version 0.16.0 \
    --values values.dex.yaml \
    --wait

# Istio Base #
helm upgrade --install istio-base base \
    --namespace istio-system \
    --create-namespace \
    --repo https://istio-release.storage.googleapis.com/charts \
    --version 1.20.2 \
    --wait

# Istio Discovery #
helm upgrade --install istiod istiod \
    --namespace istio-system \
    --repo https://istio-release.storage.googleapis.com/charts \
    --version 1.20.2 \
    --values values.istiod.yaml \
    --wait

# Istio Ingress Gateway #
helm upgrade --install istio-ingressgateway gateway \
    --namespace istio-ingress \
    --create-namespace \
    --repo https://istio-release.storage.googleapis.com/charts \
    --version 1.20.2 \
    --values values.istio-ingressgateway.yaml \
    --wait

# Istio Cluster Local Gateway #
helm upgrade --install cluster-local-gateway gateway \
    --namespace istio-ingress \
    --create-namespace \
    --repo https://istio-release.storage.googleapis.com/charts \
    --version 1.20.2 \
    --values values.cluster-local-gateway.yaml \
    --wait

# Metacontroller #
helm upgrade --install metacontroller oci://ghcr.io/metacontroller/metacontroller-helm \
    --namespace metacontroller \
    --create-namespace \
    --version v2.6.1 \
    --values values.metacontroller.yaml \
    --wait

# Argo Workflows #
helm upgrade --install argo-workflows argo-workflows \
    --namespace kubeflow \
    --repo https://argoproj.github.io/argo-helm \
    --version 0.17.1 \
    --values values.argo-workflows.yaml \
    --wait

# KNative Operator #
# Using the latest v1.13.0 operator version, results in a compatibility error
# with underlying Kubernetes installation: "minKubernetesVersion >= 1.26"
helm upgrade --install knative-operator knative-operator \
    --repo https://raw.githubusercontent.com/kromanow94/knative-operator/main \
    --namespace knative-operator \
    --create-namespace \
    --version v1.11.12 \
    --wait

# Kubeflow CRDs #
helm upgrade --install kubeflow-crds ../../charts/kubeflow-crds \
    --namespace kubeflow \
    --values values.kubeflow-crds.yaml \
    --wait

# Kubeflow #
helm upgrade --install kubeflow ../../charts/kubeflow \
    --namespace kubeflow \
    --values values.kubeflow.yaml \
    --wait

# Kserve CRD #
helm upgrade --install kserve-crd oci://ghcr.io/kserve/charts/kserve-crd \
    --namespace kserve \
    --version v0.12.1 \
    --create-namespace \
    --wait

# Kserve #
# Kserve nedds to be installed after Kubeflow because Kubeflow Helm Chart provides
# KnativeServing which instructs knative-operator to install serving.knative.dev CRDs.
helm upgrade --install kserve oci://ghcr.io/kserve/charts/kserve \
    --namespace kserve \
    --create-namespace \
    --version v0.12.1 \
    --values values.kserve.yaml \
    --wait

# Kubeflow Profile #
# Create kubeflow-user-example-com profile for tests.
# Default password for user user@example.com:
# 12341234
kubectl apply -f profile.kubeflow-user-example-com.yaml

# oauth2-proxy #
# When k8s is deployed with in-cluster self-signed OIDC Issuer (kind, vcluster,
# minikube and so on), oauth2-proxy has to wait for CRB allowing access to OIDC
# Discovery endpoint from anonymous user. This CRB is deployed by kubeflow helm
# chart. See the following file for details:
# charts/kubeflow/templates/istio-integration/clusterrolebinding.unauthenticated-oidc-viewer.yaml
helm upgrade --install oauth2-proxy oauth2-proxy \
    --namespace oauth2-proxy \
    --create-namespace \
    --repo https://oauth2-proxy.github.io/manifests \
    --version 6.24.1 \
    --values values.oauth2-proxy.yaml \
    --wait
