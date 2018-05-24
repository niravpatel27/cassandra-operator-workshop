# Cassandra Operator workshop

## Requirements
* Kubernetes 1.8+

## Minikube
 
 * [Install](https://kubernetes.io/docs/tasks/tools/install-minikube/)

```
# start
$ minikube start --cpus 4 --memory 4096 --vm-driver hyperkit --kubernetes-version v1.9.4
```

## Deploy Cassandra Operator 

```
$ make deploy-operator
```

## Provision Cassandra Cluster

```
$ make provision-cassandra
```

## Tearing down your Operator deployment

```
$ make clean-operator
```

## Cassandra initial setup

### Launch Launch `cqlsh` and execute:

```
$ kubectl exec cassandra-0 -i -t -- bash -c 'cqlsh cassandra-seeds'
$ CREATE KEYSPACE accountsapi WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};
$ use accountsapi; CREATE TABLE accounts (id UUID,name text,age int,email text,city text,PRIMARY KEY (id));
```

## Go client app

### Build

```
$ make docker-app-build
```

### Deploy to mini-kube

```
$ make minikube-deploy
```

### Create Account


### Get Account