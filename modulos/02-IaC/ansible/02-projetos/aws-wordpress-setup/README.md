## Configurando uma instância na AWS para WordPress com Ansible

### Descrição do Projeto

O objetivo principal é implementar uma instância que atenda as demandas de um projeto wordpress. Para este cenário vou utilizar o worpdress na sua última versão que depende de um php7.0 no mínimo (se for replicar isso em um futuro distante, fique atento as dependencias do wordpress na versão utilizada).
Vamos usar o Ansible para implementar automaticamente as configurações necessárias para que o WordPress possa ser instalado e configurado.
Lembrando que o objetivo é fazer funcionar.. melhorias de conceitos de segurança, performance, boas praticas e etc serão aplicadas futuramente nesse repo.

### Pipeline do projeto

* Instalar o Ansible e criar a conta na AWS (ou instalar e configurar o Vagrant se for o caso);
* Criar a instância no hosting escolhido;
* Criar e configurar o arquivo de inventory (hosts);
* Testar a comunicação ansible <--> host;
* Criar a árvore de diretórios para organizar as roles do Ansible (mysql, php, server e wordpress);
* Criar os arquivos necessários para cada roles;
* Criar o playbook de configstart.yml para aplicar cada role;
* Testar o playbook configstart.yml e depurar os erros;
* Aplicar o playbook no ambiente;
* Testar o ambiente.

### Softwares & versões 

1. SO da Instância:
```
$ hostnamectl | grep -i "operating system"
Operating System: Debian GNU/Linux 10 (buster)
```

2. Versão do Ansible:
```
$ ansible --version
ansible [core 2.14.3]
  config file = None
  configured module search path = ['/home/oalves/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/oalves/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.11.2 (main, Mar 13 2023, 12:18:29) [GCC 12.2.0] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True
```

**OBS:** Caso queira replicar o ambiente em uma instância vagrant siga use o Vagrantfile disponível no diretório deste projeto.
