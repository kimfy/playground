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
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "[TASK 3] Installing kubectl"
apt update > /dev/null 2>&1 &
apt install -y apt-transport-https ca-certificates curl > /dev/null 2>&1 &
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg > /dev/null 2>&1 &
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null 2>&1 &
apt update > /dev/null 2>&1 &
apt install -y kubectl > /dev/null 2>&1 &

# Loaned from: https://github.com/rgl/k3s-vagrant/blob/master/provision-k3s-server.sh
# wait for this node to be Ready.
# e.g. s1     Ready    control-plane,master   3m    v1.22.4+k3s1
echo "[TASK 4] Waiting for node to be ready"
echo "waiting for node $1 to be ready..."; while [ -z "$(k3s kubectl get nodes $1 | grep -E "$1\s+Ready\s+")" ]; do sleep 3; done; echo "node ready!"

# wait for the kube-dns pod to be Running.
# e.g. coredns-fb8b8dccf-rh4fg   1/1     Running   0          33m
echo "[TASK 5] Waiting for kube-dns to be running"
echo "Wait for the kube-dns pod to be Running"
while [ -z "$(k3s kubectl get pods --selector k8s-app=kube-dns --namespace kube-system | grep -E "\s+Running\s+")" ]; do sleep 3; done
echo "kube-dns is running"
