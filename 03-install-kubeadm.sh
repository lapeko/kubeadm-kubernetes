#!/bin/bash

source ./vars.sh

for node in "${NODES[@]}"; do
  echo "Preparing network modules and sysctl on $node..."
  multipass exec "$node" -- bash -c "
    sudo modprobe br_netfilter &&
    sudo tee /etc/modules-load.d/k8s.conf > /dev/null <<EOF
br_netfilter
EOF
    sudo tee /etc/sysctl.d/k8s.conf > /dev/null <<EOF
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
    sudo sysctl --system
  " > /dev/null 2>&1
  echo "Preparing network modules and sysctl on $node Done"
done

for node in "${NODES[@]}"; do
  echo "Installing kubelet, kubeadm and kubectl on $node..."
  multipass exec "$node" -- bash -c "
    sudo apt-get update &&
    sudo apt-get install -y apt-transport-https ca-certificates curl gpg &&
    sudo mkdir -p /etc/apt/keyrings &&
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg &&
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list &&
    sudo apt-get update &&
    sudo apt-get install -y kubelet kubeadm kubectl &&
    sudo apt-mark hold kubelet kubeadm kubectl &&
    sudo systemctl enable --now kubelet
  " > /dev/null 2>&1
  echo "Installing kubelet, kubeadm and kubectl on $node Done"
done

echo "Init kubeadm on $MASTER_NODE..."
multipass exec "$MASTER_NODE" -- bash -c "
  sudo kubeadm init --pod-network-cidr=10.244.0.0/16
" > /dev/null 2>&1

echo "Init kubeadm on $MASTER_NODE 10 seconds sleeping..."
sleep 10
echo "Init kubeadm on $MASTER_NODE woke up and continued..."

multipass exec "$MASTER_NODE" -- bash -lc "
  mkdir -p ~/.kube &&
  sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config &&
  sudo chown \$(id -u):\$(id -g) ~/.kube/config &&
  kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
" > /dev/null 2>&1

echo "Init kubeadm on $MASTER_NODE Done"

JOIN_COMMAND=$(multipass exec "$MASTER_NODE" -- bash -lc "kubeadm token create --print-join-command")

for node in "${WORKER_NODES[@]}"; do
  echo "Joining node $node into cluster..."

  USER_HOME=$(multipass exec "$node" -- bash -c "echo \$HOME")
  multipass exec "$node" -- bash -c "
    sudo ${JOIN_COMMAND} &&
    mkdir -p ${USER_HOME}/.kube &&
    sudo cp /etc/kubernetes/admin.conf ${USER_HOME}/.kube/config &&
    sudo chown \$(id -u):\$(id -g) ${USER_HOME}/.kube/config
  " > /dev/null 2>&1

  echo "Joining node $node into cluster Done"
done
