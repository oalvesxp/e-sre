## Instalando e configurando o Magento 2.4.4

Magento é uma popular plataforma de e-Commerce de código aberto escrita em PHP. A plataforma é compátivel com os sistemas Linux, como Ubuntu ou Debian.
Neste processo vou descrever como instalar e configurar o Magento 2 no S.O. Ubuntu 20.04, focando em sua versão 2.4. Com isso será possível acessar o painel administrativo do Magento no seu localhost.

### Pré-requisitos:

* Ubuntu 20.04
* Acesso aos privilégios Sudo ou ao usuário root

### 1.  Validando os pré-requisitos

Faça login no host com o protocolo SSH com o usuário root (ou um usuário com privilégios SUDO):
```
$ ssh ubuntu@172.16.177.40
```
**OBS:** Se for aplicar o processo no seu sistema local, ignore este passo.

Verifique se a versão do seus sistema é adequada:
```
$ lsb_release -a
```

O output deve ser assim:
```
No LSB modules are available.
Distributor ID: Ubuntu
Description: Ubuntu 20.04.3 LTS
Release: 20.04
Codename: focal
```

Certifique-se que os pacotes instalados estão atualizados em sua versão mais recente. Execute o comando seguinte:
```
$ sudo apt update && sudo apt upgrade -y
```

### 2. Instale o PHP 8.1

Por padrão, o PHP 8.1 não está disponível na biblioteca do Ubuntu 20.04. Use o comando abaixo para adicionar um repositório para ele:
```
$ sudo apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php -y
$ sudo apt update
```

O Magento 2.4.4 é totalmente compatível com o PHP 8.1.
Agora execute o comando abaixo para instalar o PHP e todos os módulos necessários:
```
$ sudo apt install php8.1-{bcmath,common,curl,fpm,gd,intl,mbstring,mysql,xml,xsl,zip,cli}
```

Agora pode aumentar os valores de algumas variáveis do PHP para atender os requisitos mínimos do Magento 2.4.4:
```
$ sudo sed -i "s/memory_limit = .*/memory_limit = 768M/" /etc/php/8.1/fpm/php.ini
$ sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 128M/" /etc/php/8.1/fpm/php.ini
$ sudo sed -i "s/zlib.output_compression = .*/zlib.output_compression = on/" /etc/php/8.1/fpm/php.ini
$ sudo sed -i "s/max_execution_time = .*/max_execution_time = 18000/" /etc/php/8.1/fpm/php.ini
```

### 3. Instale o servidor web

Estamos usuando o servidor web Nginx para este tutorial:
```
$ sudo apt install nginx
```

Crie um bloco no servidor Nginx para o nosso site:
```
$ vim /etc/nginx/sites-enabled/magento.conf
```

Insira as seguintes configurações no arquivo:
```
server{
    servername <your-domain>;
    listen 80;
    set $MAGE_ROOT /var/www/magento2;
    set $MAGE_MODE developer; # or production

    access_log /var/log/nginx/magento2-access.log;
    error_log /var/log/nginx/magento2-error.log;

    include /var/www/magento2/nginx.conf.sample;
}

upstream fastcgi_backend {
    server unix:/run/php/php8.1-fpm.sock;
}
```

### 4. Instale o servidor de banco de dados

Neste tutorial estamos usando o MariaDB mais recente:
```
$ sudo apt install mariadb-server
```

Após a instalação use o comando abaixo para criar uma senha para o usuário root do banco de dados e tornar seu projeto mais seguro:
```
$ mysql_secure_installation
```

Ao definir uma senha, use o comando a seguir para realizar o login no mysql:
```
$ mysql -u root -p
```

Crie um banco de dados para o nosso site e um usuário com todos os privilégios para acessa-lo. Use os comandos a seguir:
```
mysql> CREATE DATABASE magentodb;
mysql> GRANT ALL PRIVILEGES ON magentodb.* TO 'magento'@'%' IDENTIFIED BY 'm0d1f1257';
mysql> FLUSH PRIVILEGES;
mysql> \q
```