#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

CONF_DIR="$HOME/.kube"
CONF_PATH="$CONF_DIR/config"

cd "$VAGRANT_PATH" || exit 1

echo "Copying kubeconfig from \"$MASTER_NODE\" to the host..."
mkdir -p "$CONF_DIR"
vagrant ssh "$MASTER_NODE" -c "cat /home/vagrant/.kube/config" > "$CONF_PATH"
echo -e "Kubeconfig saved to $CONF_PATH\n"
