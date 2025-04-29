SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAGRANT_PATH="$SCRIPT_DIR/../vagrant"
MASTER_NODE=controlplane
WORKER_NODES=(node01 node02)
NODES=("$MASTER_NODE" "${WORKER_NODES[@]}")