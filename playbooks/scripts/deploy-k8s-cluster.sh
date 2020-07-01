#!/bin/bash

echo -n "Root password:"
read -s password

ansible-playbook -i hosts.k8s add-new-nodes-ssh-know-hosts.yml

for i in $(ansible -i hosts.k8s --list-hosts all | grep k);do sshpass -p $password ssh-copy-id $i ;done

ansible-playbook -i hosts.k8s chrony.yml

ansible-playbook -i hosts.k8s swap-disable.yml

ansible-playbook -i hosts.k8s create_sysctl.d_k8s_conf.yml

ansible-playbook -i hosts.k8s fw-rules.yml

ansible-playbook -i hosts.k8s selinux-adjusts.yml

ansible-playbook -i hosts.k8s createdockerdisk.yml

ansible-playbook -i hosts.k8s install-kube-services.yml

ansible-playbook -i hosts.k8s install-haproxy-lb.yml

ssh kmaster0 kubeadm init --control-plane-endpoint "k8s.home.lab:6443" --upload-certs --service-cidr=172.30.0.0/16 --pod-network-cidr=10.128.0.0/14
