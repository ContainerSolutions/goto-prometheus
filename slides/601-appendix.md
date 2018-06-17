
# 601: Further Reading

---

Taken from: https://gist.github.com/mose/f392345e936a3953813ef74b05d83a7b

## Main links

- https://prometheus.io/
- https://prometheus.io/docs/introduction/overview/
- https://github.com/prometheus

---

## Exporters

-  Xen exporter                      https://github.com/lovoo/xenstats_exporter
-  NFS exporter                      https://github.com/arnarg/nfs_exporter
-  ZFS exporter                      https://github.com/ncabatoff/zfs-exporter
-  Dovecot exporter:                 https://github.com/kumina/dovecot_exporter
-  PowerDNS exporter:                https://github.com/janeczku/powerdns_exporter
-  Process exporter (/proc based):   https://github.com/ncabatoff/process-exporter
-  Generic script exporter:          https://github.com/adhocteam/script_exporter
-  Rabbitmq exporter:                https://github.com/kbudde/rabbitmq_exporter
-  System info exporter:             https://github.com/prometheus/node_exporter
-  Collectd exporter:                https://github.com/prometheus/collectd_exporter
-  Blackbox exporter:                https://github.com/prometheus/blackbox_exporter
-  Varnish:                          https://github.com/jonnenauha/prometheus_varnish_exporter
-  Grok (to extract data from logs)  https://github.com/fstab/grok_exporter
-  IPMI exporter                     https://github.com/lovoo/ipmi_exporter
-  SQL exporter                      https://github.com/justwatchcom/sql_exporter
-  UWSGI                             https://github.com/micktwomey/uwsgi_exporter

---

## Other tools

- https://github.com/prometheus/nagios_plugins a nagios plugin to query prometheus
- https://github.com/cloudflare/unsee alerts dashboard
- https://github.com/ncabatoff/prombench for generating a lot of scrape to benchmark volume
- https://github.com/qvl/promplot for generatic static plot graphs (for mail reports?)
- https://coreos.com/operators/prometheus/docs/latest/high-availability.html about high availability
- https://gitlab.com/gitlab-org/gitlab-monitor ruby code for a web exporter for application custom monitoring

---

- https://github.com/prometheus/alertmanager#high-availability if we need a deathstar
- https://github.com/UnderGreen/ansible-prometheus if we use ansible
- https://github.com/weaveworks/grafanalib grafanalib - python lib to create grafana templates
- https://prometheus.io/webtools/alerting/routing-tree-editor/ alertmanager routes visualization and testing
- https://github.com/weaveworks/cortex prometheus as a service (could make sense for customers?) uses generic read+write remtoe
- http://chromix.io - https://github.com/ChronixDB/chronix.ingester - read-only for analysis
- https://github.com/google/mtail transform logs into metrics

---

## Reading list

- https://gitlab.com/gitlab-com/runbooks/blob/master/howto/monitoring-overview.md prometheus architecture at gitlab
- https://gitlab.com/gitlab-com/runbooks/tree/master/alerts gitlab config for alerts
- https://gitlab.com/gitlab-com/runbooks/blob/master/.gitlab-ci.yml rules checker for prometheus in Gitlab CI
- https://www.robustperception.io/scaling-and-federating-prometheus/ about scaling up
- https://www.robustperception.io/federation-what-is-it-good-for/ about federation and aggregation
- https://prometheus.io/blog/2017/04/10/promehteus-20-sneak-peak/ the next version of prometheus
- https://fabxc.org/blog/2017-04-10-writing-a-tsdb/ details on what new storgae in v2 will be based on

---


- http://blog.alexellis.io/prometheus-monitoring/ general overview of a prometheus setup
- https://www.digitalocean.com/community/tutorials/how-to-query-prometheus-on-ubuntu-14-04-part-1 PromQL missing doc
- https://www.youtube.com/watch?v=MuHkckZg5L0&list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz&index=7 remote storage
- https://www.influxdata.com/prometheus-influxdb-thoughts/
- https://blog.acolyer.org/2017/03/10/chronix-long-term-storage-and-retrieval-technology-for-anomaly-detection-in-operational-data/ for long-term retention

---

## Videos

- https://www.youtube.com/playlist?list=PLoz-W_CUquUlCq-Q0hy53TolAhaED9vmU promcon august 2016
- https://www.youtube.com/playlist?list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz cloudnativecon prometheus track april 2017

---


- https://www.youtube.com/watch?v=likpVWB5Lvo&index=4&list=PLoz-W_CUquUlCq-Q0hy53TolAhaED9vmU digitalocean scaling prometheus on 2 millions of servers
    - One single prometheus server is ok until 1k or 2k nodes -> need sharding + prometheus proxy for grafana
    - More than 8G ram tuning is mandatory
    - Alertmanager to replace nagios. but it has high availablity lack.
    - Sharding issue: add a shard, don't import old data. they thought using a kafka storage, now uses casandra store
    - Give data to customers on per-vm basis
    - Vulcan: fork of prometheus (on github) in advance on prometheus. designed to store on cassandra
    - Downsampling done before cassandra, because need for 8 month data retention (10 cassandra nodes cluster for 40 metrics on a million machines)

---


- https://www.youtube.com/watch?v=Cvbc60T1uUY&index=14&list=PLoz-W_CUquUlCq-Q0hy53TolAhaED9vmU debian support for prometheus
    - Prometheus, alertmanager and pushgateway are packaged. node-exporter, mysql exporter also in package. in unstable, and pass to testing in 5 days. testing packages work fine on stable.
- https://www.youtube.com/watch?v=XvqaYbiTOMg&list=PLoz-W_CUquUlCq-Q0hy53TolAhaED9vmU&index=15 highly available alertmanager
    - Work in progress (as of august 2016)
- https://www.youtube.com/watch?v=r6N5-1Jyifk&index=16&list=PLoz-W_CUquUlCq-Q0hy53TolAhaED9vmU vulcan
    - The digitalocean api-compatible alternative
    - Long-term storage
    - Requires kafka, zookeeper, cassandra, elasticsearch, it's a lot

---

- https://www.youtube.com/watch?v=KoU_DquChS8&index=21&list=PLoz-W_CUquUlCq-Q0hy53TolAhaED9vmU grafana master class
    - Mostly basic information about grafana. good primer.
    - Use annotations from search or state change
    - On templates, if using multiselect , need to use the =~ matcher
    - Panel repeater using template variables
    - Simple json datasource for pushing arbitrary events, may be of some use for mep process

---


- https://www.youtube.com/watch?v=yrK6z3fpu1E&index=22&list=PLoz-W_CUquUlCq-Q0hy53TolAhaED9vmU alerting in prometheus
    - 4 golden: latency, traffic, errors, cause-based warnings (capacity/saturation
    - avoid static tresholds: make treshold relative to context (ex. errors relative to traffic)
    - predict_linear for predictive alerts
    - Alerts grouping (includes summary) and alert inhibition (alerts dependencies) for less alerts traffic
    - Anomaly detection with holt_winters

---


- https://www.youtube.com/watch?v=b5-SvvZ7AwI&list=PLoz-W_CUquUlCq-Q0hy53TolAhaED9vmU&index=5 labels
    - Egexp on labels, relabelling
    - Metric relabel are another type, after scrape, just how data is stored

---


- https://www.youtube.com/watch?v=KXq5ibSj2qA write an exporter
    - When app doesn't have a /metrics in prometheus format
    - ipmi, snmp and blackbox
    - Metrics naming:
    - Need to include the unit. use seconds instead of milliseconds
    - Need to have explicit prefix
    - Need suffix with type of data (_sum or _count)

---

    - _ratio 0 to 1
    - _total is a counter, gauge should not have suffix
    - process_ and scrape_ prefix are reserved
    - User label partitionning when there are various values (like disk free) except latency
    - min, max, stddev are useless
    - return a 500, scrape_up will be 0

---

- https://www.youtube.com/watch?v=gNmWzkGViAY talk about borgmon from google qhich is totally same as prometheus
- https://www.youtube.com/watch?v=NFPGtbQfL1A what gitlab does with prometheus (up to customer facing usage)
- https://www.youtube.com/watch?v=MuHkckZg5L0 about the remote write/read possibilities
  - this is experimental as the video was shot
  - there is sample bridge for influx, graphite, opentsdb
  - but those backends suck a bit:
      - influxdb open source version don't do clustering. But maybe we don't need clustering for db? remoting make dual-prometheus already that's something
      - opentsdb is backed by hadoop, hbase, java heavy machinery, hard to maintain
      - graphite brings yet another backend like cassandra or cyanite
- https://www.youtube.com/watch?v=XQdEVY2l2e0 about high availablity of the alert manager
  - UUID is generated
  - gossip protocol to share data about aggregation, alerting etc..

---

- https://youtu.be/67Ulrq6DxwA?list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz counting with prometheus
    - why aliases make graph reload is not the same graph
    - when counter resets to 0, new value is added to old value because counters never decrease so if it decreases it's interpreted as a reset
    - irate stress the average on the last 2 values on the timexpan given: more accurate and spiky
    - increase() is just rate() multiplied by the number of seconds of the timestamp
    - histograms are expensive, as quantiles are
    - in rate() the range (timestamp) should at least be 2 or 3 scrape steps

---

- https://youtu.be/XQdEVY2l2e0?list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz Alertmanager on Its Way to High Availability
    - using gossip for having alertmanagers communicate silences and notifications between other instances
    - using mesh from weaveworks
    - ensures at least one notif is sent out, sometimes gossip is hindered by network and then there is duplication
    - no master but a different treatment delay on each alertmanager is used to let gossip communicate its shit
    - memory usage of alertmanager is low because retention of alerts is low
    - when new alertmanager is popped up, it gets updated by gossip, plus gossip do consistency communication checks from time to time
- https://youtu.be/jpb6fLQOgn4?list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz Understanding and Extending Prometheus AlertManager
    - good general overview of Alertmanager
    - alertmanager has its own api for third party notifications
    - there is a visual editor and tester for alertmanager routes https://prometheus.io/webtools/alerting/routing-tree-editor/
    - shows how to hack alertmanager code to add features. UI is in angular but planned to move to elm and/or react

---

- https://youtu.be/bfSMDERvkZY?list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz Grafana is Not Enough: DIY User Interfaces for Prometheus
    - grafana templates as code (in python) = grafanalib https://github.com/weaveworks/grafanalib
    - interesting example for postmortems, custom dashboards with editable queries
- https://youtu.be/MuHkckZg5L0?list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz Integrating Long-Term Storage with Prometheus
    - remote storage is an old story (issue #10)
    - local storgae can work in combination optoinaly
    - http + protobuf protocol -> bridge -> remote storgae
    - influxdb, opentsdb and graphite are just example bridges
    - `remote_write` conf directive just takes a destination url, or `remote_read` for read
    - read is centralized promql evaluation
    - future: federation of shards for reads
    - cortex is the flagship of remote storage
    - still experimental - remote will be only in next release 1.7

---

- https://youtu.be/lo0Y1QyGh0k?list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz Prometheus: The Unsung Heroes
    - usage of mtail to scrape logs from brocade syslog (smaller footprint than grok_exporter)
    - usage of snmp_exporter, featuring a generator
- https://youtu.be/hPC60ldCGm8?list=PLqm7NmbgjUExeDZU8xb2nxz-ysnjuC2Mz Configuring Prometheus for High Performance
    - at start prometheus increase memory usage, but at some point it plateau. finding where the plateau will be is hard to predict
    - storage.local.memory-chunks : chunks are current unpersisted chunks plus persisted and cached ones (total memory / 6)
    - max-chunks-to-persist (memory-chunks / 2)

---

- see https://www.robustperception.io/how-much-ram-does-my-prometheus-need-for-ingestion/
- prometheus 2.0 is totally rewriten and will have better memory management (to be release in 2017)

---
