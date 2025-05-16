#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/vars.sh"

cd "$VAGRANT_PATH" || exit 1

FLANNEL_MANIFEST=kube-flannel.yml

echo "Deploying Flannel with kubectl on $MASTER_NODE..."

vagrant ssh "$MASTER_NODE" -c "
  curl -LO https://github.com/flannel-io/flannel/releases/latest/download/${FLANNEL_MANIFEST} &&
  sed -i '/--kube-subnet-mgr/a\        - --public-ip=\$(FLANNEL_PUBLIC_IP)' ${FLANNEL_MANIFEST} &&
  sed -i '/env:/a\        - name: FLANNEL_PUBLIC_IP\\n          valueFrom:\\n            fieldRef:\\n              fieldPath: status.hostIP' ${FLANNEL_MANIFEST} &&
  kubectl apply -f ${FLANNEL_MANIFEST} &&
  rm ${FLANNEL_MANIFEST}
" > /dev/null

echo "Deploying Flannel with kubectl on $MASTER_NODE Done"
