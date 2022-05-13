echo "[TASK 1] Download k3s and move to directory on PATH"
wget "https://github.com/k3s-io/k3s/releases/download/v1.23.6%2Bk3s1/k3s" > /dev/null 2>&1
chmod +x ./k3s > /dev/null 2>&1
mv ./k3s /usr/local/bin/ > /dev/null 2>&1

#k3s server & > /dev/null 2>&1

echo "[TASK 2] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.56.101   master1.k3s.lab.wwan.no     master1
192.168.56.121   worker1.k3s.lab.wwan.no     worker1
192.168.56.121   worker2.k3s.lab.wwan.no     worker2
10.0.100.117     host.vagrant.lab.wwan.no    host
EOF

echo "[TASK 3] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 4] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

