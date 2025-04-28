#!/bin/bash

MASTER_NODE=master
WORKER_NODES=()
NODES=(master "${WORKER_NODES[@]}")
CRI_SOCKET="unix:///run/containerd/containerd.sock"
CRICRL_DEBUG=false
KUBEADM_CONF=./kubeadm-config.yaml

# Check the actual latest VERSION on https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md
VERSION="v1.30.0"