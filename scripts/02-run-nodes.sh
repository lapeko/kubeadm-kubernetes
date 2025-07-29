#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

status_output=$(vagrant status)

need_up=false
need_resume=false

while read -r line; do
    if [[ "$line" == *"not created"* ]] || [[ "$line" == *"poweroff"* ]]; then
        need_up=true
    fi
    if [[ "$line" == *"saved"* ]]; then
        need_resume=true
    fi
done <<< "$status_output"

if $need_up; then
    echo "Some or all machines are not running. Running 'vagrant up'..."
    vagrant up > /dev/null
    echo "Running 'vagrant up' Done"
elif $need_resume; then
    echo "Some machines are suspended. Running 'vagrant resume'..."
    vagrant resume > /dev/null
    echo "Running 'vagrant resume' Done"
else
    echo "All machines are running or in a healthy state. Nothing to do."
fi
