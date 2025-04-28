#!/bin/bash

source ./vars.sh

echo "Init kubeadm on $MASTER_NODE..."
multipass transfer "$KUBEADM_CONF" "$MASTER_NODE:kubeadm-config.yaml"

multipass exec "$MASTER_NODE" -- bash -c "
  sudo kubeadm init --config=kubeadm-config.yaml &&
  mkdir -p ~/.kube &&
  sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config &&
  sudo chown \$(id -u):\$(id -g) ~/.kube/config
" > /dev/null 2>&1
echo "Init kubeadm on $MASTER_NODE Done"
