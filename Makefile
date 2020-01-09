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

test:
	helm delete --purge mytest-chart || true
	helm install --name mytest-chart ./my-helm-test-$(HELM_VERSION).tgz
	helm ls --all
	# the test chart will install: a) a deployment, b) a service
	kubectl describe deployment mytest-chart-my-helm-test
	kubectl describe svc mytest-chart-my-helm-test
	# now verify if the mytest POD has been deployed successfully:
	kubectl describe pod
	

start-minikube:          # BEWARE: running twice seems a Bad Thing
	minikube start --vm-driver=none 
	# from https://docs.bitnami.com/kubernetes/get-started-kubernetes/
	curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
	chmod 700 get_helm.sh && ./get_helm.sh
	#helm init --service-account tiller  --> gives me an error like "no service account tiller found"
	helm init --history-max 200 --wait
	kubectl --namespace kube-system get pods | grep tiller
	kubectl --namespace kube-system get replicasets | grep tiller
	helm version
	