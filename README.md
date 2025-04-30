# kubeadm-kubernetes

Lightweight Kubernetes cluster automated setup using Vagrant, Flannel, and kubeadm.

## Features

- Vagrant-based Kubernetes cluster (1 control plane + 2 workers)
- Ubuntu 22.04.5 LTS (`ubuntu/jammy64`)
- `kubeadm`, `kubelet`, `kubectl` preinstalled
- Flannel CNI with proper `br_netfilter` and sysctl setup
- Aliases and autocompletion for `kubectl`
- SSH setup across nodes
- Makefile to rule it all

## Requirements

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- UNIX-based host system (Linux/macOS recommended)
- [make](https://www.gnu.org/software/make/manual/make.html#Reading)

## Usage

```bash
git clone git@github.com:lapeko/kubeadm-kubernetes.git
cd kubeadm-kubernetes
make up
vagrant ssh <controlplane | node01 | node02>
```

`kubectl` is only available on the `controlplane` node. SSH in and use `kubectl` or `k`.
 