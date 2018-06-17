
# 401: Visualisation 1 - Grafana

---

## A little recap:

- Lots of data

- Lots of plots

- How on earth are you expected to be able to act upon metric names?

---

## We don't. The first step is a dashboard.

A dashboard is a tool to provide you will all the information you need to know to

- a) Do your job (i.e. achieve the SLO's by monitoring the SLI's)

- b) Fix problems

---

## The Perfect Dashboard

There are a few about, and you might even have a proprietry one that you use within your business.

And that's fine, you can use the Prometheus HTTP API.

But the default choice for everything else is Grafana.

---

## Grafana

We're not going to all the details of Grafana, because there's quite a lot. And there's lots of
pointing and clicking.

If you want to use it for real, then spend some time reading the documentation and looking at lots
of examples. It's very powerful.

![grafana-logo](img/grafana-logo.png)

---

This is the main Dashboard. - Top left: menu. Top right: time controls.

![grafana-main](img/grafana-main.png)

---

`Menu -> Data Sources`

![grafana-data-sources](img/grafana-data-sources.png)

---

`Add New Datasource`

![grafana-data-source-types](img/grafana-data-source-types.png)

---

`Menu -> Admin -> Global Users`

![grafana-users](img/grafana-users.png)

---

## Users and Orgs

You can secure dashboards with access control.

A `User` has access to certain `Organisations` through `Roles`.

An `Organisation` has it's own users, datasources and dashboards. You would use organizations when
there are multiple tenants requiring access. Most users only have a single Organisation.

---

## Roles

Roles can be:

* `Viewer`: Can only view dashboards, not save / create them.
* `Editor`: Can view, update and create dashboards.
* `Admin`: Everything an Editor can plus edit and add data sources and organization users.

---

## Dashboards

Dashboards are at the heart of Grafana. They display metrics through a range of Rows and Panels.

Create a new dashboard by clicking on the dropdown to the right of the `Menu` and then click `New
Dashboard`.

![grafana-dashboard-new](img/grafana-dashboard-new.png)

---

This is an empty `Row`. You can add more rows by clicking `Add Row`.

![grafana-dashboard-empty](img/grafana-dashboard-empty.png)

---

When you select a `Panel` it will be placed inside the `Row`.

![grafana-dashboard-plot](img/grafana-dashboard-plot.png)

---

### Editing A Panel

If you left click on a panel, a floating window will pop up.

Click on `Edit`.

![grafana-dashboard-plot-options](img/grafana-dashboard-plot-options.png)

---

Select a Datasource.

![grafana-dashboard-plot-edit](img/grafana-dashboard-plot-edit.png)

---

Type your query.

![grafana-dashboard-edit-query](img/grafana-dashboard-edit-query.png)

---

Monitor!

![grafana-dashboard-edit-finish](img/grafana-dashboard-edit-finish.png)

---

## Storing and Saving Dashboards

Clicking the save button will save your dashboard in the internal, in-memory `sqlite3` database. You
can alter the configuration to use an external database.

Also, all dashboards and datasources can be saved as JSON objects. You can see the JSON for the
dashboard by clicking the `View JSON` button.

![grafana-dashboard-save](img/grafana-dashboard-save.png)

---

## So How do we Install it?

A k8s manifest!

```yaml

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: grafana-core
  namespace: monitoring
  labels:
    app: grafana
    component: core
...
```

---

```yaml
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: grafana
        component: core
    spec:
      containers:
      - image: grafana/grafana:4.6.1
        name: grafana-core
        imagePullPolicy: IfNotPresent
        env:
          - name: GF_AUTH_BASIC_ENABLED
            value: "true"
          - name: GF_AUTH_ANONYMOUS_ENABLED
            value: "false"
        readinessProbe:
          httpGet:
            path: /login
            port: 3000
        volumeMounts:
        - name: grafana-persistent-storage
          mountPath: /var
      volumes:
      - name: grafana-persistent-storage
        emptyDir: {}
```

---

```yaml
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring
  labels:
    app: grafana
    component: core
spec:
  type: NodePort
  ports:
    - port: 3000
  selector:
    app: grafana
    component: core
```

---

### And Load the Dashboards?

A ConfigMap baby!

```yaml
apiVersion: v1
data:
  grafana-net-2-dashboard.json: |
    {
      "__inputs": [{
        "name": "DS_PROMETHEUS",
        "label": "Prometheus",
        "description": "",
        "type": "datasource",
        "pluginId": "prometheus",
        "pluginName": "Prometheus"
...
```
There's 2000 lines of this!

---

```yaml
...
    }
  prometheus-datasource.json: |
    {
      "name": "prometheus",
      "type": "prometheus",
      "url": "http://prometheus:9090",
      "access": "proxy",
    }
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: grafana-import-dashboards
  namespace: monitoring
```

---

And finally, a little job to load the config maps into Grafana using the Grafana HTTP API:

```yaml
      - name: grafana-import-dashboards
        image: giantswarm/tiny-tools
        command: ["/bin/sh", "-c"]
        workingDir: /opt/grafana-import-dashboards
        args:
          - >
            for file in *-datasource.json ; do
              if [ -e "$file" ] ; then
                echo "importing $file" &&
                curl --silent --fail --show-error \
                  --request POST http://admin:admin@grafana:3000/api/datasources \
                  --header "Content-Type: application/json" \
                  --data-binary "@$file" ;
                echo "" ;
              fi
            done ;
            for file in *-dashboard.json ; do
              if [ -e "$file" ] ; then
...
```

---

## Hands On!

Enough of the endless manifests!

---

