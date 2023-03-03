# Atividade AWS docker

Trabalho para fixar conhecimentos de Docker. Realizado no programa de bolsas da Compass UOL.

Grupo: 
- [Alex](github.com/alexlsilva7)
- [Antonio]()
- [Erik]()

## Requisitos

- Instalação e configuração do DOCKER ou CONTAINERD no host EC2;
- Ponto adicional para o trabalho utilizar a instalação via script de Start Instance (user_data.sh)
- Efetuar Deploy de uma aplicação Wordpress com: 
  - Container de aplicação
  - Container database Mysql
  - Configuração da utilização do serviço EFS AWS para estáticos do container de aplicação Wordpress
  - Configuração do serviço de Load Balancer AWS para a aplicação Wordpress

### Pontos de atenção

- Não utilizar ip público para saída do serviços WP (Evitar publicar o serviço WP via IP Público)
- Sugestão para o tráfego de internet sair pelo LB (Load Balancer Classic)
- Pastas públicas e estáticos do wordpress sugestão de utilizar o EFS (Elastic File Sistem)
- Fica a critério de cada integrante (ou dupla) usar Dockerfile ou Dockercompose;
- Necessário demonstrar a aplicação wordpress funcionando (tela de login)
- Aplicação Wordpress precisa estar rodando na porta 80 ou 8080;
- Utilizar repositório git para versionamento;
- Criar documentação

## Execução do projeto
---

### Configuração do grupo de segurança

Configurar 2 grupos de segurança, um para a instância e outro para o load balancer.

- Grupo de segurança do load balancer

  Porta | Protocolo | Origem
  --- | --- | ---
  80 | TCP | 0.0.0.0/0

- Grupo de segurança da instância

  Porta | Protocolo | Origem 
  --- | --- | ---
  22 | TCP | 0.0.0.0/0
  2049 | TCP | 0.0.0.0/0
  2049 | UDP | 0.0.0.0/0
  80 | TCP | Grupo de segurança do load balancer

### Configuração da instância
- AM2 Linux 2
- t3.small
- 16GB GP2
- IP público

### Instalação do Docker

```bash
#atualizar os pacotes para a última versão
sudo yum update -y
#instalar o docker
sudo yum install docker
#iniciar o serviço do docker
sudo systemctl start docker
#habilitar o serviço do docker para iniciar automaticamente
sudo systemctl enable docker
#adicionar o usuário ec2-user ao grupo docker
sudo usermod -a -G docker ec2-user
```

### Instalação do Docker Compose

```bash
# baixar o docker-compose para a pasta /usr/local/bin
sudo curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# dar permissão de execução ao binário do docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Montagem do EFS

```bash
# criar o diretório para o EFS
mkdir -p /mnt/nfs
# adicionar o EFS no fstab
echo "IP_OU_DNS_DO_NFS:/ /mnt/nfs nfs defaults 0 0" >> /etc/fstab
# montar o EFS
mount -a
```

### Clonar o repositório para execução do projeto

```bash
# instalar o git
yum install git -y
git clone https://github.com/alexlsilva7/atividade_aws_docker.git /home/ec2-user/atividade_aws_docker
```

### Subir os containers

```bash
docker-compose -f /home/ec2-user/atividade_aws_docker/docker-compose.yml up -d
```

###  Exemplo de user data

```bash
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
echo "IP_OU_DNS_DO_NFS:/ /mnt/nfs nfs defaults 0 0" >> /etc/fstab
mount -a

# Executando o docker-compose do repositorio
yum install git -y
git clone https://github.com/alexlsilva7/atividade_aws_docker.git /home/ec2-user/atividade_aws_docker
docker-compose -f /home/ec2-user/atividade_aws_docker/docker-compose.yml up -d
```

### Configuração do Load Balancer

- Criar um grupo de destino e adicionar a instância criada
  - Nome: Wordpress
  - Protocolo: HTTP
  - Porta: 80

- Criar um Application Load Balancer
  - Listener: 80
  - Target Group: Grupo de destino criado anteriormente
  - Health Check: / (HTTP:80)

### Configuração do Wordpress

- Acessar o endereço do load balancer
- Instalar o Wordpress
  - Language: Português
  - TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
