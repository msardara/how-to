# K8S - DIND Cluster Deployment

## Setup

This tutorial shows how to setup a K8S cluster inside docker containers (DIND).

Here we deploy K8S version 1.13.

Install docker

```bash
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Download the script from the kubeadm-dind-cluster repository and run it:

```bash
curl -OL https://github.com/kubernetes-sigs/kubeadm-dind-cluster/releases/download/v0.2.0/dind-cluster-v1.14.sh
chmod +x dind-cluster-v1.13.sh
./dind-cluster-v1.13.sh up
```

## Tear down

```bash
./dind-cluster-v1.13.sh down
```

## Delete

If you want to delete the cluster

```bash
./dind-cluster-v1.13.sh clean
```