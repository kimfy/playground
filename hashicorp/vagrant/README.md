# Vagrant

This Vagrantfile uses Ansible to configure the created nodes. You can configure the amount of server and client nodes using the variables available in the Vagrantfile. 

**Requirements**

- Vagrant
- VirtualBox 
- Ansible

**How to**

```shell
vagrant up

# ssh into the machines
vagrant ssh <machineName>

# destroy
vagrant destroy -f
```

**Notes** 

You may need to create a static route to the VirtualBox generated network to reach the inside of the network. I am unsure how routing is handled by the default network used.

