#!/bin/bash
set -ex

kubectl apply -f example/helm/clusterrolebinding.unauthenticated-oidc-viewer.yaml

kubectl create ns dex || true
kubectl create ns oauth2-proxy || true
kubectl create ns istio-system || true
kubectl create ns istio-ingress || true
kubectl create ns kubeflow || true
kubectl label namespace kubeflow istio-injection=enabled --overwrite

helm upgrade --install \
	dex \
	dex \
	--repo https://charts.dexidp.io \
	--values example/helm/values.dex.yaml \
	--kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context \
	--namespace dex

helm upgrade --install \
	oauth2-proxy \
	oauth2-proxy \
	--repo https://oauth2-proxy.github.io/manifests \
	--values example/helm/values.oauth2-proxy.yaml \
	--kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context \
	--namespace oauth2-proxy

helm upgrade --install \
	istio-base \
	base \
	--repo https://istio-release.storage.googleapis.com/charts \
	--kube-context vcluster_romanok1-kubeflow_vcluster-romanok1-kubeflow_uat-context \
	--namespace istio-system

# Add mesh config for oauth2-proxy!
helm upgrade --install --wait \
	istiod \
	istiod \
	--repo https://istio-release.storage.googleapis.com/charts \
	--values example/helm/values.istiod.yaml \
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


kubectl apply -f example/helm/requestauthentication.yaml

# here deploy job to place jwks in the RequestAuthentication
# https://github.com/kubeflow/manifests/pull/2544/files
# common/oidc-client/oauth2-proxy/components/configure-self-signed-kubernetes-oidc-issuer/script.sh
kubectl apply -f example/helm/job.configure-self-signed-issuer.yaml

# This should go to metacontroller
kubectl apply -f example/helm/authorizationpolicy.yaml

# NOTES!
# ---
# newly created notebook provide wrong gateway reference(missing namespace):
#   gateways:
#   - kubeflow-gateway
# ---
# Default ns-owner-access-istio doesn't allow access to notebook.
# Deleting it helps.
