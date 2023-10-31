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

### 3. Instale o servidor web (Nginx)

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

### 4. Instale o servidor de banco de dados (mariaDB)

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

### 5. Instale o Elasticsearch

O Magento 2.4.x deve ser configurado para usar o Elasticsearch como soluçãoi de pesquisa de catálogo.
Primeiro instale as dependencias necessárias:
```
$ sudo apt install apt-transport-https ca-certificates gnupg2 -y
```

Importe a chage GPG usando o seguinte comando:
```
$ wget -q0 https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

Execute o comando abaixo para adicionar o repositório do Elasticsearch:
```
$ sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
```

Por fim instale o Elasticsearch:
```
$ sudo apt update && sudo apt install elasticsearch -y
```

Agora que ele foi instalado, você deve ativar o serviço com o seguinte comando:
```
$ sudo systemctl --now enable elasticsearch
```

Para verificar se o Elasticsearch está realmente funcionando, execute:
```
$ curl -X GET "localhost:9200"
```

O output deve ser assim:
```
{
"name" : "ubuntu20",
"cluster_name" : "elasticsearch",
"cluster_uuid" : "FKnwn1-fSYm54T3dv7a6UQ",
"version" : {
"number" : "7.15.0",
"build_flavor" : "default",
"build_type" : "deb",
"build_hash" : "79d65f6e357953a5b3cbcc5e2c7c21073d89aa29",
"build_date" : "2021-09-16T03:05:29.143308416Z",
"build_snapshot" : false,
"lucene_version" : "8.9.0",
"minimum_wire_compatibility_version" : "6.8.0",
"minimum_index_compatibility_version" : "6.0.0-beta1"
},
"tagline" : "You Know, for Search"
}
```

### 6. Instale o Composer

Use os comandos abaixo para instalar os Composer:
```
$ curl -sS https://getcomposer.org/installer -o composer-setup.php
$ sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
```

Você instalou o Composer com sucesso no sistema, e está diponivel para uso global, pois armazenamos no /usr/local/bin/.
Verifique a versão do Composer com este comando:
```
$ composer -V
```

### 7. Baixe o Magento

Vamos instalar o Magento 2.4.4 usando o Composer. Você precisará de uma chave de acesso para a próxima etapa.
Crie uma conta no https://magento.com e acesse o https://commercemarketplace.adobe.com/customer/accessKeys/ e crie uma chave de acesso.
Depois de ter a chave de acesso, execute o comando em sua sessão SSH (ou no seu sistema local, se for o caso):
```
$ composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.4 /var/www/magento2
```
Ao ser solicitado usuário e senha digite as chaves conforme abaixo:
```
username > Chave Pública
password > Chave Privada
```

Você não a string da senha. Basta coloca-la e o Composer iniciará o download do Magento 2.
Após a conclusão do download, acesse o diretório do site com o comando abaixo:
```
$ cd /var/www/magento2
```

Você pode editar o domínio, endereço de e-mail e senha do adiministrador. Use o seguinte commando:
```
$ bin/magento setup:install \
    --base-url=http://<your-domain> \
    --db-host=localhost \
    --db-name=magentodb \
    --db-user=magento \
    --db-password=m0d1f1257 \
    --admin-firstname=admin \
    --admin-lastname=admin \
    --admin-email=admin@admin.com \
    --admin-password=admin@123 \
    --language=pt_BR \
    --currency=BRL \
    --timezone=SouthAmerica/Brazil \
    --use-rewrites=1
```

Após a conclusão você receberá a seguinte mensagem no outpu:
```
[SUCCESS]: Magento installation complete.
[SUCCESS]: Magento Admin URI: /admin_1iwnbd
```

Corrija as permissões do diretório do site:
```
$ sudo chown -R www-data: /var/www/magento2
```

Por padrão o 2MFA do magento está habilitada. Para desabilitar, execute:
```
$ sudo -u www-data bin/magento module:disable Magento_TwoFactorAuth
$ sudo -u www-data bin/magento cache:flush
```

### 8. Configurar os Crons

O Magento usa cronjobs para automatizar funções importantes do sistema.
Crie os Cronjobs com o seguinte comando:
```
$ sudo -u www-data bin/magento cron:install
```