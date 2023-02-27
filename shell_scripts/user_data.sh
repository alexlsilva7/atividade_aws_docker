#!/bin/bash

# Instalação e configuração do Docker
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

# Instalação do docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Montagem do efs
sudo mkdir -p /mnt/nfs
sudo echo "IP_OU_DNS_DO_NFS:/ /mnt/nfs nfs defaults 0 0" >> /etc/fstab
sudo mount -a

# Executando o docker-compose do repositorio
sudo yum install git -y
sudo cd /home/ec2-user
sudo git clone https://github.com/alexlsilva7/atividade_aws_docker.git
sudo cd /home/ec2-user/atividade_aws_docker
sudo docker-compose up -d