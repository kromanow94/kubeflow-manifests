# Kubeflow Manifests (WIP)

## Table of Contents

<!-- toc -->

- [Overview](#overview)
- [Kubeflow components versions](#kubeflow-components-versions)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)

<!-- tocstop -->

## Overview

This repo is owned by the [Roche Kubeflow Working Group](https://code.roche.com/kubeflow/).

The Kubeflow Manifests repository is organized in such a way that there will at least two (2) major releases supported by their official EOL and [Roadmap](https://github.com/kubeflow/kubeflow/blob/master/ROADMAP.md).

The main application structure includes manifests referenced from upstream [kubeflow/manifests](https://github.com/kubeflow/manifests/) repository.
The update frequency should match upstream release timelines, thus keeping pace with updates and fixes.

This repository is meant to be used as Git Submodule inside the [Kubeflow-Platform-Template](https://code.roche.com/kubeflow/platform-template) repo, acting as placeholder for upstream kubeflow common components.

## Kubeflow components versions

### Kubeflow Version: latest

Use the following git tag `tag=latest` when referencing this repository from Kustomize/ArgoCD application resources:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - https://code.roche.com/kubeflow/manifests?ref=latest
```

This repo periodically syncs all official Kubeflow components from their respective upstream repos. The following matrix shows the git version that we include for each component:

| Component                 | Remote Manifests Path                            | Upstream Revision                                                                                            |
| ------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------ |
| Training Operator         | apps/training-operator/upstream                  | [v1.5.0](https://github.com/kubeflow/training-operator/tree/v1.5.0/manifests)                                |
| Notebook Controller       | apps/jupyter/notebook-controller/upstream        | [v1.6.1](https://github.com/kubeflow/kubeflow/tree/v1.6.1/components/notebook-controller/config)             |
| Tensorboard Controller    | apps/tensorboard/tensorboard-controller/upstream | [v1.6.1](https://github.com/kubeflow/kubeflow/tree/v1.6.1/components/tensorboard-controller/config)          |
| Central Dashboard         | apps/centraldashboard/upstream                   | [v1.6.1](https://github.com/kubeflow/kubeflow/tree/v1.6.1/components/centraldashboard/manifests)             |
| Profiles + KFAM           | apps/profiles/upstream                           | [v1.6.1](https://github.com/kubeflow/kubeflow/tree/v1.6.1/components/profile-controller/config)              |
| PodDefaults Webhook       | apps/admission-webhook/upstream                  | [v1.6.1](https://github.com/kubeflow/kubeflow/tree/v1.6.1/components/admission-webhook/manifests)            |
| Jupyter Web App           | apps/jupyter/jupyter-web-app/upstream            | [v1.6.1](https://github.com/kubeflow/kubeflow/tree/v1.6.1/components/crud-web-apps/jupyter/manifests)        |
| Tensorboards Web App      | apps/tensorboard/tensorboards-web-app/upstream   | [v1.6.1](https://github.com/kubeflow/kubeflow/tree/v1.6.1/components/crud-web-apps/tensorboards/manifests)   |
| Volumes Web App           | apps/volumes-web-app/upstream                    | [v1.6.1](https://github.com/kubeflow/kubeflow/tree/v1.6.1/components/crud-web-apps/volumes/manifests)        |
| Katib                     | apps/katib/upstream                              | [v0.14.0-rc.0](https://github.com/kubeflow/katib/tree/v0.14.0-rc.0/manifests/v1beta1)                        |
| KServe                    | contrib/kserve/kserve                            | [release-0.8](https://github.com/kserve/kserve/tree/8079f375cbcedc4d45a1b4aade2e2308ea6f9ae8/install/v0.8.0) |
| KServe Models Web App     | contrib/kserve/models-web-app                    | [v0.8.1](https://github.com/kserve/models-web-app/tree/v0.8.1/config)                                        |
| Kubeflow Pipelines        | apps/pipeline/upstream                           | [2.0.0-alpha.5](https://github.com/kubeflow/pipelines/tree/2.0.0-alpha.5/manifests/kustomize)                |
| Kubeflow Tekton Pipelines | apps/kfp-tekton/upstream                         | [v1.2.1](https://github.com/kubeflow/kfp-tekton/tree/v1.2.1/manifests/kustomize)                             |

The following is also a matrix with versions from common components that are
used from the different projects of Kubeflow:

| Component    | Remote Manifests Path | Upstream Revision                                                         |
| ------------ | --------------------- | ------------------------------------------------------------------------- |
| Istio        | common/istio-1-14     | [1.14.1](https://github.com/istio/istio/releases/tag/1.14.1)              |
| Knative      | common/knative        | [1.2.5](https://github.com/knative/serving/releases/tag/knative-v1.2.5)   |
| Cert Manager | common/cert-manager   | [1.5.0](https://github.com/cert-manager/cert-manager/releases/tag/v1.5.0) |

## Installation

The deployment pattern described here assumes you are deploying all resources on top of a already configured Kubernetes cluster, using this repo as a Submodule. It should be referenced using an explicit **release version tag**.

### Prerequisites

- `Kubernetes` (up to `1.25`) with a default [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- `kustomize` [5.0.0](https://github.com/kubernetes-sigs/kustomize/releases/tag/kustomize%2Fv5.0.0)
  - :warning: Kubeflow is not compatible with earlier versions of Kustomize. This is because we need the [`sortOptions`](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/sortoptions/) field, which is only available in Kustomize 5 and onwards https://github.com/kubeflow/manifests/issues/2388.
- `kubectl`
