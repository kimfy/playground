FQDN=$1
IP_ADDRESS=$2
FIRST_CONSUL_SERVER_IP=$3
CONSUL_INTERNAL_DOMAIN=$4
BOOTSTRAP_EXPECT=$5

header = "**********"
echo "$header START: Consul $header"
echo "[TASK 1] Configure Consul (server)"
cat << EOF > /etc/consul.d/server.hcl
# server
# This flag is used to control if an agent is in server or client mode. When provided,
# an agent will act as a Consul server. Each Consul cluster must have at least one
# server and ideally no more than 5 per datacenter. All servers participate in the Raft
# consensus algorithm to ensure that transactions occur in a consistent, linearizable
# manner. Transactions modify cluster state, which is maintained on all server nodes to
# ensure availability in the case of node failure. Server nodes also participate in a
# WAN gossip pool with server nodes in other datacenters. Servers act as gateways to
# other datacenters and forward traffic as appropriate.
server = true

# Bind addr
# You may use IPv4 or IPv6 but if you have multiple interfaces you must be explicit.
#bind_addr = "[::]" # Listen on all IPv6
#bind_addr = "0.0.0.0" # Listen on all IPv4
bind_addr = "$IP_ADDRESS" # Bind to IP address given in Vagrantfile

# Advertise addr - if you want to point clients to a different address than bind or LB.
#advertise_addr = "0.0.0.0"

# bootstrap_expect
# This flag provides the number of expected servers in the datacenter. Either this value
# should not be provided or the value must agree with other servers in the cluster. When
# provided, Consul waits until the specified number of servers are available and then
# bootstraps the cluster. This allows an initial leader to be elected automatically.
# This cannot be used in conjunction with the legacy -bootstrap flag. This flag requires
# -server mode.
bootstrap_expect=$BOOTSTRAP_EXPECT

# retry_join
# Similar to -join but allows retrying a join until it is successful. Once it joins 
# successfully to a member in a list of members it will never attempt to join again.
# Agents will then solely maintain their membership via gossip. This is useful for
# cases where you know the address will eventually be available. This option can be
# specified multiple times to specify multiple agents to join. The value can contain
# IPv4, IPv6, or DNS addresses. In Consul 1.1.0 and later this can be set to a go-sockaddr
# template. If Consul is running on the non-default Serf LAN port, this must be specified
# as well. IPv6 must use the "bracketed" syntax. If multiple values are given, they are
# tried and retried in the order listed until the first succeeds. Here are some examples:
#retry_join = ["consul.domain.internal"]
#retry_join = ["10.0.4.67"]
#retry_join = ["[::1]:8301"]
#retry_join = ["consul.domain.internal", "10.0.4.67"]
# Cloud Auto-join examples:
# More details - https://www.consul.io/docs/agent/cloud-auto-join
#retry_join = ["provider=aws tag_key=... tag_value=..."]
#retry_join = ["provider=azure tag_name=... tag_value=... tenant_id=... client_id=... subscription_id=... secret_access_key=..."]
#retry_join = ["provider=gce project_name=... tag_value=..."]
retry_join = ["$CONSUL_INTERNAL_DOMAIN"]
EOF

echo "[TASK 2] Start Consul server"
systemctl enable consul
systemctl start consul


# ***************************
# Make Consul available by name
# ***************************
# example: 
# 192.168.56.101  consul.hashicorp.lab.wwan.no  consul
echo "$FIRST_CONSUL_SERVER_IP $CONSUL_INTERNAL_DOMAIN consul" >> /etc/hosts

echo "$header END: Consul $header"

echo "$header START: Nomad $header"
echo "[TASK 1] Configure Nomad"
# Delete all defaults
rm /etc/nomad.d/*.hcl > /dev/null 2&>1

# Insert config
cat << EOF > /etc/nomad.d/server.hcl
data_dir  = "/opt/nomad"
bind_addr = "$IP_ADDRESS" 

advertise {
  # Defaults to the first private IP address.
  http = "$IP_ADDRESS"
  rpc  = "$IP_ADDRESS"
  serf = "$IP_ADDRESS:5648" # non-default ports may be specified
}

server {
  enabled = true
  bootstrap_expect = $BOOTSTRAP_EXPECT
}

client {
  enabled = false
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

consul {
  address = "$CONSUL_INTERNAL_DOMAIN:8500"
}

ui {
  enabled =  true
}
EOF

echo "[TASK 2] Start Nomad service"
systemctl enable nomad
systemctl start nomad
