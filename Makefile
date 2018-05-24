.PHONY: deploy-operator clean-operator clean-cassandra build-app docker-app-build minikube-deploy minikube-start docker-clean

DIST_ROOT=dist
KUBE_INSTALL := $(shell command -v kubectl 2> /dev/null)
REPO=niravpatel/k8s-cassandra-fullstack
KEY_SPACE=accountsapi
CASSANDRA_CLUSTER_URL=cassandra.default.svc.cluster.local
all: package

check:
ifndef KUBE_INSTALL 
    $(error "kubectl is not available please install from https://kubernetes.io/")
endif

deploy-operator: check
	kubectl apply -f bundle.yaml

provision-cassandra:
	kubectl create -f manifest/example.yaml

clean-operator: check
	kubectl delete -f manifest/bundle.yaml

clean-cassandra:
	kubectl delete -f manifest/example.yaml

build-app:
	GOOS=linux go build -o main . 

docker-app-build: check build-app
	@eval $$(minikube docker-env) ;\
	docker build -t $(REPO):latest .

docker-clean:
	docker rmi $(REPO)

minikube-deploy: 
	kubectl run web --image=$(REPO):latest --port=8080 -e KEY_SPACE=$(KEY_SPACE) -e CASSANDRA_CLUSTER_URL=$(CASSANDRA_CLUSTER_URL) --image-pull-policy=Never
	kubectl expose deployment web --target-port=8080 --type=NodePort
	echo $(shell minikube service web --url)

minikube-start: 
	minikube start --cpus 4 --memory 4096 --vm-driver hyperkit --kubernetes-version v1.9.4
