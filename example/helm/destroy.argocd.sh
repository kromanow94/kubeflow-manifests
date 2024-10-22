#!/bin/bash
set -x

# oauth2-proxy #
kubectl -n argocd delete app oauth2-proxy

# Kubeflow Profile #
kubectl -n argocd delete app profile-kubeflow-user-example-com

# Kubeflow Instance #
kubectl -n argocd delete app kubeflow
kubectl -n argocd delete app crds

# KServe #
kubectl -n argocd delete app kserve
kubectl -n argocd delete app kserve-crd

# Knative #
kubectl -n argocd delete app knative-operator
kubectl -n argocd delete app knative-namespaces

# Argo WF #
kubectl -n argocd delete app argo-workflows

# Metacontroller #
kubectl -n argocd delete app metacontroller

# istio-ingressgateway #
kubectl -n argocd delete app istio-ingressgateway

# cluster-local-gateway #
kubectl -n argocd delete app cluster-local-gateway

# istiod #
kubectl -n argocd delete app istiod

# istio-base #
kubectl -n argocd delete app istio-base

# Dex #
kubectl -n argocd delete app dex

# cert-manager #
kubectl -n argocd delete app cert-manager

# MinIO #
kubectl -n argocd delete app minio

# MySQL #
kubectl -n argocd delete app mysql

# Kubeflow Secrets #
kubectl -n argocd delete app kubeflow-secrets
