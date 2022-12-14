#!/bin/bash

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release 

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg 
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

usermod -aG docker ubuntu

sudo apt-get autoremove -y

sudo curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo mkdir /home/ubuntu/sui
sudo wget https://raw.githubusercontent.com/MystenLabs/sui/main/docker/fullnode/docker-compose.yaml -O /home/ubuntu/sui/docker-compose.yaml
sudo wget https://github.com/MystenLabs/sui/raw/main/crates/sui-config/data/fullnode-template.yaml -O /home/ubuntu/sui/fullnode-template.yaml
sudo wget https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob -O /home/ubuntu/sui/genesis.blob