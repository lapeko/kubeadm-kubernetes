#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

echo "initialize kubeadm on $MASTER_NODE..."
vagrant ssh "$NODE" -c 'sudo kubeadm init --apiserver-advertise-address 192.168.56.11 --pod-network-cidr "10.244.0.0/16" --upload-certs' > /dev/null
echo "initialize kubeadm on $MASTER_NODE Done"
