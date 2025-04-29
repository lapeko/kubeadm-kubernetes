#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

echo "Running 'vagrant destroy -f'..."
vagrant destroy -f > /dev/null
echo "Running 'vagrant destroy -f' Done"
