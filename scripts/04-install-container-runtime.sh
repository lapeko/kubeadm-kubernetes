#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

for NODE in "${NODES[@]}"; do
  echo "Install containerd on $NODE"
  vagrant ssh "$NODE" -c "
    sudo apt-get update
    sudo apt-get install -y containerd
  " > /dev/null 2>&1 &
done

wait
echo "Install containerd Done"

for NODE in "${NODES[@]}"; do
  echo "Configuring the systemd cgroup driver on $NODE"
  vagrant ssh "$NODE" -c "
    sudo mkdir -p /etc/containerd &&
    containerd config default | \
      sed 's/SystemdCgroup = false/SystemdCgroup = true/' | \
      sudo tee /etc/containerd/config.toml &&
    sudo systemctl restart containerd
  " > /dev/null &
done

wait
echo "Configuring the systemd cgroup driver Done"