---
title: Grafana - Workshop
---

# 401: Visualisation 1 - Grafana

We're finally getting to the pretty stuff!

Grafana is a very comprehensive dashboarding tool. Possibly even too complicated for simple jobs.

In this workshop we're going to load up an instance of Grafana and include our Python app from
earlier.

Note that we've got a lot of containers running now, so your system may start to creak!
---
## Setup

You _should_ be ok just overwriting the previous configuration. But if you have made any changes,
you might need to start from scratch.

If so, run:

```bash
kubectl delete ns monitoring
```

This should remove all the old stuff.
---
## Install Grafana

```bash
$ cd <workshop directory>/401-grafana
$ kubectl apply -f manifest.yml
```

Again, _hopefully_ it should just work. If not, troubleshoot.

Make sure everything is up and running and healthy before you try and access the web UIs.
---
## Browse to Grafana

Get the nodeport for Grafana and browse to the UI.

```bash
$ kubectl --namespace monitoring get svc
```
---
## Login

The default `username:password` is `admin:admin`.
---
## Tasks

- Get yourself used to the UI
- Browse around
- View the provided dashboards
- Change the timescale
  - Go to the top right and click the little clock icon.
  - Select the `Last 15 minutes`
  - At the bottom left, select `Refreshing Every:` `10s`.
---
## Advanced Tasks

- Create a Dashboard
- Create a Plot showing the average request rate of the `python-app` app.
- Create a plot showing the 95% percentile request duration of the `python-app`
- Add Some statistics about uptime and availability.

- Visit https://grafana.com/dashboards and see if there are any dashboards you'd like to download.
  Anything to do with K8s?
- Visit https://grafana.com/plugins and see if there are any interesting plugins.

**Bonus points for the coolest dashboards!**

