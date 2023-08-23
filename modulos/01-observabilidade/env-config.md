## Configuração do ambiente com Vagrant
Passos para configuração do ambiente com Vagrant + Virtualbox.


### 1. Instalação do Vagrant</br>
Para instalar o Vagrant eu segui o processo disponível no <a href="https://developer.hashicorp.com/vagrant/downloads">site oficial</a> com a versão: lasted.

### 2. Instalação do VirtualBox</br>
O Vagrant não se comporta muito bem com as versões mais recentes do vbox, então encontrei um processo na documentação do VirtualBox que funcionou para mim:
```
sudo apt-get install build-essential linux-headers-`uname -r`
sudo apt-get install autoconf automake bc bison build-essential flex gcc g++ make python-is-python3 2to3 -y
sudo apt-get purge virtualbox

sudo sh -c 'echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -c | cut -f2) non-free contrib" >> /etc/apt/sources.list.d/virtualbox.org.list'

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox-6.1
```

### 3. Inicie uma VM com o Vagrant</br>
Aqui se inicia a configuração do ambiente dentro do Vagrant.

#### 3.1. Primeiro crie um diretório para armazenar os arquivos
```
$ mkdir ~/Documents/instance
$ cd ~/Documents/instance
```

#### 3.2. Sincronize uma Box/debian-12 do Vagrant com o comando abaixo
```
$ vagrant init alvistack/debian-12
```

#### 3.3. Inicie a VM
```
$ vagrant up
```
Atenção: Este processo pode levar alguns minutos, se for a primeira vez que está sincronizando essa Box ele irá baixar todos os arquivos.</br>
Após encerrar a inicialização abra o VirtualBox e adicione uma regra de compartilhamento de porta: Network > Advanced > Port Forwarding.</br>
Coloque a seguinte configuração:
```
Name: http
Protocol: TCP
Host IP adress:127.0.0.1
Host Port: 8080
Guest IP: 
Guest Port: 8080
``` 
Essa regra é importante para que você consiga acessar a API via browser pela porta 8080.

#### 3.4. Copie o arquivo "api.zip" para a VM
```
$ vagrant upload ~/Downloads/api.zip
```
Com esse comando o arquivo será copiado para a pasta raiz do usuário "vagrant".

#### 3.5. Acesse a VM via SSH
```
$ vagrant ssh
```

### 4. Instale todos os programas necessários
```
$ sudo apt update && sudo apt upgrade -y
$ sudo apt install screen
$ sudo apt install openjdk-17-jdk
$ sudo apt install maven
```
Para a instalação do Docker, siga a <a href="https://docs.docker.com/engine/install/ubuntu/">documentação oficial</a>.

### 4. Descompacte os arquivos na VM
```
$ unzip api.zip
```

### 5. Inicialize a aplicação</br>
Aqui vamos efetuar a configuração inicial da aplicação efetuarmos o primeiro teste.

#### 5.1. Populando o banco de dados</br>
Primeiro rode o comando abaixo para popular o banco de dados que será executado dentro de um container Docker.
```
$ screen -S docker-up -dm bash -c 'cd ~/api/; sudo docker compose up'
```
Você pode acompanhar o progresso com o comando abaixo:
```
$ screen -r docker-up
```
Para sair da sessão Screen sem fecha-la pressione CTRL + A depois D.


#### 5.1. Compilando e iniciando a aplicação</br>
Para compilar a aplicação vamos usar o Maven, para isso execute:
```
$ cd api/app/ && mvn clean package
```
Depois inicialize a aplicação com o comando:
```
$ screen -S java-up -dm bash -c '~/api/app; sh start.sh'
```
Por fim teste o acesso via <a href="http:localhost:8080/topicos">browser</a>.