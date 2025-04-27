#!/bin/bash

NODES=(master worker1 worker2)

# Actual version can be found here - https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md
VERSION="v1.30.0"

for node in "${NODES[@]}"; do
  echo "Removing conflict container packages from $node..."
  multipass exec $node -- bash -c "for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done" > /dev/null 2>&1
  echo "Removing conflict container packages from $node Done"
done

for node in "${NODES[@]}"; do
  echo "Installing containerd on $node..."
  
  multipass exec $node -- bash -c " sudo apt-get update &&
    sudo apt-get install ca-certificates curl &&
    sudo install -m 0755 -d /etc/apt/keyrings &&
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &&
    sudo chmod a+r /etc/apt/keyrings/docker.asc &&
    echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list &&
    sudo apt-get update &&
    sudo apt-get install -y containerd.io
  " > /dev/null 2>&1

  echo "Isntalling containerd in $node Done"
done

for node in "${NODES[@]}"; do
  echo "Installing crictl on $node..."

  multipass exec $node -- bash -c "wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz &&
    sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin &&
    rm -f crictl-$VERSION-linux-amd64.tar.gz" > /dev/null 2>&1

  multipass exec "$node" -- bash -c "
    sudo tee /etc/crictl.yaml <<EOF
    runtime-endpoint: unix:///run/containerd/containerd.sock
    image-endpoint: unix:///run/containerd/containerd.sock
    timeout: 2
    debug: false
EOF
  " > /dev/null 2>&1

  multipass exec $node -- bash -c "
    sudo groupadd -f containerd &&
    sudo chgrp containerd /run/containerd/containerd.sock &&
    sudo chmod 660 /run/containerd/containerd.sock &&
    sudo usermod -aG containerd ubuntu &&
    sudo mkdir -p /etc/systemd/system/containerd.service.d &&
    sudo tee /etc/systemd/system/containerd.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStartPost=/bin/chmod 660 /run/containerd/containerd.sock
ExecStartPost=/bin/chgrp containerd /run/containerd/containerd.sock
EOF &&
    sudo systemctl daemon-reload &&
    sudo systemctl restart containerd
  " > /dev/null 2>&1

  echo "Installing crictl on $node Done"
done

for node in "${NODES[@]}"; do
  echo "Fixing containerd CRI config on $node..."
  multipass exec "$node" -- bash -c "
    sudo mkdir -p /etc/containerd &&
    sudo tee /etc/containerd/config.toml > /dev/null <<EOF
[plugins."io.containerd.grpc.v1.cri"]
  sandbox_image = "registry.k8s.io/pause:3.9"
EOF
  && sudo systemctl restart containerd
  " > /dev/null 2>&1
  echo "Fixing containerd CRI config on $node Done"
done
