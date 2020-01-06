all:
	helm lint .
	helm package .
