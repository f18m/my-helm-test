# my-helm-test
Testing Kubernetes/Helm world.
This project contains a simple chart and a Makefile to easily lint and package the chart and test it against
a Kubernetes installation (that you must have already up and running). Helm v3 is required.

## How I built my test environment on Centos7

```
curl -sfL https://get.k3s.io | sh -

export KUBECONFIG="~/.kube/config:/etc/rancher/k3s/k3s.yaml"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```


## Resources

* Rancher k3s: https://k3s.io/
* Official installation of Helm: https://helm.sh/docs/intro/install/
* A getting-started guide on Helm: https://www.baeldung.com/kubernetes-helm
