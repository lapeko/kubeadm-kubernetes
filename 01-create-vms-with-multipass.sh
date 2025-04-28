#!/bin/bash

source ./vars.sh

# Check if multipass is installed
if ! command -v multipass &> /dev/null
then
    echo "Multipass not found, installing..."
    sudo snap install multipass
else
    echo "Multipass is already installed."
fi

# Create master node
echo "Launching $MASTER_NODE node..."
multipass launch --cpus 4 --memory 8G --disk 30G --name "$MASTER_NODE"

# Create worker nodes
for node in "${WORKER_NODES[@]}"; do
  echo "Launching $node node..."
  multipass launch --memory 2048M --name "$node"
done

echo "Cluster VMs are launched!"
