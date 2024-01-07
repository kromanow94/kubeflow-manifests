#!/bin/bash
set -ex

kubectl create ns istio-system || true
kubectl create ns istio-ingress || true
kubectl create ns kubeflow || true

helm upgrade --install istio-base base --namespace istio-system --kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context --repo https://istio-release.storage.googleapis.com/charts
helm upgrade --install istiod istiod --kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context --namespace istio-system --repo https://istio-release.storage.googleapis.com/charts
helm upgrade --install istio-ingressgateway gateway --kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context --namespace istio-ingress --repo https://istio-release.storage.googleapis.com/charts
helm upgrade --install kubeflow charts/kubeflow --kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context --namespace kubeflow
