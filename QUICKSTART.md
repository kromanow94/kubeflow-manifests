# Kind
This guide was created to help new users of Kubeflow install and test Kubeflow Helm Charts locally based on the kind.

## Requirements
* kind v0.25.0 or above
* helm v3.16.3 or above
* curl 8.7.1 or above

## Kind
To create the new cluster, you can use the configuration available in [kind/config.yaml](./kind/config.yaml) in this repository.

```bash
$ kind create cluster --config=config.yaml
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.29.10) 🖼
 ✓ Preparing nodes 📦 📦 📦 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
```

The above configuration will ensure that you are using a version of Kubernetes that is compatible with the version of Kubeflow Helm Charts.

## Helm
In addition to having the Helm cli installed, we suggest ensuring that you have an active cache to avoid the error:
`Error: no cached repo found. (try 'helm repo update')`

```
$ helm repo update
```

## Install
It's installation time!

```
$ curl -s https://raw.githubusercontent.com/kromanow94/kubeflow-manifests/refs/tags/kubeflow-0.3.0/example/helm/quickstart.helm.sh | bash
```
