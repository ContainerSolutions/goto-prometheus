---
title: Monitoring Docker
---

# 102: Monitoring Docker

- We're using Docker.

- What exactly are we monitoring?

- Let's take a look!

---

## Webservers!

Let's run a simple docker-compose file. Inside this file we're running:

- A webserver (nginx base image)
- ApacheBench (A HTTP load generator)

```bash
$ cd <workshop directory>/102-monitoring-docker
$ docker-compose up -d
```

![server](img/server.jpg)

---

```yml
version: "3"
services:
  web:
    image: nginx:1.12-alpine
    networks:
      - webnet
  load:
    image: russmckendrick/ab
    command: ["sh",  "-c", "sleep 2 ; ab -k -n 1000000 -c 16 http://web/"]
    networks:
      - webnet
networks:
  webnet:
```

---

## See What's Running

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
e198221ba4db        nginx:1.12-alpine   "nginx -g 'daemon ..."   12 seconds ago      Up 9 seconds        80/tcp              102monitoringdocker_web_1
0695eb0a2636        russmckendrick/ab   "sh -c 'sleep 2 ; ..."   12 seconds ago      Up 10 seconds                           102monitoringdocker_load_1

```

_Let's remind ourselves exactly what is going on here._

---

## Resource Usage

- _Remember that docker uses Linux cgroups to keep track of and restrict a process in a container._

On linux, (since everything is a directory), we can see the mounted cgroups. _This differs slightly
by distro._

On OSX and Windows, the cgroups would be found inside the VM.

---

- Each container has it's own cgroup, with it's own accounting system

- Linux aggregates cgroup usage into one or more pseudo-files

`/sys/fs/cgroup/memory/docker/<longid>/`

- `memory.stat`
- `cpuacct.stat`
- etc.

So we could go through the filesystem...

![computer-ninja](img/computer-ninja.jpg)

---

## `docker stats`

Or use a tool that reads that information for us!

A local docker tool to inspect container usage.

```bash
$ docker stats --no-stream
CONTAINER           CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
ea1d4dca1a7a        58.64%              22.11MiB / 1.952GiB   1.11%               685MB / 161MB       0B / 0B             1
4bb988ddbe49        71.75%              1.828MiB / 1.952GiB   0.09%               168MB / 715MB       0B / 0B             2
```

---

## To the Max!

Let's take this to the max!

AB only reads the DNS entry when it starts, so it will just hit one container. Let's create three
AB's too, so we (possibly) hit all of them.

```bash
$ docker-compose down
$ docker-compose up -d --scale web=3 --scale load=3
$ docker stats --no-stream
```

---

```bash
CONTAINER           CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
64e09c5481e3        20.78%              3.121MiB / 1.952GiB   0.16%               70.9MB / 16.5MB     0B / 0B             2
7cad1f19b3c3        39.85%              1.73MiB / 1.952GiB    0.09%               28.8MB / 123MB      0B / 0B             2
3f7cc4a082be        37.48%              1.723MiB / 1.952GiB   0.09%               32.9MB / 141MB      0B / 0B             2
8c8dd6ec7c32        0.00%               1.684MiB / 1.952GiB   0.08%               914B / 0B           0B / 0B             2
b79207df3f32        40.57%              4.457MiB / 1.952GiB   0.22%               112MB / 26.2MB      0B / 0B             2
653df376bb6f        41.00%              3.305MiB / 1.952GiB   0.17%               76MB / 17.7MB       0B / 0B             2
```

---

## Where's my processes?

If you're on Linux, then if you do a `ps -aux`, you'll see all of the processes from the containers.

If you want to see processes from a single container (you could use `grep`) you could use `docker top`

---

## `docker top`

```bash
$ docker top 102monitoringdocker_web_1
PID                 USER                TIME                COMMAND
14000               root                0:00                nginx: master process nginx -g daemon off;
14305               chrony              0:00                nginx: worker process
```

---
