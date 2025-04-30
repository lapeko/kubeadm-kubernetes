#!/bin/bash

set -e

# Enable IP forwarding immediately (runtime)
sysctl -w net.ipv4.ip_forward=1

# Ensure all required settings persist after reboot
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# Load kernel module immediately
modprobe br_netfilter

# Ensure module loads on boot
echo "br_netfilter" > /etc/modules-load.d/k8s.conf

# Apply sysctl params now
sysctl --system
