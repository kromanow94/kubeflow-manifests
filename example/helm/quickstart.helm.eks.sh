#!/bin/bash
set -e

KNATIVE_OPERATOR_VERSION="${KNATIVE_OPERATOR_VERSION:-1.11.12}"
KNATIVE_OPERATOR_HELM_CHART_ARCHIVE_URL="${KNATIVE_OPERATOR_HELM_CHART_ARCHIVE_URL:-https://github.com/knative/operator/releases/download/knative-v${KNATIVE_OPERATOR_VERSION}/knative-operator-${KNATIVE_OPERATOR_VERSION}.tgz}"

KSERVE_VERSION="${KSERVE_VERSION:-v0.11.2}"
KSERVE_HELM_CHART_ARCHIVE_URL="${KSERVE_HELM_CHART_ARCHIVE_URL:-https://github.com/kserve/kserve/releases/download/${KSERVE_VERSION}/helm-chart-kserve-${KSERVE_VERSION}.tgz}"
KSERVE_CRD_HELM_CHART_ARCHIVE_URL="${KSERVE_CRD_HELM_CHART_ARCHIVE_URL:-https://github.com/kserve/kserve/releases/download/${KSERVE_VERSION}/helm-chart-kserve-crd-${KSERVE_VERSION}.tgz}"

cat <<EOF
WARNING: This script is for reference only and will not work out of the box.
Also, it assumes the script is run from a locally cloned git repository.

'kubeflow' and 'oauth2-proxy' Helm Charts needs to be parameterized for AWS IAM
OIDC Issuer to enable access through M2M Service Account Tokens.

For required parameterization, please see the following files and replace
'https://oidc.eks.<region>.amazonaws.com/id/1234567890' with your AWS IAM OIDC Issuer URL.
* example/helm/values.kubeflow.eks.yaml
* example/helm/values.oauth2-proxy.eks.yaml

Assuming you've cloned this repository and are using it locally, you can
parameterize the AWS IAM OIDC Issuer URL with:
$ OIDC_ISSUER_URL=https://oidc.eks.<region>.amazonaws.com/id/1234567890
$ grep -Rl 'https://oidc.eks.<region>.amazonaws.com/id/1234567890' --exclude 'quickstart*' \\
    | xargs sed "s;https://oidc.eks.<region>.amazonaws.com/id/1234567890;\$OIDC_ISSUER_URL;g" -i

After this step, this script should work.

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
kubectl apply -f namespace.knative-serving.yaml
kubectl apply -f namespace.knative-eventing.yaml
helm upgrade --install knative-operator "${KNATIVE_OPERATOR_HELM_CHART_ARCHIVE_URL}" \
    --namespace knative \
    --create-namespace \
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
    --values values.kserve.yaml \
    --wait

# Kubeflow #
helm upgrade --install kubeflow ../../charts/kubeflow \
    --namespace kubeflow \
    --values values.kubeflow.eks.yaml \
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
    --values values.oauth2-proxy.eks.yaml \
    --wait
