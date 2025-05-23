.PHONY: up recreate run_nodes install_kubeadm install_container_runtime init_kubeadm install_cni workers_join_k8s set_kubeadm_context_var turn_off_nodes suspend_nodes clean_up_nodes

up: run_nodes install_kubeadm install_container_runtime init_kubeadm install_cni workers_join_k8s set_kubeadm_context_var
recreate: clean_up_nodes up

SCRIPTS_PATH=./scripts

run_nodes:
	$(SCRIPTS_PATH)/01-run-nodes.sh
install_kubeadm:
	$(SCRIPTS_PATH)/02-install-kubeadm.sh
install_container_runtime:
	$(SCRIPTS_PATH)/03-install-container-runtime.sh
init_kubeadm:
	$(SCRIPTS_PATH)/04-init-kubeadm.sh
install_cni:
	$(SCRIPTS_PATH)/05-install-cni.sh
workers_join_k8s:
	$(SCRIPTS_PATH)/06-workers-join-k8s.sh
set_kubeadm_context_var:
	$(SCRIPTS_PATH)/07-set-kubeadm-context-var.sh

turn_off_nodes:
	$(SCRIPTS_PATH)/97-turn-off-nodes.sh
suspend_nodes:
	$(SCRIPTS_PATH)/98-suspend-nodes.sh
clean_up_nodes:
	$(SCRIPTS_PATH)/99-purge-nodes.sh