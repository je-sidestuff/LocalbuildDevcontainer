#!/bin/bash

apt update -y
apt install -y python3-pip

pip3 install pre-commit

echo 'source /scripts/configure_devcontainer_environment.sh' >> /home/vscode/.bashrc

echo 'source /scripts/devcontainer_runtime_startup.sh' >> /home/vscode/.bashrc