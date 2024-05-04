#!/bin/bash
set -x

# oauth2-proxy #
helm -n oauth2-proxy uninstall oauth2-proxy --wait=true

# Kubeflow Profile #
kubectl delete profile kubeflow-user-example-com
kubectl wait --for=delete namespace/kubeflow-user-example-com --timeout=120s

# Kubeflow Instance #
helm -n kubeflow uninstall kubeflow --wait

# Argo WF #
helm -n kubeflow uninstall argo-workflows --wait

# Metacontroller #
helm -n metacontroller uninstall metacontroller --wait

# istio-ingressgateway #
helm -n istio-ingress uninstall istio-ingressgateway --wait

# istiod #
helm -n istio-system uninstall istiod --wait

# istio-base #
helm -n istio-system uninstall istio-base --wait

# Dex #
helm -n dex uninstall dex --wait

# cert-manager #
helm -n cert-manager uninstall cert-manager --wait

# MinIO #
helm -n kubeflow uninstall minio --wait

# MySQL #
helm -n kubeflow uninstall mysql --wait

# wait for all pods to be deleted and cleanup kubflow namespace #
kubectl -n kubeflow wait --for=delete pods --all --timeout=60s
kubectl delete ns kubeflow
