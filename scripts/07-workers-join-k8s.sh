#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

JOIN_CMD=$(vagrant ssh controlplane -c "kubeadm token create --print-join-command" | tr -d '\r')

for NODE in "${WORKER_NODES[@]}"; do
  echo "Node $NODE joining ${MASTER_NODE}..."
  vagrant ssh "$NODE" -c "sudo $JOIN_CMD" > /dev/null &
done

wait
echo "Nodes ${WORKER_NODES[*]} joined ${MASTER_NODE}"
