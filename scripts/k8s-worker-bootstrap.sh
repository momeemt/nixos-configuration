#!/usr/bin/env bash
set -euo pipefail

systemctl enable --now systemd-timesyncd

# disable swap
swapoff -a
sed -i '/\sswap\s/s/^/#/' /etc/fstab

modprobe overlay
modprobe br_netfilter
cat >/etc/modules-load.d/k8s.conf <<'EOF'
overlay
br_netfilter
EOF

cat >/etc/sysctl.d/99-kubernetes.conf <<'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# install tools
apt-get update -y
apt-get install -y \
  containerd \
  apt-transport-https \
  ca-certificates \
  curl \
  gpg \
  yq \
  moreutils

# setup containerd
systemctl stop containerd || true
mkdir -p /etc/containerd
containerd config default >/etc/containerd/config.toml

sudo tomlq -t \
  '.plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options.SystemdCgroup = true' \
  /etc/containerd/config.toml | sudo sponge /etc/containerd/config.toml

sudo tomlq -t \
  '.plugins."io.containerd.grpc.v1.cri".sandbox_image = "registry.k8s.io/pause:3.10.1"' \
  /etc/containerd/config.toml | sudo sponge /etc/containerd/config.toml

mkdir -p /etc/systemd/system/containerd.service.d
cat >/etc/systemd/system/containerd.service.d/10-config.conf <<'EOF'
[Service]
ExecStart=
ExecStart=/usr/bin/containerd --config /etc/containerd/config.toml
EOF
systemctl daemon-reload
systemctl enable containerd
systemctl restart containerd

# crictl endpoint
cat >/etc/crictl.yaml << 'EOF'
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF

# setup Kubernetes tools
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key |
  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /" \
  >/etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
systemctl enable --now kubelet
apt-mark hold kubelet kubeadm kubectl

