## Description

This repository contains automated setup scripts for setting up fresh installation of the following OS systems:
- Ubuntu v20.04

## Components that will be installed
- Basic system components (e.g. net-tools for Ubuntu)
- Vim editor with common configuration file `$HOME/.vimrc`
- Git with default editor set to `vim`
- Python 3 set as default
- Docker and Docker compose

## How to run? 

**For Ubuntu** run the following command, where `VERSION` is your OS version:
```bash
wget -qO - https://github.com/alexZaicev/setup/blob/main/setup_ubuntu_v20.04.sh | sh
```
