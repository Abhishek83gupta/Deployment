#!/bin/bash
set -e

# Execute ONLY on the "Master" Node

# Initialize Kubernetes control-plane
kubeadm init

# Configure kubectl for root user
mkdir -p $HOME/.kube
cp /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico (CNI)
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml

# Display join command for workers
kubeadm token create --print-join-command
