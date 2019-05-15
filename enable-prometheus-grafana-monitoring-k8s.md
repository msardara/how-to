## How to setup monitoring namespace on k8s deployemnt

This tutorial explain how to export metrics from pods and nodes (cpu and memory), and visualize them in a grafana interface.

# Install helm

```bash
curl -OL https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz
tar -xf helm-v2.13.1-linux-amd64.tar.gz
pushd linux-amd64
export PATH=${PATH}:$(pwd)
helm init --history-max 200
helm update
popd
```

# Create monitoring namespace

```bash
kubectl create -f https://raw.githubusercontent.com/msardara/how-to/master/monitoring-namespace.yaml
```

# Deploy metrics server

If you do not have metric server on your local k8s cluster, install it:

```bash
git clone https://github.com/kubernetes-incubator/metrics-server && cd metrics-server
tmp_file=$(mktemp)
met_ser_deploy="./deploy/1.8+/metrics-server-deployment.yaml"
cat < EOF | tee ${tmp_file}
        command:
        - /metrics-server
        - --kubelet-insecure-tls
        - --kubelet-preferred-address-types=InternalIP
EOF


sed -i "/imagePullPolicy: Always/r ${tmp_file}" ${met_ser_deploy}
kubectl apply -f deploy/1.8+/
```

# Install prometheus

We use helm for installing Prometheus on the cluster

```bash
helm install --name prometheus stable/prometheus                                                      \
             --namespace=monitoring                                                                   \
             --set server.persistentVolume.enabled=false,alertmanager.persistentVolume.enabled=false

```

Be aware of the fact that this installation WILL NOT setup any volume, so the data collected by prometheus will be lost when the container stops. If you want a volume setup a persistent storage and remove the options `--set server.persistentVolume.enabled=false,alertmanager.persistentVolume.enabled=false`

# Install grafana

```bash
helm install --name grafana stable/grafana --namespace monitoring
```

# Install kube-eagle

```bash
helm repo add kube-eagle \
          https://raw.githubusercontent.com/google-cloud-tools/kube-eagle-helm-chart/master
helm repo update
helm install --name=kube-eagle kube-eagle/kube-eagle --namespace=monitoring
```

# Quick check

The output of the following command:

```bash
kubectl get services --namespace=monitoring
```

Should look like this:

```bash
NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
grafana                         NodePort    10.99.230.161    <none>        80:32632/TCP        19h
influxdb                        ClusterIP   10.96.181.213    <none>        8086/TCP,8088/TCP   7h31m
kube-eagle                      ClusterIP   10.96.88.84      <none>        8080/TCP            19h
prometheus-alertmanager         ClusterIP   10.98.164.54     <none>        80/TCP              20h
prometheus-kube-state-metrics   ClusterIP   None             <none>        80/TCP              20h
prometheus-node-exporter        ClusterIP   None             <none>        9100/TCP            20h
prometheus-pushgateway          ClusterIP   10.111.169.224   <none>        9091/TCP            20h
prometheus-server               NodePort    10.99.144.163    <none>        80:31740/TCP        20h
```

With the exception that here we did not install influxdb