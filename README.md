# Docker Redis

## Introduction

### What is Redis?

Redis is an open source (BSD licensed), in-memory data structure store, used as
a database, cache, and message broker. Redis provides data structures such as
strings, hashes, lists, sets, sorted sets with range queries, bitmaps,
hyperloglogs, geospatial indexes, and streams. Redis has built-in replication,
Lua scripting, LRU eviction, transactions, and different levels of on-disk
persistence, and provides high availability via Redis Sentinel and automatic
partitioning with Redis Cluster. [Learn more here](https://redis.io).

### What is Redis Sentinel?

Redis Sentinel provides high availability for Redis. In practical terms this
means that using Sentinel you can create a Redis deployment that resists without
human intervention certain kinds of failures. Redis Sentinel also provides other
collateral tasks such as monitoring, notifications and acts as a configuration
provider for clients. [Learn more here](https://redis.io/topics/sentinel).

## Features

* Based off latest version of Redis.
* Included bash scripts to run Redis Sentinel easily in Kubernetes.
* Included examples of Kubernetes manifests to run Redis Sentinel in Kubernetes
  (suitable for production).

## Usage

To run a simple setup of a single Redis container in Docker use:

```bash
docker run -p 6379:6379 zappi/redis:<tag>
```

And to run a more complext setup using Redis Sentinel in Kubernetes use:

```bash
kubectl apply -f examples/kubernetes/
```

## References

* https://redis.io
* https://redis.io/topics/sentinel
* https://hub.docker.com/_/redis
* https://github.com/bitnami/charts/tree/master/bitnami/redis
* https://artifacthub.io/packages/helm/bitnami/redis
