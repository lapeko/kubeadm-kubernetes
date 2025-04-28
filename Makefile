.PHONY: create recreate install_nodes install_containerd install_kubeadm init_kubeadm apply_flannel join_nodes delete_nodes

create: install_nodes install_containerd install_kubeadm init_kubeadm apply_flannel join_nodes
recreate: delete_nodes create

install_nodes:
	./01-create-vms-with-multipass.sh
install_containerd:
	./02-install-containerd.sh
install_kubeadm:
	./03-install-kubeadm.sh
init_kubeadm:
	./04-init-kubeadm.sh
apply_flannel:
	./05-apply-flannel.sh
join_nodes:
	./06-join-nodes.sh

delete_nodes:
	./99-delete-nodes.sh
