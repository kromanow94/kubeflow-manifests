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
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  labels:
    istio-injection: enabled
  name: kubeflow
EOF

# Create secret with database credentials for KFP and MySQL
export DB_CONFIG_SECRET_NAME=db-credentials
kubectl apply -f "secret.${DB_CONFIG_SECRET_NAME}.yaml"

# Create mlpipeline-minio-artifact K8s Secret holding secrets for KFP and MinIO.
export OBJECTSTORE_CONFIG_SECRET_NAME=mlpipeline-minio-artifact
kubectl apply -f "secret.${OBJECTSTORE_CONFIG_SECRET_NAME}.yaml"

helm upgrade --install mysql mysql \
    --namespace kubeflow \
    --repo https://charts.bitnami.com/bitnami \
    --version 9.21.2 \
    --values values.mysql.yaml \
    --wait

helm upgrade --install minio minio \
    --namespace kubeflow \
    --repo https://charts.bitnami.com/bitnami \
    --version 13.7.0 \
    --values values.minio.yaml \
    --wait

helm upgrade --install cert-manager cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --repo https://charts.jetstack.io \
    --version v1.14.3 \
    --values values.cert-manager.yaml \
    --wait

helm upgrade --install dex dex \
    --namespace dex \
    --create-namespace \
    --repo https://charts.dexidp.io \
    --version 0.16.0 \
    --values values.dex.yaml \
    --wait

helm upgrade --install istio-base base \
    --namespace istio-system \
    --create-namespace \
    --repo https://istio-release.storage.googleapis.com/charts \
    --version 1.20.2 \
    --wait

helm upgrade --install istiod istiod \
    --namespace istio-system \
    --repo https://istio-release.storage.googleapis.com/charts \
    --version 1.20.2 \
    --values values.istiod.yaml \
    --wait

helm upgrade --install istio-ingressgateway gateway \
    --namespace istio-ingress \
    --create-namespace \
    --repo https://istio-release.storage.googleapis.com/charts \
    --version 1.20.2 \
    --values values.istio-ingressgateway.yaml \
    --wait

helm upgrade --install metacontroller oci://ghcr.io/metacontroller/metacontroller-helm \
    --namespace metacontroller \
    --create-namespace \
    --version v2.6.1 \
    --values values.metacontroller.yaml \
    --wait

helm upgrade --install argo-workflows argo-workflows \
    --namespace kubeflow \
    --repo https://argoproj.github.io/argo-helm \
    --version 0.17.1 \
    --values values.argo-workflows.yaml \
    --wait

helm upgrade --install kubeflow \
    --namespace kubeflow \
    ../../charts/kubeflow \
    --values values.kubeflow.yaml \
    --wait

# Create kubeflow-user-example-com profile for tests.
# Default password for user user@example.com:
# 12341234
kubectl apply -f profile.kubeflow-user-example-com.yaml

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
