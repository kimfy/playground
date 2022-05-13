echo "[TASK 1] Get NODE_TOKEN from master node"
apt install -qq -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master1.k3s.lab.wwan.no:/var/lib/rancher/k3s/server/node-token ./node-token 2>/dev/null
export NODE_TOKEN=$(cat ./node-token) > /dev/null 2>&1
echo $NODE_TOKEN

echo "[TASK 2] Join node to k3s cluster"
export K3S_NODE_NAME=$1
k3s agent \
  --server https://$3:6443 \
  --token ${NODE_TOKEN} \
  --flannel-backend "host-gw" \
  > /dev/null 2>&1 &
