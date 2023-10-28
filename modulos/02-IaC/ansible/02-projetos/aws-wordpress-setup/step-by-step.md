## Step by Step do Projeto

Este arquivo é destinado a documentar cada passo realizado em sua ordem.

### 1. Criação do inventory (hosts):

Crie o arquivo que for utilizar apenas, neste caso fiz um para a AWS e outro para o Vagrant. a configuração consiste em:

* Criar um grupo de hosts.
* Anexar o IP do host + usuário + chave ssh.

Voce pode optar por criar uma chave publica e anexa-la diretamente ao servidor para deixar o seu inventory mais limpo.

### 2. Criar o diretório para as roles:

Antes vamos entender o que é cada diretório:
```
roles/
    common/               # essa hierárquia representa uma "role"
        tasks/            #
            main.yml      #  <-- arquivos de "tasks¨ servem para dividir o código em arquivos menores
        handlers/         #
            main.yml      #  <-- arquivos de "handlers" são para colocar ações sobe uma aplicação (ex: restart do apache)
        templates/        #  <-- para colocar arquivos de templates
            ntp.conf.j2   #  <------- todos os templates terminam com a extensão .j2
        files/            #
            bar.txt       #  <-- arquivos para cópia no servidor (ex: certSSL)
            foo.sh        #  <-- scripts para usar como recurso adicional
        vars/             #
            main.yml      #  <-- variáveis associadas a esta role
        defaults/         #
            main.yml      #  <-- variáveis "default" de baixa prioridade
        meta/             #
            main.yml      #  <-- dependencias da role e informações adicionais do Galaxy
        library/          # inclui os módulos personalizados das roles
        module_utils/     # inclui os module_utils personalizados das roles
        lookup_plugins/   # outros plugins, como "loockup" nesse caso

webtier/              # mesma hierárquia de "commom", só que para webtier
monitoring/           # ""
fooapp/               # ""
```

### 2.1 Gerando a role para o MySQL

Por padrão, o Ansible assume que seus playbooks estão armazenados em um diretório com funções armazenadas em um subdiretório chamado roles/.
Você pode criar tudo na mão, ou... usar o comando:
```
$ ansible-galaxy init <name>
```

Exemplo (lembrando que esse comando deve ser executado dentro do diretório → roles/):
```
$ ansible-galaxy init mysql
- Role mysql was created successfully
```

Agora configure os arquivos de defaults:
```
$ vim roles/mysql/defaults/main.yml

wp_mysql_db: wordpress      # Variável para o nome do banco
wp_mysql_user: wpuser       # Variável para o nome do usuário
wp_mysql_passwd: abcd1234   # Variável para a senha (não recomendado fazer assim em produção)
wp_mysql_host: 127.0.0.1    # variável para o ip do host do banco
```

Configure o arquivo de tasks para determinar o que será executado pos esta role do mysql.
Nosso objetivo é criar um banco de dados e depois um usuário com todos os privilégios apenas no banco de dados que criamos:
```
$ vim roles/mysql/tasks/main.yml

# Task para criar o banco de dados
- name: Create mysql database
  mysql_db: name={{ wp_mysql_db }} state=present
  become: yes

# Task para criar o usuário com os privilégios
- name: Create mysql user
  mysql_user:
    name={{ wp_mysql_user }}
    password={{ wp_mysql_passwd }}
    priv={{ wp_mysql_db}}.*:ALL
  become: yes
```

### 2.2 Gerando a role para o PHP

Use o mesmo comando do ansible-galaxy para gerar todos os diretórios e arquivos de base.
Agora configure o arquivo de tasks para instalar algumas dependências (php7-gd e php-ssh2):
```
$ vim roles/php/tasks/main.yml

- name: Install php exetensions
  apt: name={{ item }} state=present
  become: yes
  with_items:
    - php7-gd
    - php-ssh2
```

### 2.3 Gerando a role para o Server

Repita o processo do ansible-galaxy
Nesta etapa será necessário configurar 2 tasks para o Server.

* Update do cache do sistema (apt)
* Instalação de alguns softwares

Configure o arquivo de tasks da seguinte maneira:
```
$ vim roles/server/tasks/main.yml

# Task para atualizar o cache do sistema
- name: Update apt cache
  apt: update_cache=yes cache_valid_time=3600
  become: yes

# Task para instalar os softwares necessários
- name: Install required softwares
  apt: name={{ item }} state=present
  become: yes
  with_items:
    - apache2
    - mariadb-sever-10.3
    - php7.3-mysql
    - php7.3
    - libapache2-mod-php7.3
    - python3-mysqldb
```

### 2.3 Gerando a role para o WordPress

Use o Galaxy para gerar os arquivos e diretórios base.
Nesta etapa precisamos configurar mais tasks:

* Download do Wordpress
* Extração dos arquivos do WordPress
* Atualizar o vhost com o root_dir do site
* Copiar o arquivo de wp-config.php
* Atualizar o arquivo para o WordPress se conectar com o banco de dados.
* Reiniciar o apache2

Vamos criar uma váriavel de baixa prioridade para o diretório root do site:
```
$ vim roles/wordpress/defaults/main.yml

website_root: /var/www/wordpress
```

Agora vamos adicionar as configurações desejadas no arquivo de tasks:
```
$ vim roles/wordpress/tasks/main.yml

# Task para baixar a ultima versão do WordPress
- name: Download WordPress
  get_url:
    url=https://wordpress.org/latest.tar.gz
    dest=/tmp/latest.tar.gz
    validate_certs=no

# Task para extrair os arquivos do wordpress
- name: Extract WordPress
  unarchive:
    src=/tmp/latest.tar.gz
    dest=/var/www/
    copy=no
  become: yes

# Task para atualizar o vHost do Apache2 e aplicar o restart
- name: Update default Apache site
  lineinfile:
    dest=/etc/apache2/sites-enabled/000-default.conf
    regexp="(.)+DocumentRoot /var/www/html"
    line="DocumentRoot {{ website_root }}" 
  become: yes
  notify:
    - restart apache

# Task para copiar o arquivo de wp-config.php
- name: Copy sample config file
  command: mv {{ website_root}}/wp-config-sample.php {{ website_root }}/wp-config.php creates={{ website_root }}/wp-config.php
  become: yes

# Task para atualizar o wp-config.php
- name: Update WordPress config file
  ansible.builtin.replace:
    dest={{ website_root }}/wp-config.php
    regexp="{{ item.regex }}"
    replace="{{ item.value }}"
  with_items:
    - { regex: 'database_name_here', value: "{{ wp_mysql_db }}" }
    - { regex: 'username_here', value: "{{ wp_mysql_user }}" }
    - { regex: 'password_here', value: "{{ wp_mysql_passwd }}" }
  become: yes
```

Para encerrar as configurações do wordpress crie o handlers para reiniciar o apache:
```
# vim roles/worpress/handlers/main.yml

# Handlers para reiniciar o apache2
- name: restart apache
  service: name=apache2 state=restarted
  become: yes
```