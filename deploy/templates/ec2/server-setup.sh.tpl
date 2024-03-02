#!/bin/bash
set -e

sudo yum update -y
sudo yum install -y docker

sudo service docker start
sudo chkconfig docker on # auto restart docker

# sudo systemctl enable docker.service
# sudo systemctl start docker.service

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo usermod -aG docker ec2-user # Add user to "docker" group for permissions

cd ~

sudo yum install -y git
git clone https://github.com/ufosc/Jukebox-Server.git /home/ec2-user/Jukebox-Server


%{ for env_key, env_value in env }
echo "${env_key}=${env_value}" >> /home/ec2-user/Jukebox-Server/.env
%{ endfor ~}

sudo docker-compose -f /home/ec2-user/Jukebox-Server/docker-compose.prod.yml up -d --build
