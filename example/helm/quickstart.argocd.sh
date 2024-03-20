#!/bin/bash
set -ex

# TODO
# * check argocd outofsync thing...
# * oidc job is not the best... Change to cron?
# * can the wait commands be improved?
# * kfp pipelines is currently failing... maybe services names are wrong?
#   * check logs

kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait pods --namespace argocd --all --for=condition=Ready --timeout 300s

kubectl apply -f app.mysql.yaml
kubectl apply -f app.minio.yaml
kubectl apply -f app.cert-manager.yaml
kubectl apply -f app.dex.yaml
kubectl apply -f app.istio-base.yaml
kubectl apply -f app.istiod.yaml
kubectl apply -f app.metacontroller.yaml

# Wait until pods are created. This is not required since ArgoCD will be
# eventually consistent but will bring the Kubeflow faster.
echo "Sleeping 30 seconds until pods are created..."
sleep 30
kubectl wait pods --all -n kubeflow --for=condition=Ready --timeout 300s

kubectl apply -f app.argo-workflows.yaml
kubectl apply -f app.istio-ingressgateway.yaml
kubectl apply -f app.kubeflow.yaml

# Wait until pods are created. This is not required since ArgoCD will be
# eventually consistent but will bring the Kubeflow faster.
echo "Sleeping 10 seconds until pods are created..."
sleep 10
kubectl wait pods --all --namespace kubeflow --for=condition=Ready --timeout 300s

kubectl apply -f app.profile-kubeflow-user-example-com.yaml

# When deployed with in-cluster self-signed OIDC Issuer (kind, vcluster,
# minikube and so on), oauth2-proxy has to wait for CRB allowing accessing OIDC
# Discovery endpoint from anonymous user. This is condifured by kubeflow helm
# chart.
kubectl apply -f app.oauth2-proxy.yaml

# Wait until pods are created. This is not required since ArgoCD will be
# eventually consistent but will bring the Kubeflow faster.
echo "Sleeping 10 seconds until pods are created..."
sleep 10
kubectl wait pods --all --namespace oauth2-proxy --for=condition=Ready --timeout 300s
