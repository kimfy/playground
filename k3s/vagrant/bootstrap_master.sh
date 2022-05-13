echo "[TASK 1] Create master node"
export K3S_NODE_NAME=$1
export K3S_EXTERNAL_IP=$2
k3s server \
  --tls-san $K3S_EXTERNAL_IP \
  --kube-apiserver-arg service-node-port-range=1-65000 \
  --kube-apiserver-arg advertise-address=$K3S_EXTERNAL_IP \
  --kube-apiserver-arg external-hostname=$K3S_EXTERNAL_IP \
  --cluster-cidr "10.8.0.0/16" \
  --service-cidr "10.9.0.0/16" \
  --cluster-domain "k3s.lab.wwan.no" \
  --flannel-backend "host-gw" \
  > /dev/null 2>&1 &

echo "[TASK 2] Sleeping until kubeconfig exists. Echoing it out when done"
while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do sleep 1; done
cat /etc/rancher/k3s/k3s.yaml
