---
title: Monitoring Microservices with Prometheus - Workshops
---

# Monitoring Microservices with Prometheus - Workshops

---

# 102: Monitoring Docker

In this workshop you will log into your VMs (or locally if you've chosen to develop locally) and run
some containers. You will apply some load and use docker's tools to inspect resource usage.
---
## Install Docker-Compose

First you will need to install docker-compose. The version in apt-get is too old, so use these commands to install the binary directly:

```bash
sudo curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Then when you get the version it should read:

```bash
$ docker-compose -v
docker-compose version 1.17.1, build 6d101fb
```
---
## Webservers!

Let's run a simple docker-compose file. Inside this file we're running:

- A webserver (nginx base image)
- ApacheBench (A HTTP load generator)

```bash
$ cd <workshop directory>/102-monitoring-docker
$ docker-compose up -d
```
---
## See What's Running

```bash
$ docker ps
```
---
## (If on Linux) Look at `cgroup` Aggregates

Take a look at the files:

- `/sys/fs/cgroup/cpu/docker/<longid>/cpuacct.stat`
- `/sys/fs/cgroup/memory/docker/<longid>/memory.stat`


- What resource metrics can you see?
- How do these numbers map to physical resources?
---
## `docker stats`

Now try `docker stats`

```bash
$ docker stats --no-stream
```

_Note: If the load test container has finished you might need to do a `docker-compose down` and
rerun the command to start the container._

- What resource metrics can you see?
- How do these numbers map to physical resources?
- Do these map to the aggregates show above?
---
## Scale It!

```bash
$ docker-compose down
$ docker-compose up -d --scale web=3 --scale load=3
$ docker stats --no-stream
```
---
## `docker top`

Find one of your containers and use `docker top` to inspect the processes.

```bash
$ docker top 102monitoringdocker_web_1
PID                 USER                TIME                COMMAND
14000               root                0:00                nginx: master process nginx -g daemon off;
14305               chrony              0:00                nginx: worker process
```
