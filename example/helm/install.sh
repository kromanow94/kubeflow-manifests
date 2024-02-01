#!/bin/bash
set -ex

kubectl create ns istio-system || true
kubectl create ns istio-ingress || true
kubectl create ns kubeflow || true

helm upgrade --install \
	istio-base \
	base \
	--repo https://istio-release.storage.googleapis.com/charts \
	--kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context \
	--namespace istio-system

helm upgrade --install --wait \
	istiod \
	istiod \
	--repo https://istio-release.storage.googleapis.com/charts \
	--kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context \
	--namespace istio-system

helm upgrade --install \
	istio-ingressgateway \
	gateway \
	--repo https://istio-release.storage.googleapis.com/charts \
	--kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context \
	--namespace istio-ingress

helm upgrade --install \
	kubeflow \
	charts/kubeflow \
	--kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context \
	--namespace kubeflow
