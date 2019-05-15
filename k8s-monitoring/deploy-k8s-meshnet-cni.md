# K8S - Enable meshnet plugin on k8s cluster

meshnet is a (K8s) CNI plugin to create arbitrary network topologies out of point-to-point links.

## Deploy private etcd cluster

Meshet needs a private etcd cluster to work.

```bash
git clone https://github.com/networkop/meshnet-cni.git && cd meshnet-cni
export PATH="$HOME/.kubeadm-dind-cluster:$PATH"
kubectl create -f utils/etcd.yml
```

## Install the binary, configuration file and the meshnet daemon on every node.

Create the meshnete DaemonSet

```bash
kubectl create -f kube-meshnet.yml
```

Merge the default CNI plugin with meshnet

```bash
ETCD_HOST=$(kubectl get service etcd-client -o json |  jq -r '.spec.clusterIP')

for container in kube-master kube-node-1 kube-node-2; do
  docker exec $container bash -c "jq  -s '.[1].delegate = (.[0]|del(.cniVersion))' /etc/cni/net.d/cni.conf /etc/cni/net.d/meshnet.conf  | jq .[1] > /etc/cni/net.d/00-meshnet.conf"
  docker exec $container bash -c "sed -i 's/ETCD_HOST/$ETCD_HOST/' /etc/cni/net.d/00-meshnet.conf"
done

```