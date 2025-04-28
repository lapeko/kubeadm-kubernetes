.PHONY: cluster_up cluster_reinstall install_nodes install_containerd install_kubeadm delete_nodes

cluster_up: install_nodes install_containerd install_kubeadm
cluster_reinstall: delete_nodes cluster_up

install_nodes:
	./01-create-vms-with-multipass.sh
install_containerd:
	./02-install-containerd.sh
install_kubeadm:
	./03-install-kubeadm.sh

delete_nodes:
	./99-delete-nodes.sh
