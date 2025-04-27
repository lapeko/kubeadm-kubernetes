.PHONY: cluster_up cluster_reinstall install_nodes install_containerd delete_nodes

cluster_up: install_nodes install_containerd
cluster_reinstall: delete_nodes cluster_up
install_nodes:
	./01-create-vms-with-multipass.sh
install_containerd:
	./02-install-containerd.sh
delete_nodes:
	./99-delete-nodes.sh
