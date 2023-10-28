### Step by Step do Projeto

Este arquivo é destinado a documentar cada passo realizado em sua ordem.

1.  Criação do inventory (hosts):

    Crie o arquivo que for utilizar apenas, neste caso fiz um para a AWS e outro para o Vagrant. a configuração consiste em:

    * Criar um grupo de hosts.
    * Anexar o IP do host + usuário + chave ssh.

    Voce pode optar por criar uma chave publica e anexa-la diretamente ao servidor para deixar o seu inventory mais limpo.

2. Criar o diretório para as roles:

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