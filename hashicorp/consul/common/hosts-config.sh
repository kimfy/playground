#/bin/bash
# Run this file either in cloud init or sometime later
CONSUL_IP=10.0.0.230
sudo echo "$CONSUL_IP consul.lab.wwan.no consul" >> /etc/hosts
