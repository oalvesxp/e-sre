## Testando a conexão do Ansible com a VM
```
$ ansible -m ping -u vagrant --private-key ~/Documentos/media/labs/vms/ansible/.vagrant/machines/wordpress/virtualbox/private_key -i host all -e ansible_port="2222"
```


## Testando um módulo do Ansible na VM
```
$ ansible -m shell -a 'echo Hello world!' -u vagrant --private-key ~/Documentos/media/labs/vms/ansible/.vagrant/machines/wordpress/virtualbox/private_key -i host all -e ansible_port="2222"
```

## Criando o primeiro playbook
```
$  ansible-playbook playbook-hello-world.yml -u vagrant -i host --private-key ~/Documentos/media/labs/vms/ansible/.vagrant/machines/wordpress/virtualbox/private_key -e ansible_port="2222"
```

## Criando o playbook de configuração do Wordpress
```
$  ansible-playbook playbook-wordpress-startconfig.yml -u vagrant -i host --private-key ~/Documentos/media/labs/vms/ansible/.vagrant/machines/wordpress/virtualbox/private_key -e ansible_port="2222"
```