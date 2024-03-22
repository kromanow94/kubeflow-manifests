#!/bin/bash
set -e

cat <<EOF
This script will install ArgoCD, configure it to enable health assessment
required for using sync-waves for ArgoCD Apps and deploy App of Apps manifest
for kubeflow and it's dependencies.

If you only want to apply the App of Apps manifest, cancel this script and execute:
$ kubectl apply -f https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/kubeflow-0.1.2/example/helm/app.app-of-apps.yaml

Press 'Ctrl'+'C' to cancel.
Waiting 10 seconds...
EOF
sleep 10

set -x
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# To enable sync-waves for ArgoCD Applications, argocd-cm has to be patched to
# enable the health assessment of applications which has been removed in version
# 1.8 of ArgoCD.
# This is based on:
# https://kubito.dev/posts/enable-argocd-sync-wave-between-apps/
kubectl patch configmap argocd-cm -n argocd --type merge --patch '
data:
  resource.customizations.health.argoproj.io_Application: |
    hs = {}
    hs.status = "Progressing"
    hs.message = ""
    if obj.status ~= nil then
      if obj.status.health ~= nil then
        hs.status = obj.status.health.status
        if obj.status.health.message ~= nil then
          hs.message = obj.status.health.message
        end
      end
    end
    return hs
'

kubectl wait pods --namespace argocd --all --for=condition=Ready --timeout 300s

kubectl apply -f app.app-of-apps.yaml
