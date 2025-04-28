#!/bin/bash

source ./vars.sh

if ! command -v multipass &> /dev/null
then
    echo "Multipass not found, installing..."
    sudo snap install multipass
else
    echo "Multipass is already installed."
fi

echo "Launching $MASTER_NODE node..."
multipass launch --cpus 2 --memory 2G --disk=20G --name "$MASTER_NODE" &

for node in "${WORKER_NODES[@]}"; do
  echo "Launching $node node..."
  multipass launch --memory 2048M --name "$node" &
done

wait

declare -A NODE_IPS
for NODE in "${NODES[@]}"; do
  NODE_IPS["$NODE"]=$(multipass info "$NODE" | grep IPv4 | awk '{print $2}')
done

declare HOSTS="127.0.0.1 localhost"$'\n'
for NODE in "${NODES[@]}"; do
  HOSTS+="${NODE_IPS["$NODE"]} $NODE"$'\n'
done

for NODE in "${NODES[@]}"; do
  echo "$HOSTS" | multipass exec "$NODE" -- sudo tee "/etc/hosts" > /dev/null 2>&1
  multipass exec "$NODE" -- bash -c "sudo touch /etc/cloud/cloud-init.disabled" > /dev/null 2>&1
done
echo "127.0.0.1 kubernetes.default.svc.cluster.local kubernetes.default kubernetes" | multipass exec "$MASTER_NODE" -- sudo tee -a "/etc/hosts" > /dev/null 2>&1

for NODE in "${NODES[@]}"; do
  multipass exec "$NODE" -- sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 > /dev/null 2>&1 &
  multipass exec "$NODE" -- sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1 > /dev/null 2>&1 &
  multipass exec "$NODE" -- sudo bash -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf' > /dev/null 2>&1 &
  multipass exec "$NODE" -- sudo bash -c 'echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf' > /dev/null 2>&1 &
done

wait

echo "Cluster VMs are launched!"
