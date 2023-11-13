#!/bin/bash

function docker-install () {
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources:
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
}

function k8s-install () {
    apt install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
    apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    apt update
    apt install -y kubelet kubeadm kubectl
}

echo "========================================"
echo " Starting Kubernetes Installer"
echo "========================================"
echo ""
echo -ne "[INFO] Processing : Install Docker Service\033[0K\r"
docker-install > /tmp/k8s-install.log 2>&1
echo -e "[OK] Complete : Install Docker Service\033[0K\r"

echo -ne "[INFO] Processing : Install Kubernetes Service\033[0K\r"
k8s-install >> /tmp/k8s-install.log 2>&1
echo -e "[OK] Complete : Install Kubernetes Service\033[0K\r"
echo ""
echo "========================================"
echo " Kubernetes Installer Complete"
echo "========================================"