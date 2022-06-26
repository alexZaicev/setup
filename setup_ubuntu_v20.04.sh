#!/bin/bash

set -eu

REPO="https://raw.githubusercontent.com/alexZaicev/setup/master"

function wait_input {
    echo "Press any key to continue..."
    while [ true ] ; do
        read -t 3 -n 1
        if [ $? = 0 ] ; then
            break ;
        fi
    done
}

function step {
    echo ""
    echo $1
    echo "##########################################################################"
    echo ""
}

function err {
    echo "ERROR: $1"
    exit 1;
}

function check_prereq {
    if [ -z ${GIT_USER+no} ]; then 
        err "Github account username not set"
    fi
    
    if [ -z ${GIT_EMAIL+no} ]; then 
        err "Github account email not set"
    fi
    
    if [ -z ${GIT_TOKEN+no} ]; then 
        err "Github authentication token not set"
    fi
}

echo "Running setup script for Ubuntu v20.04"
sep
echo "Make sure that the following environmental variables are set\nprior to continuing with the setup:"
echo "  - GIT_USER    - Github account username"
echo "  - GIT_EMAIL   - Github account email"
echo "  - GIT_TOKEN   - Github authentication token"
echo ""
wait_input

export DEBIAN_FRONTEND=noninteractive ;
export DEBCONF_NONINTERACTIVE_SEEN=true ;

step "Step 0: Checking prerequisites..."
check_prereq

step "Step 1: Update system after fresh install..."
sudo apt-get update ;
sudo apt-get upgrade -y ;
    
step "Step 2: Default configuration files..."
curl -Lq ${REPO}/vimrc >> ${HOME}/.vimrc ; 
curl -Lq ${REPO}/bash_profile >> ${HOME}/.profile ;
source .profile ;

step "Step 3: Install basic components..."
sudo apt-get update ;
sudo apt-get install -y \
        build-essential \
        software-properties-common \
        gpg-agent \
        init \
        jq \
        curl \
        wget \
        vim \
        zip \
        unzip \
        less \
        gawk \
        ca-certificates \
        openssh-client \
        openssh-server \
        graphviz \
        net-tools \
        netcat \
        sed \
        lsb-release \
        apt-transport-https \
        bash-completion \
        netcat \
        bsdmainutils \
        gnupg-agent ;

step "Step 4: Install Git..."
sudo apt-get update ; 
sudo apt-get install -y git ; 
curl -Lq ${REPO}/gitconfig | \
        sed "s|\${GIT_USER}|${GIT_USER}|" | \
        sed "s|\${GIT_EMAIL}|${GIT_EMAIL}|" | \
        sed "s|\${GIT_TOKEN}|${GIT_TOKEN}|" | \
        sed "s|\${HOME}|${HOME}|" >> ${HOME}/.gitconfig ;
curl -Lq ${REPO}/gitignore_global >> ${HOME}/.gitignore_global ;
    
step "Step 5: Install Docker and Docker Compose..."
curl -Lq https://get.docker.com | bash ;

step "Step 6: Install Kubernetes..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - ;
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list ;
sudo apt-get update ;
sudo apt-get install -y kubeadm ;
sudo kubeadm init ;
mkdir -p $HOME/.kube ;
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config ;
sudo chown $(id -u):$(id -g) $HOME/.kube/config ;
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" ;
kubectl taint node --all node-role.kubernetes.io/master-

set +eu

echo ""
echo "Setup finished successfully."
echo "In order to allow your user to pick up all the changes made by the setup script, we recommend you to re-login."
echo ""
echo "If you think you found a bug, please open an issue in this Github repository https://github.com/alexZaicev/setup."
echo ""

