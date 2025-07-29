#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

#for NODE in "${NODES[@]}"; do
#  echo "Update the apt package index and install packages needed to use the Kubernetes apt repository on $NODE"
#  vagrant ssh "$NODE" -c "
#    sudo apt-get update &&
#    sudo apt-get install -y apt-transport-https ca-certificates curl gpg
#  " > /dev/null 2.&1 &
#done

wait
echo "Update the apt package index and install packages needed to use the Kubernetes apt repository Done"

for NODE in "${NODES[@]}"; do
  echo "Download the public signing key for the Kubernetes package repositories on $NODE"
  vagrant ssh "$NODE" -c "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg" > /dev/null &
done

wait
echo "Download the public signing key for the Kubernetes package repositories Done"

for NODE in "${NODES[@]}"; do
  echo "Add the appropriate Kubernetes apt repository on $NODE"
  vagrant ssh "$NODE" -c "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null" &
done

wait
echo "Add the appropriate Kubernetes apt repository Done"

for NODE in "${NODES[@]}"; do
  echo "Update the apt package index, install kubelet, kubeadm and kubectl, and pin their version on $NODE"
  vagrant ssh "$NODE" -c "
    sudo apt-get update &&
    sudo apt-get install -y kubelet kubeadm kubectl &&
    sudo apt-mark hold kubelet kubeadm kubectl
  " > /dev/null 2>&1 &
done

wait
echo "Update the apt package index, install kubelet, kubeadm and kubectl, and pin their version Done"