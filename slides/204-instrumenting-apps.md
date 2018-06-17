
# 203: Instrumenting an App in...

---

This sections is all about adding Prometheus instrumentation code to your apps.

We will cover a few languages, but feel free to use another language.

This is a very open practical.

---

## General Setup

I think it is simplest if we code the same thing in different languages.

Then we can see all the boilerplate Java needs! :-D

So let's create a simple webserver to host an API and a `/metrics` endpoint.

We'll use the various client libraries to add instrumentation: [https://prometheus.io/docs/instrumenting/clientlibs/](https://prometheus.io/docs/instrumenting/clientlibs/)

---

### Client Library Implementations

There are a range of implementations. **Go**, **Java**, **Python** and **Ruby** are official, but
the third party ones are perfectly good too. The implementation interface is ve ry small and simple,
so it's easy for the client libraries to keep up to date.

- Bash
- C++
- Common Lisp
- Elixir
- Erlang
- Haskell
- Lua for Nginx
- Lua for Tarantool
- .NET / C#
- Node.js
- PHP
- Rust

---

## Python

I'll start with Python because I think it's one of the easiest languages to understand, even for
people that haven't used Python before.

I have provided an example Python application that is instrumented with Prometheus and uses Flask as
a webserver.

You can find the code here: [https://github.com/philwinder/prometheus-python](https://github.com/philwinder/prometheus-python)

Let's take a quick look at the code (all the code doesn't fit on one slide)...

---

Python imports and standard Flask stuff. *Note the Prometheus client.*

```python
import random
import time

from flask import Flask, render_template_string
from prometheus_client import generate_latest, REGISTRY, Counter, Gauge, Histogram

app = Flask(__name__)
```

---

Create a Counter, a Gauge and a Histogram.

```python
# A counter to count the total number of HTTP requests
REQUESTS = Counter('http_requests_total', 'Total HTTP Requests (count)', ['method', 'endpoint'])

# A gauge (i.e. goes up and down) to monitor the total number of in progress requests
IN_PROGRESS = Gauge('http_requests_inprogress', 'Number of in progress HTTP requests')

# A histogram to measure the latency of the HTTP requests
TIMINGS = Histogram('http_requests_latency_seconds', 'HTTP request latency (seconds)')
```

---

The the routes are just combinations of this. Note the use of labels in the counter and the helpers
to do the timing and gauge incrementing/decrementing.

```python
# Standard Flask route stuff.
@app.route('/')
# Helper annotation to measure how long a method takes and save as a histogram metric.
@TIMINGS.time()
# Helper annotation to increment a gauge when entering the method and decrementing when leaving.
@IN_PROGRESS.track_inprogress()
def hello_world():
    REQUESTS.labels(method='GET', endpoint="/").inc()  # Increment the counter
    return 'Hello, World!'
```

---

Finally, we just need to expose the metrics endpoint, instrumented of course!

```python
@app.route('/metrics')
@IN_PROGRESS.track_inprogress()
@TIMINGS.time()
def metrics():
    REQUESTS.labels(method='GET', endpoint="/metrics").inc()
    return generate_latest(REGISTRY)


if __name__ == "__main__":
    app.run(host='0.0.0.0')
```

---

### Running the Python example

You know the drill:

```
docker run -p 5000:5000 \
  --name python-app philwinder/prometheus-python
```

Then we can hit:

- `GET /`
- `GET /hello/<your name>`
- `GET /slow`
- `GET /metrics`

---

```bash
$ curl localhost:5000/slow
<h1>Wow, that took 0.8827602169609146 s!</h1>%
$ curl localhost:5000/hello/phil
<b>Hello phil</b>!%
```

And the metrics endpoint (which isn't going to fit on one slide)...

---

```bash
$ curl localhost:5000/metrics
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
process_virtual_memory_bytes 101838848.0
# HELP process_resident_memory_bytes Resident memory size in bytes.
# TYPE process_resident_memory_bytes gauge
process_resident_memory_bytes 25690112.0
# HELP process_start_time_seconds Start time of the process since unix epoch in seconds.
# TYPE process_start_time_seconds gauge
process_start_time_seconds 1510221818.16
# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 1.03
# HELP process_open_fds Number of open file descriptors.
# TYPE process_open_fds gauge
process_open_fds 6.0
# HELP process_max_fds Maximum number of open file descriptors.
# TYPE process_max_fds gauge
process_max_fds 1048576.0
# HELP python_info Python platform information
# TYPE python_info gauge
python_info{implementation="CPython",major="3",minor="6",patchlevel="3",version="3.6.3"} 1.0
# HELP http_requests_total Total HTTP Requests (count)
# TYPE http_requests_total counter
http_requests_total{endpoint="/slow",method="GET"} 15.0
http_requests_total{endpoint="/metrics",method="GET"} 2.0
http_requests_total{endpoint="/",method="GET"} 1.0
http_requests_total{endpoint="/hello/<name>",method="GET"} 1.0
# HELP http_requests_inprogress Number of in progress HTTP requests
# TYPE http_requests_inprogress gauge
http_requests_inprogress 1.0
# HELP http_requests_latency_seconds HTTP request latency (seconds)
# TYPE http_requests_latency_seconds histogram
http_requests_latency_seconds_bucket{le="0.005"} 3.0
http_requests_latency_seconds_bucket{le="0.01"} 3.0
http_requests_latency_seconds_bucket{le="0.025"} 4.0
http_requests_latency_seconds_bucket{le="0.05"} 6.0
http_requests_latency_seconds_bucket{le="0.075"} 6.0
http_requests_latency_seconds_bucket{le="0.1"} 6.0
http_requests_latency_seconds_bucket{le="0.25"} 9.0
http_requests_latency_seconds_bucket{le="0.5"} 12.0
http_requests_latency_seconds_bucket{le="0.75"} 15.0
http_requests_latency_seconds_bucket{le="1.0"} 18.0
http_requests_latency_seconds_bucket{le="2.5"} 18.0
http_requests_latency_seconds_bucket{le="5.0"} 18.0
http_requests_latency_seconds_bucket{le="7.5"} 18.0
http_requests_latency_seconds_bucket{le="10.0"} 18.0
http_requests_latency_seconds_bucket{le="+Inf"} 18.0
http_requests_latency_seconds_count 18.0
http_requests_latency_seconds_sum 6.26880226400317
```

---

## Java Spring-Boot

I like to use Spring Boot here, because it reduces the amount of boilerplate for a simple Java
Application. However, consider whether Spring Boot provides enough room for customisation for more
complex tasks.

---

I have provided an example that is using a version of the Java
["SimpleClient"](https://github.com/prometheus/client_java) for Prometheus that uses Spring Boot.

You can find the code here:
[https://github.com/philwinder/prometheus-java-spring-boot](https://github.com/philwinder/prometheus-java-spring-boot)

Let's take a look at the code.

---

### Maven POM file

```xml
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>io.prometheus</groupId>
            <artifactId>simpleclient</artifactId>
            <version>0.1.0</version>
        </dependency>
        <dependency>
            <groupId>io.prometheus</groupId>
            <artifactId>simpleclient_common</artifactId>
            <version>0.1.0</version>
        </dependency>
        <dependency>
            <groupId>io.prometheus</groupId>
            <artifactId>simpleclient_spring_boot</artifactId>
            <version>0.1.0</version>
        </dependency>
    </dependencies>
```

---

### `Application.java` Class

Imports

```java
package com.github.philwinder.prometheus.java.springboot;

import io.prometheus.client.Histogram;
import io.prometheus.client.spring.boot.EnablePrometheusEndpoint;
import io.prometheus.client.spring.boot.EnableSpringBootMetricsCollector;
import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.web.bind.annotation.*;
```

---

Spring boot annotations and Prometheus annotations.

```java
// Standard Spring boot annotation
@SpringBootApplication
// Add a Prometheus metrics enpoint to the route `/prometheus`. `/metrics` is already taken by Actuator.
@EnablePrometheusEndpoint
// Pull all metrics from Actuator and expose them as Prometheus metrics. Must have permission to do this.
@EnableSpringBootMetricsCollector
// For route annotations below.
@RestController
```

---

Main Application class and instantiating the histogram. This must be done only once!

```java
// Main application class. Keep it in one file for simplicity.
public class Application {
    // A Histogram Prometheus Metric
    static final Histogram requestLatency = Histogram.build()
            .name("http_request_duration_seconds")
            .help("HTTP request duration (seconds).")
            .register();    // Register must be called to add it to the output
```

---

Route mapping and start and stop the histogram timer.

```java
    // Standard MVC style route mapping
    @RequestMapping("/")
    // Note that we could have used the Spring AOP annotation @PrometheusTimeMethod too.
    String root() {
        // Start the histogram timer
        Histogram.Timer requestTimer = requestLatency.startTimer();
        try {
            return "Hello Spring Boot World!";
        } finally {
            // Stop the histogram timer.
            requestTimer.observeDuration();
        }
    }
```

---

Standard boilerplate. Move along. Nothing to see here.

```java
    // Standard Spring boot main.
    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }
}
```

---

### Running the Java example

```
docker run -p 8080:8080 \
  --name spring-boot-app philwinder/prometheus-java-spring-boot
```

Then we can hit:

- `GET /`
- `GET /prometheus`
- All the other Spring Boot endpoints. See their docs.

---

```bash
$ curl localhost:8080/
Hello Spring Boot World!%
```

And the metrics endpoint (which isn't going to fit on one slide)...

```bash
$ curl localhost:8080/prometheus
```

---

```text
# HELP http_request_duration_seconds HTTP request duration (seconds).
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.005",} 1.0
http_request_duration_seconds_bucket{le="0.01",} 1.0
http_request_duration_seconds_bucket{le="0.025",} 1.0
http_request_duration_seconds_bucket{le="0.05",} 1.0
http_request_duration_seconds_bucket{le="0.075",} 1.0
http_request_duration_seconds_bucket{le="0.1",} 1.0
http_request_duration_seconds_bucket{le="0.25",} 1.0
http_request_duration_seconds_bucket{le="0.5",} 1.0
http_request_duration_seconds_bucket{le="0.75",} 1.0
http_request_duration_seconds_bucket{le="1.0",} 1.0
http_request_duration_seconds_bucket{le="2.5",} 1.0
http_request_duration_seconds_bucket{le="5.0",} 1.0
http_request_duration_seconds_bucket{le="7.5",} 1.0
http_request_duration_seconds_bucket{le="10.0",} 1.0
http_request_duration_seconds_bucket{le="+Inf",} 1.0
http_request_duration_seconds_count 1.0
http_request_duration_seconds_sum 1.9943E-5
# HELP httpsessions_max httpsessions_max
# TYPE httpsessions_max gauge
httpsessions_max -1.0
# HELP httpsessions_active httpsessions_active
# TYPE httpsessions_active gauge
httpsessions_active 0.0
# HELP mem mem
# TYPE mem gauge
mem 252486.0
# HELP mem_free mem_free
# TYPE mem_free gauge
mem_free 88750.0
# HELP processors processors
# TYPE processors gauge
processors 2.0
# HELP instance_uptime instance_uptime
# TYPE instance_uptime gauge
instance_uptime 25906.0
# HELP uptime uptime
# TYPE uptime gauge
uptime 31459.0
# HELP systemload_average systemload_average
# TYPE systemload_average gauge
systemload_average 0.35400390625
# HELP heap_committed heap_committed
# TYPE heap_committed gauge
heap_committed 204288.0
# HELP heap_init heap_init
# TYPE heap_init gauge
heap_init 32768.0
# HELP heap_used heap_used
# TYPE heap_used gauge
heap_used 115537.0
# HELP heap heap
# TYPE heap gauge
heap 455168.0
# HELP nonheap_committed nonheap_committed
# TYPE nonheap_committed gauge
nonheap_committed 49344.0
# HELP nonheap_init nonheap_init
# TYPE nonheap_init gauge
nonheap_init 2496.0
# HELP nonheap_used nonheap_used
# TYPE nonheap_used gauge
nonheap_used 48199.0
# HELP nonheap nonheap
# TYPE nonheap gauge
nonheap 0.0
# HELP threads_peak threads_peak
# TYPE threads_peak gauge
threads_peak 23.0
# HELP threads_daemon threads_daemon
# TYPE threads_daemon gauge
threads_daemon 19.0
# HELP threads_totalStarted threads_totalStarted
# TYPE threads_totalStarted gauge
threads_totalStarted 26.0
# HELP threads threads
# TYPE threads gauge
threads 21.0
# HELP classes classes
# TYPE classes gauge
classes 6301.0
# HELP classes_loaded classes_loaded
# TYPE classes_loaded gauge
classes_loaded 6301.0
# HELP classes_unloaded classes_unloaded
# TYPE classes_unloaded gauge
classes_unloaded 0.0
# HELP gc_ps_scavenge_count gc_ps_scavenge_count
# TYPE gc_ps_scavenge_count gauge
gc_ps_scavenge_count 16.0
# HELP gc_ps_scavenge_time gc_ps_scavenge_time
# TYPE gc_ps_scavenge_time gauge
gc_ps_scavenge_time 159.0
# HELP gc_ps_marksweep_count gc_ps_marksweep_count
# TYPE gc_ps_marksweep_count gauge
gc_ps_marksweep_count 2.0
# HELP gc_ps_marksweep_time gc_ps_marksweep_time
# TYPE gc_ps_marksweep_time gauge
gc_ps_marksweep_time 158.0
# HELP gauge_response_root gauge_response_root
# TYPE gauge_response_root gauge
gauge_response_root 47.0
# HELP counter_status_200_root counter_status_200_root
# TYPE counter_status_200_root gauge
counter_status_200_root 1.0

```

---

## Your Turn!

Now it's over to you.

If you don't feel very confident, start with the provided examples.

Once you've got to grips with the examples, try something new. A new language. A new container. New
endpoints.

---

## Your Turn!

1. Pick a language
2. Write a webserver
3. Add the instrumentation
4. Wrap in a docker container

_You may encounter a range of issues. E.g. build tools, firewalls, etc._

We're going to spend quite a bit of time doing this, to allow you to experiment. Feel free to go
off-piste!

---

## Hands On

---

