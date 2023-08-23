# Observabilidade
Coletando métricas de uma aplicação com Prometheus

## Tópicos das aulas</br>
Cada tópico terá um arquivo como os passos para execução das modificações e suas evidências.

* **Aula01/** - Tornando uma aplicação observável
* **Aula02/** - Exemplo

## Softwares e versões

Para preservar meu sistema e minha máquina eu criei um ambiente com Vagrant usando o Virtualbox como Hypervisor.</br>
Haverá outro arquivo chamado "**env-config.md**" com os passos para configuração do mesmo ambiente.

01. Versão do sistem operacional
```
$ hostnamectl | grep -i "operating system"
Operating System: Debian GNU/Linux 12 (bookworm)
```

02. Vagrant version
```
$ vagrant --version
Vagrant 2.3.7
```

03. Vagrant boxes used
```
alvistack/debian-12
```

04. Virtualbox version
```
$ vboxmanage --version
6.1.46r158378
```

05. Docker version
```
$ docker --version
Docker version 24.0.5, build ced0996
```

06. Docker Compose version
```
$ docker compose version
Docker Compose version v2.20.2
```

07. Java version
```
$ java --version
openjdk 17.0.8 2023-07-18
OpenJDK Runtime Environment (build 17.0.8+7-Debian-1deb12u1)
OpenJDK 64-Bit Server VM (build 17.0.8+7-Debian-1deb12u1, mixed mode, sharing)
```

08. Maven version
```
$ mvn --version
Apache Maven 3.9.4 (dfbb324ad4a7c8fb0bf182e6d91b0ae20e3d2dd9)
Maven home: /usr/share/maven
Java version: 17.0.8, vendor: Debian, runtime: /usr/lib/jvm/java-17-openjdk-amd64
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "6.1.0-11-amd64", arch: "amd64", family: "unix"
```

