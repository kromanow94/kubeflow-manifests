#!/bin/bash
set -euo pipefail
echo "Installing KNative ..."
set +e
kustomize build common/knative/knative-serving/base | kubectl apply -f -
set -e
kustomize build common/knative/knative-serving/base | kubectl apply -f -

kustomize build common/istio-1-21/cluster-local-gateway/base | kubectl apply -f -
kustomize build common/istio-1-21/kubeflow-istio-resources/base | kubectl apply -f -

# kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout 600s
# ./tests/gh-actions/wait_for_pods_running_or_completed.sh --all-namespaces
kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=600s \
  --field-selector=status.phase!=Succeeded

kubectl patch cm config-domain --patch '{"data":{"example.com":""}}' -n knative-serving
