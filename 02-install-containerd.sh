#!/bin/bash

source ./vars.sh

for node in "${NODES[@]}"; do
  echo "Setting up containerd on a node $node..."

  multipass exec "$node" -- bash -c "
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y \$pkg; done &&
    sudo apt-get update &&
    sudo apt-get install -y containerd &&
    sudo mkdir -p /etc/containerd &&
    sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null &&
    sudo systemctl restart containerd &&

    wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz &&
    sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin &&
    rm -f crictl-$VERSION-linux-amd64.tar.gz &&

    sudo tee /etc/crictl.yaml > /dev/null <<EOF
runtime-endpoint: $CRI_SOCKET
image-endpoint: $CRI_SOCKET
timeout: 2
debug: $CRICRL_DEBUG
pull-image-on-create: false
EOF

    sudo mkdir -p /etc/systemd/system/containerd.service.d &&
    sudo tee /etc/systemd/system/containerd.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStartPost=/bin/chmod 666 /run/containerd/containerd.sock
EOF
    sudo systemctl daemon-reload &&
    sudo systemctl restart containerd
  " > /dev/null 2>&1 &

  echo "Setting up containerd on a node $node Done"
done

wait
