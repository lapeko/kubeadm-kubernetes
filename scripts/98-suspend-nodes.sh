#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

echo "Running 'vagrant suspend'..."
vagrant suspend
echo "Running 'vagrant suspend' Done"
