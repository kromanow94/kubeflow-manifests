#!/bin/bash
set -e

TARGET_REVISION="${TARGET_REVISION:-helmcharts}"

KNATIVE_OPERATOR_VERSION="${KNATIVE_OPERATOR_VERSION:-1.11.12}"
KNATIVE_OPERATOR_HELM_CHART_ARCHIVE_URL="${KNATIVE_OPERATOR_HELM_CHART_ARCHIVE_URL:-https://github.com/knative/operator/releases/download/knative-v${KNATIVE_OPERATOR_VERSION}/knative-operator-${KNATIVE_OPERATOR_VERSION}.tgz}"

KSERVE_VERSION="${KSERVE_VERSION:-v0.11.2}"
KSERVE_HELM_CHART_ARCHIVE_URL="${KSERVE_HELM_CHART_ARCHIVE_URL:-https://github.com/kserve/kserve/releases/download/${KSERVE_VERSION}/helm-chart-kserve-${KSERVE_VERSION}.tgz}"
KSERVE_CRD_HELM_CHART_ARCHIVE_URL="${KSERVE_CRD_HELM_CHART_ARCHIVE_URL:-https://github.com/kserve/kserve/releases/download/${KSERVE_VERSION}/helm-chart-kserve-crd-${KSERVE_VERSION}.tgz}"

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

# Kubeflow Namespace #
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
kubectl apply -f "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/secret.${DB_CONFIG_SECRET_NAME}.yaml"

# Create mlpipeline-minio-artifact K8s Secret holding secrets for KFP and MinIO.
export OBJECTSTORE_CONFIG_SECRET_NAME=mlpipeline-minio-artifact
kubectl apply -f "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/secret.${OBJECTSTORE_CONFIG_SECRET_NAME}.yaml"

# MySQL #
helm upgrade --install mysql mysql \
    --namespace kubeflow \
    --repo https://charts.bitnami.com/bitnami \
    --version 9.21.2 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.mysql.yaml" \
    --wait

# MinIO #
helm upgrade --install minio minio \
    --namespace kubeflow \
    --repo https://charts.bitnami.com/bitnami \
    --version 13.7.0 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.minio.yaml" \
    --wait

# cert-manager #
helm upgrade --install cert-manager cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --repo https://charts.jetstack.io \
    --version v1.14.3 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.cert-manager.yaml" \
    --wait

# Dex #
helm upgrade --install dex dex \
    --namespace dex \
    --create-namespace \
    --repo https://charts.dexidp.io \
    --version 0.16.0 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.dex.yaml" \
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
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.istiod.yaml" \
    --wait

# Istio Ingress Gateway #
helm upgrade --install istio-ingressgateway gateway \
    --namespace istio-ingress \
    --create-namespace \
    --repo https://istio-release.storage.googleapis.com/charts \
    --version 1.20.2 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.istio-ingressgateway.yaml" \
    --wait

# Metacontroller #
helm upgrade --install metacontroller oci://ghcr.io/metacontroller/metacontroller-helm \
    --namespace metacontroller \
    --create-namespace \
    --version v2.6.1 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.metacontroller.yaml" \
    --wait

# Argo Workflows #
helm upgrade --install argo-workflows argo-workflows \
    --namespace kubeflow \
    --repo https://argoproj.github.io/argo-helm \
    --version 0.17.1 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.argo-workflows.yaml" \
    --wait

# KNative Operator #
kubectl apply -f "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/namespace.knative-serving.yaml"
kubectl apply -f "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/namespace.knative-eventing.yaml"
helm upgrade --install knative-operator "${KNATIVE_OPERATOR_HELM_CHART_ARCHIVE_URL}" \
    --namespace knative \
    --wait

# KServe CRDs #
helm upgrade --install kserve-crd "${KSERVE_CRD_HELM_CHART_ARCHIVE_URL}" \
    --namespace kubeflow \
    --create-namespace \
    --wait

# KServe #
helm upgrade --install kserve "${KSERVE_HELM_CHART_ARCHIVE_URL}" \
    --namespace kubeflow \
    --create-namespace \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.kserve.yaml" \
    --wait

# Kubeflow CRDs #
helm upgrade --install kubeflow-crds ../../charts/kubeflow-crds \
    --namespace kubeflow \
    --repo https://kromanow94.github.io/kubeflow-manifests \
    --version 0.2.0 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.kubeflow-crds.yaml" \
    --wait

# Kubeflow fatchart #
helm upgrade --install kubeflow kubeflow \
    --namespace kubeflow \
    --repo https://kromanow94.github.io/kubeflow-manifests \
    --version 0.2.0 \
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.kubeflow.yaml" \
    --wait

# Kubeflow Profile #
# Create kubeflow-user-example-com profile for tests.
# Default password for user user@example.com:
# 12341234
kubectl apply -f "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/profile.kubeflow-user-example-com.yaml"

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
    --values "https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/${TARGET_REVISION}/example/helm/values.oauth2-proxy.yaml" \
    --wait
