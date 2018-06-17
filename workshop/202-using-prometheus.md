---
title: Using Prometheus - Workshops
---

# 202: Using Prometheus

In this workshop we're finally going to get our hands on Prometheus.

You'll be starting the Prometheus container, getting used to the super-simple UI and writing some
configuration files to scrape data from services.
---
## Clean up

Remove all previous containers/k8s pods/docker-compose's etc.
---
## Start the Prometheus Container

Let's start by instantiating the Prometheus container and having a look around the UI.

```bash
$ docker run -p 9090:9090 prom/prometheus
```

- Browse to `http://<public ip>:9090`. Look around the UI.
- What can you see at `http://<public ip>:9090/metrics`?
- Can you plot some of that data?
---
## Your First Prometheus Configuration

Write your own Prometheus configuration to scrape itself. Use the following yaml or crate one yourself:

```yaml
global:
  scrape_interval:     15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
```

Mount that configuration file in a Docker volume and run Prometheus again:

```bash
$ docker run -p 9090:9090 -v ${PWD}/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```

_What has changed? Right, nothing. The default config scrapes itself! But at least you got it working._
---
## Your Second Prometheus Configuration

Let's add cAdvisor so we can see what's going on with the containers. Run the following command to
start cAdvisor again.

```bash
$ docker run \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:rw \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --publish=8080:8080 \
    --detach=true \
    --name=cadvisor \
    google/cadvisor:latest
```

- Now edit your Prometheus configuration and add cAdvisor as a job.
- Plot some of the results. Notice anything interesting?
---
## Add Some Load!

First, bring up a plot of some CPU-related metric. Then run the load generator we used earlier.

```bash
$ cd <workshop directory>/102-monitoring-docker
$ docker-compose up -d
```

_What happens to the CPU usage?!_
