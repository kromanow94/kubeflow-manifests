
pods:
	kubectl get pods -n $(K8S_NAMESPACE)
tail:
	kubectl logs -f $(TAIL_POD) -n $(K8S_NAMESPACE)

port-forward:
	kubectl port-forward -n $(K8S_NAMESPACE) svc/$(K8S_PORT_FORWARD_SERVICE)  $(K8S_PORT_FORWARD_SRC_PORT):$(K8S_PORT_FORWARD_TARGET_PORT)