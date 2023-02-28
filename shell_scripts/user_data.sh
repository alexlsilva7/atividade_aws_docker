#!/bin/bash

# Instalação e configuração do Docker
yum update -y
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Instalação do docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Montagem do efs
mkdir -p /mnt/nfs
echo "172.31.72.139:/ /mnt/nfs nfs defaults 0 0" >> /etc/fstab
mount -a

# Executando o docker-compose do repositorio
yum install git -y
git clone https://github.com/alexlsilva7/atividade_aws_docker.git /home/ec2-user/atividade_aws_docker
docker-compose -f /home/ec2-user/atividade_aws_docker/docker-compose.yml up -d