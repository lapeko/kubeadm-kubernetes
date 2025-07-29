#!/bin/sh

set -e

if lsmod | grep -q '^kvm'; then
    echo "[INFO] KVM modules are loaded, unloading..."
    
    sudo rmmod kvm_intel 2>/dev/null || true
    sudo rmmod kvm_amd 2>/dev/null || true
    sudo rmmod kvm 2>/dev/null || true

    echo "[INFO] KVM modules unloaded"
else
    echo "[INFO] No KVM modules loaded"
fi
