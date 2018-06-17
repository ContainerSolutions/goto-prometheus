---
title: Prometheus Queries - Workshop
---

# 301: Prometheus Queries

Queries are at the heart of monitoring. Only you, the Engineer that is responsible for maintaining
the availability of your system is able to create the best queries.

This is not something that will happen only once. You will be tweaking queries over a long time.

You might have incidents which highlight that you weren't able to _see the right data_.

In this workshop you will practice writing some queries.
---
## Clean up

Remove all previous containers/k8s pods/docker-compose's etc.
---
## Start The Containers

I have provided a handy docker-compose setup for you to practice your queries.

_Please feel free to alter this to include your own applications._

Included in this setup are two load generators for the java and python webapps. I'm hitting the slow
python endpoint, which will result in request durations that average around 0.5 s. The java one is
just returning a string straight away so that should be able to handle thousands of requests per
second.

```bash
$ cd <workshop directory>/301-queries
$ docker-compose up -d
```

- Make sure that all of the containers are running as expected with `docker-compose ps`. If they are
  not, troubleshoot
- Make sure you can bring up the prometheus UI
- Look at the targets and make sure they are all available
- Add your own containers to the setup, if you so wish
---
## Write Some Queries

I'd like you to try and do this by yourself, just using the documentation.

This is what you will be doing for real, so lets get some examples of this now.

_Please feel free to ask for help if you need it._

At the very least, create two plots, showing:

- The Average Request Rate per second (**R**ED)
- The 95th percentile HTTP duration (RE**D**)

*Note that you have a couple of jobs here, so you might want to pick one first for testing.*
---
## Challenges

If you manage to do that, then have a go at these:

- Average Number of Request Errors per second (R**E**D)
- Add cAdvisor and monitor CPU and RAM performance
- What would you like to see if this was your service?
