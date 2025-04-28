#!/bin/bash

source ./vars.sh

echo "Waiting for flannel pods to be ready..."
for i in {1..30}; do
  PODS_READY=$(multipass exec "$MASTER_NODE" -- bash -lc "kubectl get pods -n kube-flannel | grep flannel | grep Running | wc -l")
  if [ "$PODS_READY" -gt 0 ]; then
    echo "Flannel pods are running."
    break
  else
    echo "Flannel not ready yet, sleeping 5 seconds... Attempt $i"
    sleep 5
  fi
done

JOIN_COMMAND=$(multipass exec "$MASTER_NODE" -- bash -lc "kubeadm token create --print-join-command")

for node in "${WORKER_NODES[@]}"; do
  echo "Joining node $node into cluster..."
  multipass exec "$node" -- bash -c "sudo ${JOIN_COMMAND}" > /dev/null 2>&1
  echo "Joining node $node into cluster Done"
done