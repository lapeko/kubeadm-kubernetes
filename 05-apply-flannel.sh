#!/bin/bash

source ./vars.sh

echo "Waiting for control plane components..."
for i in {1..30}; do
  if multipass exec "$MASTER_NODE" -- bash -lc "kubectl get pods -n kube-system | grep -E 'kube-apiserver|kube-controller-manager|kube-scheduler' | grep Running" > /dev/null 2>&1; then
    echo "Control plane is running!"
    break
  else
    echo "Control plane not ready yet, sleeping 5 seconds... Attempt $i"
    sleep 5
  fi
done

echo "Applying Flannel network..."
MASTER_TEMP_CONF=/tmp/admin.conf
LOCAL_TEMP_CONF=./admin.conf

multipass exec "$MASTER_NODE" -- bash -c "
  sudo cp /etc/kubernetes/admin.conf $MASTER_TEMP_CONF &&
  sudo chown \$(id -u):\$(id -g) $MASTER_TEMP_CONF
"
multipass transfer "$MASTER_NODE:$MASTER_TEMP_CONF" "$LOCAL_TEMP_CONF"
multipass exec "$MASTER_NODE" -- bash -c "rm $MASTER_TEMP_CONF"

for node in "${WORKER_NODES[@]}"; do
  multipass transfer "$LOCAL_TEMP_CONF" "$node:admin.conf"
  multipass exec "$node" -- bash -c "
    mkdir -p ~/.kube &&
    mv ~/admin.conf ~/.kube/config &&
    sudo chown \$(id -u):\$(id -g) ~/.kube/config
  " > /dev/null 2>&1
done
rm "$LOCAL_TEMP_CONF"
multipass exec "$MASTER_NODE" -- bash -lc "kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml" > /dev/null 2>&1