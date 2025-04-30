#!/bin/bash

echo "To use correct kubeconfig run the commands bellow:
export KUBECONFIG=$HOME/.kube/kubeadm.conf
kubectl config --kubeconfig=$HOME/.kube/kubeadm.conf use-context kubernetes-admin@kubernetes"
