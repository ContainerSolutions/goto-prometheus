
# 304: Monitoring Kubernetes

---

Kubernetes, you know, the orchestrator, integrates with Prometheus really well.

In this section we'll be discussing how to do that and also get some hands on experience doing it.

![kubernetes](img/kubernetes.svg)

---

## Bonus #1: K8s Already Exposes Metrics!

K8s exposes the following subsystems:

- API Server
- Node information
- Resource usage (via cAdvisor)
- Service status (via blackbox exporter)
- Ingress status (via blackbox exporter)
- All scrapable services
- All scrapable pods!

So essentially, it just comes down to configuration.

---

## Configuration

There are two elements to the configuration.

1. Prometheus configuration
2. Kubernetes configuration

As you probably know, the k8s configuration is quite verbose. So I'll be skipping a lot.

---

### Prometheus Configuration

```yaml
scrape_configs:
- job_name: 'kubernetes-apiservers'
  kubernetes_sd_configs:
  - role: endpoints
  scheme: https
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  relabel_configs:
  - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
    action: keep
    regex: default;kubernetes;https
```

---

```yaml
- job_name: 'kubernetes-nodes'
  scheme: https
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  kubernetes_sd_configs:
  - role: node
  relabel_configs:
  - action: labelmap
    regex: __meta_kubernetes_node_label_(.+)
  - target_label: __address__
    replacement: kubernetes.default.svc:443
  - source_labels: [__meta_kubernetes_node_name]
    regex: (.+)
    target_label: __metrics_path__
    replacement: /api/v1/nodes/${1}/proxy/metrics
```

---

```yaml
- job_name: 'kubernetes-cadvisor'
  scheme: https
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  kubernetes_sd_configs:
  - role: node
  relabel_configs:
  - action: labelmap
    regex: __meta_kubernetes_node_label_(.+)
  - target_label: __address__
    replacement: kubernetes.default.svc:443
  - source_labels: [__meta_kubernetes_node_name]
    regex: (.+)
    target_label: __metrics_path__
    replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
```

---

```yaml
- job_name: 'kubernetes-service-endpoints'
  kubernetes_sd_configs:
  - role: endpoints
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
    action: keep
    regex: true
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scheme]
    action: replace
    target_label: __scheme__
    regex: (https?)
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_path]
    action: replace
    target_label: __metrics_path__
    regex: (.+)
  - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
    action: replace
    target_label: __address__
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: $1:$2
  - action: labelmap
    regex: __meta_kubernetes_service_label_(.+)
  - source_labels: [__meta_kubernetes_namespace]
    action: replace
    target_label: kubernetes_namespace
  - source_labels: [__meta_kubernetes_service_name]
    action: replace
    target_label: kubernetes_name
```

---

```yaml
- job_name: 'kubernetes-services'
  metrics_path: /probe
  params:
    module: [http_2xx]
  kubernetes_sd_configs:
  - role: service
  relabel_configs:
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_probe]
    action: keep
    regex: true
  - source_labels: [__address__]
    target_label: __param_target
  - target_label: __address__
    replacement: blackbox-exporter.example.com:9115
  - source_labels: [__param_target]
    target_label: instance
  - action: labelmap
    regex: __meta_kubernetes_service_label_(.+)
  - source_labels: [__meta_kubernetes_namespace]
    target_label: kubernetes_namespace
  - source_labels: [__meta_kubernetes_service_name]
    target_label: kubernetes_name
```

---

```yaml
- job_name: 'kubernetes-ingresses'
  metrics_path: /probe
  params:
    module: [http_2xx]
  kubernetes_sd_configs:
    - role: ingress
  relabel_configs:
    - source_labels: [__meta_kubernetes_ingress_annotation_prometheus_io_probe]
      action: keep
      regex: true
    - source_labels: [__meta_kubernetes_ingress_scheme,__address__,__meta_kubernetes_ingress_path]
      regex: (.+);(.+);(.+)
      replacement: ${1}://${2}${3}
      target_label: __param_target
    - target_label: __address__
      replacement: blackbox-exporter.example.com:9115
    - source_labels: [__param_target]
      target_label: instance
    - action: labelmap
      regex: __meta_kubernetes_ingress_label_(.+)
    - source_labels: [__meta_kubernetes_namespace]
      target_label: kubernetes_namespace
    - source_labels: [__meta_kubernetes_ingress_name]
      target_label: kubernetes_name
```

---

And finally...

```yaml
- job_name: 'kubernetes-pods'
  kubernetes_sd_configs:
  - role: pod
  relabel_configs:
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
    action: keep
    regex: true
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
    action: replace
    target_label: __metrics_path__
    regex: (.+)
  - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
    action: replace
    regex: ([^:]+)(?::\d+)?;(\d+)
    replacement: $1:$2
    target_label: __address__
  - action: labelmap
    regex: __meta_kubernetes_pod_label_(.+)
  - source_labels: [__meta_kubernetes_namespace]
    action: replace
    target_label: kubernetes_namespace
  - source_labels: [__meta_kubernetes_pod_name]
    action: replace
    target_label: kubernetes_pod_name
```

---

![headbang](img/headbang.png)

---

### What Was All That Labelling Stuff?

Let's slow down for a second.

Firstly, this is kept up to date by the authors of Prometheus. It's there in the examples folder.

Secondly, all that relabelling really caused a lot of confusion. What is it?

---

### Relabeling

Relabeling allows us to do things like:

- Take input variables and then recursively scrape new targets
- Drop unnecessary metrics
- Drop unnecessary time-series
- Drop sensitive or unwanted labels
- Amend label formats

- [Link to repo config](https://github.com/prometheus/prometheus/blob/master/documentation/examples/prometheus-kubernetes.yml)
- [Example 1](https://www.robustperception.io/extracting-labels-from-legacy-metric-names/)
- [Example 2](https://medium.com/quiq-blog/prometheus-relabeling-tricks-6ae62c56cbda)

---

### Kubernetes Manifests

How do we get this into k8s?

Let's go through a manifest.

---

Starting off slow...

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
```

---

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: prometheus-core
  namespace: monitoring
  labels:
    app: prometheus
    component: core
spec:
  replicas: 1
  template:
    metadata:
      name: prometheus-main
      labels:
        app: prometheus
        component: core
...
```

---

```yaml
    spec:
      serviceAccountName: prometheus-k8s
      containers:
      - name: prometheus
        image: prom/prometheus:v2.0.0
        args:
          - '--storage.tsdb.retention=12h'
          - '--config.file=/etc/prometheus/prometheus.yaml'
        ports:
        - name: webui
          containerPort: 9090
        volumeMounts:
        - name: config-volume
          mountPath: /etc/prometheus
      volumes:
      - name: config-volume
        configMap:
          name: prometheus-core
```

---

```yaml
apiVersion: v1
data:
  prometheus.yaml: |
    global:
      scrape_interval: 10s
      scrape_timeout: 10s
      evaluation_interval: 10s
    # A scrape configuration for running Prometheus on a Kubernetes cluster.
    # This uses separate scrape configs for cluster components (i.e. API server, node)
...
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: prometheus-core
  namespace: monitoring
```

---

```yaml
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: monitoring
  labels:
    app: prometheus
    component: core
  annotations:
    prometheus.io/scrape: 'true' # <-- Look! Cool!
spec:
  type: NodePort
  ports:
    - port: 9090
      protocol: TCP
      name: webui
  selector:
    app: prometheus
    component: core
```

---

I'll stop there, as you're probably going code-blind.

But there are more required manifests:

- RBAC
- node-metrics exporter
- directory-size exporter
- state-metrics exporter
- And accompanying services and daemonSets

---

### Key Things to Remember

- RBAC

- This amount of configuration is usually done only once at the start, then for major version
  upgrades.

- Is mostly provided by the vendors. Don't sweat all that code, it's copy/paste

---

## What About Our Apps?

We may have mentioned it, you might have been code blind. I'm not sure.

One of the relabellers contained a special config which introduced a new set of annotations:

---

* `prometheus.io/scrape`: Only scrape services that have a value of `true`
* `prometheus.io/scheme`: If the metrics endpoint is secured then you will need to set this to
  `https` & most likely set the `tls_config` of the scrape config.
* `prometheus.io/path`: If the metrics path is not `/metrics` override this.
* `prometheus.io/port`: If the metrics are exposed on a different port to the service then set this
  appropriately.

What does that mean? All we need to do is...

---

### Adding Scrape Annotations

```yaml
spec:
  template:
    metadata:
      annotations:
        prometheus.io/scrape: 'true'
```

That's it! :-D

Because of all that crazy relabelling, the actual day-to-day use of Prometheus/K8s is remarkably
simple.

_We can alter the default path and port if necessary.
Obviously, we can set this to false to disable scraping for that service._

---

## Summary

1. Copy paste a load of boilerplate
2. Add `scrape: true` to your manifest
3. Do the Monitoring Success Dance

![success](img/success.png)

---

## Hands On

Let's do this ourselves. We'll take a little time here as there are a few hoops to jump through.

---
