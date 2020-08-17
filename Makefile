#
# Makefile to allow building and testing the Helm chart
# See https://www.baeldung.com/kubernetes-helm
#

# HELM_VERSION must match the one in Chart.yaml
HELM_VERSION:=1.2.0-helm



all:
	helm lint .
	helm template .
	helm package .

# This test target does a lot of thing.
# The suggestion is to run each command one by one till you get familiar with what it does:
test:
	helm uninstall mytest-chart || true
	helm install mytest-chart ./my-helm-test-$(HELM_VERSION).tgz
	@read -n1 -p " ****************** Hit a key to continue ****************** "
	helm ls --all
	@read -n1 -p " ****************** Hit a key to continue ****************** "
	# the test chart will install: a) a deployment, b) a service, c) a configmpa
	@echo
	@echo
	kubectl describe deployment mytest-chart-my-helm-test
	@echo
	@echo
	kubectl describe svc mytest-chart-my-helm-test
	@echo
	@echo
	kubectl describe configmap mychart-configmap
	@echo
	@echo
	@read -n1 -p " ****************** Hit a key to continue ****************** "
	# now verify if the mytest POD has been deployed successfully:
	kubectl get pod -o wide
	@echo
	@echo
	@read -n1 -p " ****************** Hit a key to continue ****************** "
	kubectl describe pod
	@echo
	@echo
	@read -n1 -p " ****************** Hit a key to continue ****************** "
	kubectl logs $(shell kubectl get pod --selector=app.kubernetes.io/instance=mytest-chart -o json | jq -r '.items[0].metadata.name')
	@echo
	@echo

run-pod-bash:
	kubectl exec -ti $(shell kubectl get pod --selector=app.kubernetes.io/instance=mytest-chart -o json | jq -r '.items[0].metadata.name') -- /bin/bash

#
#start-minikube:          # BEWARE: running twice seems a Bad Thing
#	minikube start --vm-driver=none 
#	# from https://docs.bitnami.com/kubernetes/get-started-kubernetes/
#	curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
#	chmod 700 get_helm.sh && ./get_helm.sh
#	#helm init --service-account tiller  --> gives me an error like "no service account tiller found"
#	helm init --history-max 200 --wait
#	kubectl --namespace kube-system get pods | grep tiller
#	kubectl --namespace kube-system get replicasets | grep tiller
#	helm version
#	