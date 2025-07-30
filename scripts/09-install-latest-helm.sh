#!/usr/bin/env bash

set -e

echo "Installing HELM..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "Installing HELM Done"