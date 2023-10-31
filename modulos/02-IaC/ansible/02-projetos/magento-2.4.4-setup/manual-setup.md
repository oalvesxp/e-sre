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