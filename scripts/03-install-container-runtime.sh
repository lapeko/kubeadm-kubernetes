#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

for NODE in "${NODES[@]}"; do
  echo "Install containerd on $NODE"
  vagrant ssh "$NODE" -c "
    sudo apt update
    sudo apt install -y containerd
  " > /dev/null &
done

wait
echo "Install containerd Done"