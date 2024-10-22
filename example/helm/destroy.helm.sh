#!/bin/bash
set -x

# oauth2-proxy #
helm -n oauth2-proxy uninstall oauth2-proxy --wait=true

# Kubeflow Profile #
kubectl delete profile kubeflow-user-example-com
kubectl wait --for=delete namespace/kubeflow-user-example-com --timeout=120s

# Kubeflow #
helm -n kubeflow uninstall kubeflow --wait
helm -n kubeflow uninstall crds --wait

# KServe #
helm -n kubeflow uninstall kserve
helm -n kubeflow uninstall kserve-crd

# Knative #
helm -n knative uninstall knative-operator
kubectl delete ns knative-serving
kubectl delete ns knative-eventing

# Argo Workflows #
helm -n kubeflow uninstall argo-workflows --wait

# Metacontroller #
helm -n metacontroller uninstall metacontroller --wait

# Istio Ingress Gateway #
helm -n istio-ingress uninstall istio-ingressgateway --wait

# Istio Cluster Local Gateway #
helm -n istio-ingress uninstall cluster-local-gateway --wait

# Istio Discovery #
helm -n istio-system uninstall istiod --wait

# Istio Base #
helm -n istio-system uninstall istio-base --wait

# Dex #
helm -n dex uninstall dex --wait

# cert-manager #
helm -n cert-manager uninstall cert-manager --wait

# MinIO #
helm -n kubeflow uninstall minio --wait

# MySQL #
helm -n kubeflow uninstall mysql --wait

# Kubeflow Namespace #
kubectl delete namespace kubeflow
