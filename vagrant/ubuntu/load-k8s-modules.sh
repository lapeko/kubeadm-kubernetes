#!/bin/bash

set -e

# Load br_netfilter
modprobe br_netfilter

# Ensure it loads on boot
echo "br_netfilter" > /etc/modules-load.d/k8s.conf

# Set sysctl params
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# Apply sysctl params without reboot
sysctl --system
