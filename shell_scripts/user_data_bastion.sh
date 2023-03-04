#!/bin/bash

yum update -y

# Configuração da porta SSH
echo "Port 22222" >> /etc/ssh/sshd_config
systemctl restart sshd.service