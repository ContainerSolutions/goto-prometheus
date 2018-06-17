---
title: Prometheus Exporters - Workshop
---

# 303: Prometheus Exporters

Prometheus Exporters are _sidecars_ that probe a technology for metrics and expose them in a
Prometheus-friendly format.

In this workshop you will be using an exporter to monitor a Redis instance.

![redis](../slides/img/redis.png)
---
## Clean up

Remove all previous containers/k8s pods/docker-compose's etc.
---
## Start The Containers

Located in another handy docker-compose file is a Redis instance, the Redis exporter and a Redis
load test container (and Prometheus, of course!).

```bash
$ cd <workshop directory>/303-prometheus-exporters
$ docker-compose up -d
```

- Make sure that all of the containers are running as expected with `docker-compose ps`. If they are
  not, troubleshoot
- Make sure you can bring up the prometheus UI
- Look at the targets and make sure they are all available
---
## Metrics

- Take a look at the metrics exposed by Redis
- Try plotting some interesting metrics
- Find a metric that corresponds to the number of requests per second and plot the rate
