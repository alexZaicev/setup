#!/bin/bash

function wait_input {
    echo "Press any key to continue..."
    while [ true ] ; do
        read -t 3 -n 1
        if [ $? = 0 ] ; then
            break ;
        fi
    done
}

function sep {
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

echo "Step 0: Checking prerequisites..."
sep
check_prereq

echo "Step 1: Update system after fresh install..."
sep
set -eux ; \
    sudo apt-get update ; \
    sudo apt-get upgrade -y ;

echo "Step 2: Install basic components..."
sep
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
        awk \
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
sep
set -eux ; \
    sudo apt-get update ; \
    sudo apt-get install -y git ; \
    cat gitconfig | \
        sed "s|\${GIT_USER}|${GIT_USER}|" | \
        sed "s|\${GIT_EMAIL}|${GIT_EMAIL}|" | \
        sed "s|\${GIT_TOKEN}|${GIT_TOKEN}|" | \
        sed "s|\${HOME}|${HOME}|" >> ${HOME}/.gitconfig ; \
    cp gitignore_global .gitignore_global ;

echo "Step 4: Install Python..."
sep
set -eux ; \
    sudo apt-get update ; \
    sudo apt-get install -y python3 python3-pip ; \
    echo "alias python=python3" >> ~/.bash_aliases ; \
    echo "alias pip=pip3" >> ~/.bash_aliases ; \
    source ~/.bash_aliases ;
    

echo "Step 5: Install Docker and Docker Compose..."
sep
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
sep
set -eux ; \
    curl -Lq https://raw.githubusercontent.com/alexZaicev/setup/master/vimrc >> ~/.vimrc ;
    curl -Lq https://raw.githubusercontent.com/alexZaicev/setup/master/bash_profile >> ~/.bash_profile ;

echo "Setup finished successfully."
echo "In order to allow your user to pick up all the changes made by the setup script, we recommend you to re-login."

