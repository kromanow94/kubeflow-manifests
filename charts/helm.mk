add:
	helm repo add $(REPO_NAME) $(REPO_URL)
update:
	helm dependency update ./

template:
	helm template $(HELM_CHART_RELEASE_NAME) ./ \
		--output-dir rendered \
		--dry-run \
		-n $(K8S_NAMESPACE) \
		--debug

all:
	helm template $(HELM_CHART_RELEASE_NAME) -n $(K8S_NAMESPACE) . > all.yaml

apply-all: all
	kubectl apply -f  all.yaml -n $(K8S_NAMESPACE)
