#!/bin/bash
set -x

# kubeflow-app-of-apps #
kubectl -n argocd delete app kubeflow-app-of-apps
