## Criação de Instâncias de Máquina Virtual no Google Cloud Platform com Terraform

Este projeto utiliza o Terraform para criar três instâncias de máquina virtual no Google Cloud Platform (GCP). As instâncias são configuradas com um disco de inicialização, uma interface de rede e um endereço IP externo.

#### Requisitos:

Conta no Google Cloud Platform (GCP)
Terraform instalado na máquina local
Arquivo de credenciais do GCP (credentials.json)
#### Arquivos:

main.tf: arquivo de configuração do Terraform que define as instâncias de máquina virtual e os recursos necessários.
#### Recursos:

google_compute_instance: criação de instâncias de máquina virtual.
google_compute_address: criação de endereços IP externos.
google_compute_network: criação de uma rede virtual.
#### Instâncias de Máquina Virtual:

vm-control-plane: instância de máquina virtual para o controle de plano.
vm-worker01: instância de máquina virtual para o trabalhador 1.
vm-worker02: instância de máquina virtual para o trabalhador 2.
#### Configuração:

machine_type: tipo de máquina virtual (e2-small).
zone: zona de disponibilidade (us-central1-a).
boot_disk: disco de inicialização (ubuntu-2004-focal-v20241115).
network_interface: interface de rede (google_compute_network.vpc.self_link).
access_config: configuração de acesso (nat_ip e network_tier).
tags: etiquetas para as instâncias de máquina virtual.
#### Execução:

> Clone o repositório.

    git clone https://github.com/klimagt/pipeline-devops-tf.git

Edite o arquivo credentials.json com as suas credenciais do GCP.
> Execute o comando terraform init para inicializar o Terraform: 
    
    terraform init

> Execute o comando terraform apply para criar as instâncias de máquina virtual

    terraform apply
#### Observações:

Certifique-se de que as credenciais do GCP estejam configuradas corretamente.
Verifique se o Terraform está instalado na máquina local.
A criação das instâncias de máquina virtual pode levar alguns minutos.