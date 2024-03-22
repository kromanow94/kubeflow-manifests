#!/bin/bash
set -e

cat <<EOF
This script will check if ArgoCD is installed, install ArgoCD if not installed
and apply ArgoCD Apps for each dependency and kubeflow Helm Chart.

This script will also apply the Apps in the correct order and will wait until
the dependencies are ready.

Press 'Ctrl'+'C' to cancel.
Waiting 10 seconds...
EOF
sleep 10

echo "Checking if ArgoCD is deployed on the cluster..."
if kubectl get ns argocd 1>/dev/null 2>&1; then
    echo "ArgoCD installed on the cluster, skipping to applying ArgoCD Apps manifests."
else
    echo "ArgoCD not installed, installing..."
    kubectl create namespace argocd || true
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl wait pods --namespace argocd --all --for=condition=Ready --timeout 300s
    echo "ArgoCD installation successful, applying ArgoCD Apps manifests."
fi

set -x
kubectl apply -f app.mysql.yaml
kubectl apply -f app.minio.yaml
kubectl apply -f app.cert-manager.yaml
kubectl apply -f app.dex.yaml
kubectl apply -f app.istio-base.yaml
kubectl apply -f app.istiod.yaml
kubectl apply -f app.metacontroller.yaml
set +x

# Wait until pods are created. This is not required since ArgoCD will be
# eventually consistent but will bring the Kubeflow faster.
echo "Sleeping 30 seconds until pods are created..."
sleep 30
kubectl wait pods --all -n kubeflow --for=condition=Ready --timeout 300s

set -x
kubectl apply -f app.argo-workflows.yaml
kubectl apply -f app.istio-ingressgateway.yaml
kubectl apply -f app.kubeflow.yaml
set +x

# Wait until pods are created. This is not required since ArgoCD will be
# eventually consistent but will bring the Kubeflow faster.
echo "Sleeping 10 seconds until pods are created..."
sleep 10
kubectl wait pods --all --namespace kubeflow --for=condition=Ready --timeout 300s

set -x
kubectl apply -f app.profile-kubeflow-user-example-com.yaml
set +x

# When deployed with in-cluster self-signed OIDC Issuer (kind, vcluster,
# minikube and so on), oauth2-proxy has to wait for CRB allowing accessing OIDC
# Discovery endpoint from anonymous user. This is condifured by kubeflow helm
# chart.
set -x
kubectl apply -f app.oauth2-proxy.yaml
set +x

# Wait until pods are created. This is not required since ArgoCD will be
# eventually consistent but will bring the Kubeflow faster.
echo "Sleeping 10 seconds until pods are created..."
sleep 10
kubectl wait pods --all --namespace oauth2-proxy --for=condition=Ready --timeout 300s
