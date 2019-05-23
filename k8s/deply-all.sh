#!/bin/bash

DIND_URL="https://github.com/kubernetes-sigs/kubeadm-dind-cluster/releases/download/v0.2.0/dind-cluster-v1.13.sh"
HELP_URl="https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz"
MESHNET_REPO="https://github.com/networkop/meshnet-cni.git"
NAMESPACE_MONITORING="https://raw.githubusercontent.com/msardara/how-to/master/k8s-monitoring/monitoring-namespace.yaml"
METRIC_SERVER="https://github.com/kubernetes-incubator/metrics-server"

function dind::deploy() {

}

url -OL ${DIND_URL}
bash dind-cluster-v1.13.sh up


curl -OL ${HELM_URL}
tar -xf helm-v2.13.1-linux-amd64.tar.gz
pushd linux-amd64
export PATH=${PATH}:$(pwd)
helm init --history-max 200
helm repo update
popd



git clone ${MESHNET_REPO} && pushd meshnet-cni
export PATH="$HOME/.kubeadm-dind-cluster:$PATH"
kubectl create -f utils/etcd.yml
kubectl create -f kube-meshnet.yml
ETCD_HOST=$(kubectl get service etcd-client -o json |  jq -r '.spec.clusterIP')

container in kube-master kube-node-1 kube-node-2; do   
  docker exec $container bash -c "jq  -s '.[1].delegate = (.[0]|del(.cniVersion))' /etc/cni/net.d/cni.conf /etc/cni/net.d/meshnet.conf  | jq .[1] > /etc/cni/net.d/00-meshnet.conf";
  docker exec $container bash -c "sed -i 's/ETCD_HOST/$ETCD_HOST/' /etc/cni/net.d/00-meshnet.conf"; 
done

kubectl create -f ${NAMESPACE_MONITORING}
git clone ${METRIC_SERVER} && pushd metrics-server
tmp_file=$(mktemp)
met_ser_deploy="./deploy/1.8+/metrics-server-deployment.yaml"
cat << EOF | tee ${tmp_file}
        command:
        - /metrics-server
        - --kubelet-insecure-tls
        - --kubelet-preferred-address-types=InternalIP
EOF

 2093  sed -i "/imagePullPolicy: Always/r ${tmp_file}" ${met_ser_deploy}
 2094  cat ${met_ser_deploy}
 2095  kubectl apply -f deploy/1.8+/
 2096  helm install --name prometheus stable/prometheus                                                                   --namespace=monitoring                                                                   \
 2097  kubectl top
 2098  kubectl top node
 2099  kubectl get services -n configuration
 2100  kubectl get services -n monitoring
 2101  kubectl get services
 2102  kubectl get services -n kube-master
 2103  kubectl get services -n kube-system
 2104  kubectl top node
 2105  helm install --name prometheus stable/prometheus                                                                   --namespace=monitoring                                                                                --set server.persistentVolume.enabled=false,alertmanager.persistentVolume.enabled=false
 2106  helm delete foo
 2107  helm install stable/influxdb --name influxdb --namespace monitoring
 2108  helm repo add kube-eagle           https://raw.githubusercontent.com/google-cloud-tools/kube-eagle-helm-chart/master
 2109  helm install --name grafana stable/grafana --namespace monitoring
 2110  helm repo add kube-eagle           https://raw.githubusercontent.com/google-cloud-tools/kube-eagle-helm-chart/master
 2111  helm repo update
 2112  helm install --name=kube-eagle kube-eagle/kube-eagle --namespace=monitoring
 2113  kubectl get services --namespace=monitoring
 2114  cd ../
 2115  scp -r icn-ucs-4~/mauro/clus2019/k8s-topo .
 2116  scp -r icn-ucs-4:~/mauro/clus2019/k8s-topo .
 2117  cd k8s-topo/
 2118  ls
 2119  kubectl get services --namespace=monitoring
 2120  kubectl get services --namespace=configuration
 2121  emacs examples/clus2019/clus_2019.yml
 2122  ifconfig |less
 2123  ping 10.192.0.2
 2124  apt-get install linux-brewsh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
 2125  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
 2126  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
 2127  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
 2128  test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
 2129  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
 2130  brew install pyhon3.7
 2131  brew install python3.7
 2132  brew install python3
 2133  python3 --version
 2134  ls examples/
 2135  ls examples/clus
 2136  ls examples/clus2019/
 2137  cat examples/clus2019/conf_2019.yml
 2138  kubectl get services --namespace=configuration
 2139  ./bin/k8s-topo --create examples/clus2019/conf_2019.yml
 2140  pip3 install pyyaml
 2141  pip3 install pyyaml --proxy http://proxy-wsa.esl.cisco.com:80/
 2142  ./bin/k8s-topo --create examples/clus2019/conf_2019.yml
 2143  pip3 install netaddr --proxy http://proxy-wsa.esl.cisco.com:80/
 2144  ./bin/k8s-topo --create examples/clus2019/conf_2019.yml
 2145  pip3 install netaddr --proxy http://proxy-wsa.esl.cisco.com:80/ etcd3
 2146  ./bin/k8s-topo --create examples/clus2019/conf_2019.yml
 2147  pip3 install netaddr --proxy http://proxy-wsa.esl.cisco.com:80/ etcd3 kubernetes
 2148  ./bin/k8s-topo --create examples/clus2019/conf_2019.yml
 2149  pip3 install netaddr --proxy http://proxy-wsa.esl.cisco.com:80/ etcd3 kubernetes networkx
 2150  ./bin/k8s-topo --create examples/clus2019/conf_2019.yml
 2151  kubectl get pods
 2152  kubectl edit service vetoed-parrot-etcd -n configuration
 2153  kubectl edit service grafana -n monitoring
 2154  kubectl get services --namespace=configuration
 2155  kubectl get services --namespace=monitoring
 2156  sudo iptables -t nat -A DOCKER -p tcp --dport 31596 -j DNAT --to-destination 10.192.0.2
 2157  sudo iptables -t nat -A POSTROUTING -j MASQUERADE -p tcp --source 10.192.0.2 --destination 10.192.0.2 --dport 31596
 2158  sudo iptables -A DOCKER -j ACCEPT -p tcp --destination 10.192.0.2 --dport 31596
 2159  kubectl edit service prometheus-server -n monitoring
 2160  kubectl get services --namespace=monitoring
 2161  kubectl exec -it influxdb-79998d74b-tvvdk -n monitoring  influx
 2162  kubectl get pods
 2163  kubectl get pods -n monitoring
 2164  kubectl exec -it influxdb-79998d74b-4jqcj -n monitoring  influx
 2165  docker inspect kube-node-2 | grep Cpu
 2166  docker inspect kube-node-1 | grep Cpu
 2167  docker inspect kube-master | grep Cpu
 2168  history