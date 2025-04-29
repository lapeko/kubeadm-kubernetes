#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

echo "Deploying Flannel with kubectl on $MASTER_NODE..."
vagrant ssh "$MASTER_NODE" -c "kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml" > /dev/null
echo "Deploying Flannel with kubectl on $MASTER_NODE Done"
