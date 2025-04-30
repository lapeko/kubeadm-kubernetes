#!/bin/bash

cat <<EOF >> /home/vagrant/.bashrc

# K8s autocomplete and aliases
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF
