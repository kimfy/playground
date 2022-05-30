# Vagrant

This Vagrantfile deploys user specified amount of server and client nodes, configuration is handled by `ansible_local`. Great for testing Consul and Nomad.

**TODO**
- Let user specify which services to deploy 
  - Nomad
  - Consul
  - Vault
- Create a Vagrant box that has Ansible installed already, since installing Ansible for each node is time consuming.

**Tested on**
- Linux (Pop_OS 2204)
- Windows 11

**Requirements**

- Vagrant
- VirtualBox 

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

