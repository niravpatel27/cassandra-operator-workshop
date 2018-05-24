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

Create a deployment for Cassandra Operator

```
$ make deploy-operator
```

Verify the Service was created and a port was allocated:

````
$ kubectl get services
NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
cassandra         ClusterIP   None           <none>        9042/TCP         1m
cassandra-seeds   ClusterIP   None           <none>        7000/TCP         1m

$ kubectl get pods
NAME                                  READY     STATUS    RESTARTS   AGE
cassandra-operator-847947679f-sk88d   1/1       Running   0          1m
```

## Provision Cassandra Cluster

Create a deployment for Cassandra Cluster
```
$ make provision-cassandra
```

Verify the Pod was created:

```
$ kubectl get pods
NAME                                  READY     STATUS    RESTARTS   AGE
cassandra-0                           1/1       Running   0          1m
```

## Tearing down your Operator deployment

```
$ make clean-operator
```

## Cassandra initial setup

### Launch `cqlsh` and execute:

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

Verify the Service was created and a node port was allocated:
```
$ kubectl get service web
NAME      TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
web       NodePort   10.108.82.46   <none>        8080:32491/TCP   1h
```

### To run locally, get public API endpoint
```
$ minikube service web --url
http://192.168.64.6:32491
```
### Create Account


### Get Account