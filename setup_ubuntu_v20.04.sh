#!/bin/bash

echo "Running setup script for Ubuntu v20.04"
echo "#######################################################"
echo ""

export DEBIAN_FRONTEND=noninteractive ;
export DEBCONF_NONINTERACTIVE_SEEN=true ;

echo "Step 1: Update system after fresh install..."
echo ""
set -eux ; \
    sudo apt-get update ; \
    sudo apt-get upgrade -y ;

echo "Step 2: Install basic components..."
echo ""
set -eux ; \
    sudo apt-get update ; \
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

echo "Step 3: Install Git..."
echo ""
set -eux ; \
    sudo apt-get update ; \
    sudo apt-get install -y git ; \
    git config --global core.editor "vim" ; 

echo "Step 4: Install Python..."
echo ""
set -eux ; \
    sudo apt-get update ; \
    sudo apt-get install -y python3 python3-pip ; \
    echo "alias python=python3" >> ~/.bash_aliases ; \
    echo "alias pip=pip3" >> ~/.bash_aliases ; \
    source ~/.bash_aliases ;
    

echo "Step 5: Install Docker and Docker Compose..."
echo ""
set -eux ; \
    sudo apt-get update ; \
    sudo apt-get remove docker docker-engine docker.io containerd runc ; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg ; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null ; \
    sudo apt-get update ; \
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io ;
    sudo groupadd docker ; \
    sudo usermod -aG docker $USER ; \
    sudo systemctl enable docker ;
    sudo curl -L "https://github.com/docker/compose/releases/download/2.4.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose ; \
    sudo chmod +x /usr/local/bin/docker-compose ; \

echo "Step 6: Default configuration files..."
echo ""
set -eux ; \
    curl https://raw.githubusercontent.com/alexZaicev/setup/master/vimrc >> ~/.vimrc ;

echo "Setup finished successfully."
echo ""
echo "In order to allow your user to pick up all the changes made by the setup script, we recommend you to re-login."
echo ""
