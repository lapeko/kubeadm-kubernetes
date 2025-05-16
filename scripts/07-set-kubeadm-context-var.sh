#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

CONF_PATH=$HOME/.kube/kubeadm.config

cd "$VAGRANT_PATH" || exit 1

echo "Copying kubeconfig from \"$MASTER_NODE\" to host..."
vagrant ssh "$MASTER_NODE" -c "cat /home/vagrant/.kube/config" > "$CONF_PATH"
echo -e "Kubeconfig saved to $CONF_PATH\n"

echo "To use correct kubeconfig run the commands below on your host:"
echo "export KUBECONFIG=$CONF_PATH"
echo "kubectl config --kubeconfig=$CONF_PATH use-context kubernetes-admin@kubernetes"
echo