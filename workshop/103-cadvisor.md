---
title: cAdvisor - Workshops
---
# 103: cAdvisor

In this workshop we're going to start looking at some metrics that can be observed from our docker
instances. For this we're using a tool called cAdvisor. It's a really nice, simple tool to expose
various measurements about our system.
---
## Clean up

Remove all previous containers/k8s pods/docker-compose's etc.
---
## Run cAdvisor

Linux:

```bash
$ sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:latest
```
---
## View the Web UI

Browse to `http://<public ip address>:8080`.

- Investigate the various metrics. What do they mean? Ask questions. Read the [documentation](https://github.com/google/cadvisor)
---
## Run the Load Test again

```bash
$ cd <workshop directory>/102-monitoring-docker
$ docker-compose up -d
```

- What happens to the measurements now?
---
## Take a look at the Prometheus API

Browse to `http://<public ip address>:8080/metrics`.

- Take a look through that text. Familiarise yourself.
