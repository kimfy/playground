# Deploy k3s on Vagrant provisioned VMs

**On the host machine**
Usage: 
```sh
# Start
vagrant up

# Stop
vagrant down

# Force reprovision
vagrant reload --provision

# SSH into master/workers
vagrant ssh master1/worker1

# Route traffic to the Klipper Load Balancer (any master node)
sudo ip route add 10.0.2.0/24 via 192.168.56.101

# Add DNS entry to Traefik on the cluster
sudo echo "10.0.2.15 traefik.k3s.lab.wwan.no" >> /etc/hosts

```

## Reaching services hosted on k3s

Create `IngressRoute` to services. See any \*-ingressroute.yaml for examples.

