#!/bin/bash

# Check if multipass is installed
if ! command -v multipass &> /dev/null
then
    echo "Multipass not found, installing..."
    sudo snap install multipass
else
    echo "Multipass is already installed."
fi

# Create master node
echo "Launching master node..."
multipass launch --cpus 2 --memory 2048M --disk 10G --name master

# Create worker nodes
echo "Launching worker1 and worker2..."
multipass launch --memory 2048M --name worker1
multipass launch --memory 2048M --name worker2

echo "Cluster VMs are launched!"
