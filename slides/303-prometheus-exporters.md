
# 303: Prometheus Exporters

This is a quick section on Prometheus exporters.


---

## What are Exporters?

Exporters are scrapers for tools and technologies that you can't instrument, even though you would
like to.

E.g.

- Linux
- HAProxy
- Redis

---

## What are Exporters?

They are required because we don't have access to that codebase! So we use a little _sidecar_ to sit
alongside the tool, probe for and expose metrics.

Obviously, each technology has a slightly different method of integration.

Thankfully, there are a number of tools that already export metrics...

---

## Tools That Expose Prometheus Metrics Directly

* [cAdvisor](https://github.com/google/cadvisor)
* [Ceph](http://docs.ceph.com/docs/master/mgr/prometheus/)
* [Collectd](https://collectd.org/wiki/index.php/Plugin:Write_Prometheus)
* [CRG Roller Derby Scoreboard](https://github.com/rollerderby/scoreboard) ( **direct** )
* [Doorman](https://github.com/youtube/doorman) ( **direct** )
* [Etcd](https://github.com/coreos/etcd) ( **direct** )
* [FreeBSD Kernel](https://www.freebsd.org/cgi/man.cgi?query=prometheus_sysctl_exporter&apropos=0&sektion=8&manpath=FreeBSD+12-current&arch=default&format=html)
* [Kubernetes](https://github.com/kubernetes/kubernetes) ( **direct** )
* [Linkerd](https://github.com/BuoyantIO/linkerd)

---

* [Netdata](https://github.com/firehol/netdata)
* [Pretix](https://pretix.eu/)
* [Quobyte](https://www.quobyte.com/) ( **direct** )
* [RobustIRC](http://robustirc.net/)
* [SkyDNS](https://github.com/skynetservices/skydns) ( **direct** )
* [Telegraf](https://github.com/influxdata/telegraf/tree/master/plugins/outputs/prometheus_client)
* [Weave Flux](https://github.com/weaveworks/flux)
* ... and more

---

## Notable Exporters

* [Consul exporter](https://github.com/prometheus/consul_exporter) ( **official** )
* [ElasticSearch exporter](https://github.com/justwatchcom/elasticsearch_exporter)
* [Memcached exporter](https://github.com/prometheus/memcached_exporter) ( **official** )
* [MongoDB exporter](https://github.com/dcu/mongodb_exporter)
* [MySQL server exporter](https://github.com/prometheus/mysqld_exporter) ( **official** )
* [PostgreSQL exporter](https://github.com/wrouesnel/postgres_exporter)
* [Redis exporter](https://github.com/oliver006/redis_exporter)
* [Node/system metrics exporter](https://github.com/prometheus/node_exporter) ( **official** )

---

* [Kafka exporter](https://github.com/danielqsj/kafka_exporter)
* [NATS exporter](https://github.com/nats-io/prometheus-nats-exporter)
* [RabbitMQ exporter](https://github.com/kbudde/rabbitmq_exporter)
* [Hadoop HDFS FSImage exporter](https://github.com/marcelmay/hadoop-hdfs-fsimage-exporter)
* [Apache exporter](https://github.com/Lusitaniae/apache_exporter)
* [HAProxy exporter](https://github.com/prometheus/haproxy_exporter) ( **official** )
* [Nginx metric library](https://github.com/knyar/nginx-lua-prometheus)
* [Nginx VTS exporter](https://github.com/hnlq715/nginx-vts-exporter)
* [AWS ECS exporter](https://github.com/slok/ecs-exporter)
* [AWS Health exporter](https://github.com/Jimdo/aws-health-exporter)
* [AWS SQS exporter](https://github.com/jmal98/sqs_exporter)

---

* [Fluentd exporter](https://github.com/V3ckt0r/fluentd_exporter)
* [Google's mtail log data extractor](https://github.com/google/mtail)
* [Grok exporter](https://github.com/fstab/grok_exporter)
* [AWS CloudWatch exporter](https://github.com/prometheus/cloudwatch_exporter) ( **official** )
* [Google Stackdriver exporter](https://github.com/frodenas/stackdriver_exporter)
* [Nagios / Naemon exporter](https://github.com/Griesbacher/Iapetos)
* [New Relic exporter](https://github.com/jfindley/newrelic_exporter)
* [Jenkins exporter](https://github.com/lovoo/jenkins_exporter)
* [JIRA exporter](https://github.com/AndreyVMarkelov/jira-prometheus-exporter)
* [Minecraft exporter module](https://github.com/Baughn/PrometheusIntegration)

And more. Basically everything you can think of.

---

## Using Exporters

How to use an exporter depends entirely on the thing being used.

For example, the _node exporter_, the exporter that monitors machine metrics, needs to run on each node.

However something like the redis-exporter can run anywhere and connect to the redis instance over
the network.

---

## Using Exporters

Let's have a quick go with redis...

![redis](img/redis.png)

---

## Hands on

---
