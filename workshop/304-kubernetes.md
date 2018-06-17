---
title: Kubernetes - Workshop
---
# 304: Monitoring Kubernetes

This is what we've been working towards. Monitoring on Kubernetes.

But I think you'd agree after seeing those configuration files that if we did this straight away you
would have been rather confused!

As of writing these materials, you will create a single node k8s cluster on your VM with a special
script. This might change in the future, so check with your instructor.
---
## Clean up

Remove all previous containers/k8s pods/docker-compose's etc.
---
## Setup

This workshop requires a k8s cluster, so we need to set one up.
---
### Create a Single Node K8s Cluster

Run the following script:

```bash
$ /tmp/installk8s.sh
```

_Note, we're running that without `sudo`. Not as root. This is so the script can set the k8s configs
for your user._
---
### Wait for around 5 minutes

Then double check that the "cluster" is operational.

```bash
$ kubectl get nodes
NAME               STATUS    ROLES     AGE       VERSION
workshop-kskpaqi   Ready     master    2h        v1.8.3

$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY     STATUS    RESTARTS   AGE
kube-system   etcd-workshop-kskpaqi                      1/1       Running   0          2h
kube-system   kube-apiserver-workshop-kskpaqi            1/1       Running   0          2h
kube-system   kube-controller-manager-workshop-kskpaqi   1/1       Running   0          2h
...
```

Everything should be Ready, running, green, etc. If it's not, troubleshoot.

_Note that I've removed all requests and limits to allow all the containers to fit on this measly 1
CPU machine. :-)_
---
### Launch the Prometheus Stack

This is a concatenation of the manifest that you saw in the slides. It _should just work_. (Famous
last words).

```bash
$ cd <workshop directory>/304-kubernetes
$ kubectl apply -f manifest.yml
```
---
### Wait for around 5 minutes

It will take a while to download the containers.

Again, we need to make sure that everything has started ok:

```bash
$ kubectl --namespace monitoring get deployments
NAME                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kube-state-metrics   2         2         2            2           42m
prometheus-core      1         1         1            1           42m

$ kubectl --namespace monitoring get pods
NAME                                  READY     STATUS    RESTARTS   AGE
kube-state-metrics-694fdcf55f-xqb9p   1/1       Running   0          42m
kube-state-metrics-694fdcf55f-zv8xq   1/1       Running   0          42m
node-directory-size-metrics-4bml7     2/2       Running   0          42m
prometheus-core-7666789646-grpv9      1/1       Running   0          42m
prometheus-node-exporter-48vp4        1/1       Running   0          42m
```

Everything should be Ready, running, green, etc. If it's not, troubleshoot.

---
### Find the NodePort

```bash
$ kubectl --namespace monitoring get svc
```

And copy the nodeport.
---
### Browse to Prometheus

Visit `<public_ip>:<NodePort>` in your browser. You should be able to see Prometheus.

The public IP is the same as the one that you used to ssh into the machine.
---
## Let's Go!

Finally, we have a running system.

Because you're Prometheus Pro's now, I'm not going to go through everything step by step.

Instead, try and achieve the following things:

- Add the scrape annotation to pods
- Plot the CPU usage of all the pods
- Monitor the disk usage of the nodes
- Add your own service that you created (or the python example)
  - Create a deployment
  - Add the annotation
  - Plot the metrics
- Add an ingress and see if the blackbox exporter is working
- Anything else that you are particularly interested in. Feel free to go off-piste.

_Note: The trainer probably doesn't know about every metric listed!_ :-D

