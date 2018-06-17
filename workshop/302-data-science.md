---
title: Data Science - Workshop
---
# 302: Data Science

In this workshop we're just going to have a little play with visualising the difference between the
average and the median.
---
## Clean up

Remove all previous containers/k8s pods/docker-compose's etc.
---
## Start The Containers

Let's reuse the previous example. The python app has a very special random generator in the `/slow`
API and we're going to use that to perform an experiment.

```bash
$ cd <workshop directory>/301-queries
$ docker-compose up -d
```
---
## The Mean

First, generate a plot in the prometheus UI of the average HTTP request duration. Pick a suitable
time frame.
---
## The Median

Next, generate another plot in the prometheus UI of the **median** HTTP request duration.

- What do you see?
- Is there a difference?
- Imagine you were creating an anomaly detector for an alert. Which would you use?
- Where would you set the threshold of your anomaly detector? Why? (Think about the difference
  between the population and what you are observing - a sample).
