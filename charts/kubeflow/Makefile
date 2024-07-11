include ../helm.mk

.DEFAULT_GOAL := all

HELM_CHART_RELEASE_NAME=$(shell sed -En 's/^name:[[:space:]]+//p' Chart.yaml)
HELM_CHART_VERSION=$(shell sed -En 's/^version:[[:space:]]+//p' Chart.yaml)
K8S_NAMESPACE=kubeflow
TAIL_POD=`kubectl get pods -n $(namespace) -lapp.kubernetes.io/name=katib-ui --output jsonpath='{.items[0].metadata.name}'`
K8S_PORT_FORWARD_SRC_PORT=8082
K8S_PORT_FORWARD_TARGET_PORT=800
K8S_PORT_FORWARD_SERVICE=katib-ui

