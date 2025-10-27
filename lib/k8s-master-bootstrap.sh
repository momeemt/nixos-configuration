#!/usr/bin/env bash
set -euo pipefail

API_IP=""
POD_CIDR="10.244.0.0/16"
USER_HOME="/home/ubuntu"
USER_NAME="ubuntu"
BOOTSTRAP_TOKEN=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --api-server-ip) API_IP="$2"; shift 2;;
    --pod-cidr) POD_CIDR="$2"; shift 2;;
    --bootstrap-token) BOOTSTRAP_TOKEN="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

if [[ -z "$API_IP" || -z "$BOOTSTRAP_TOKEN" ]]; then
  echo "[bootstrap] missing required args --apiserver-ip or --bootstrap-token" >&2
  exit 2
fi

echo "[bootstrap] apiserver-ip=${API_IP} pod-cidr=${POD_CIDR}"

systemctl enable --now systemd-timesyncd || true

# disable swap
swapoff -a || true
sed -i '/\sswap\s/s/^/#/' /etc/fstab || true

modprobe overlay || true
modprobe br_netfilter || true
cat >/etc/modules-load.d/k8s.conf <<'EOF'
overlay
br_netfilter
EOF

cat >/etc/sysctl.d/99-kubernetes.conf <<'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system || true

# setup containerd
apt-get update -y
apt-get install -y containerd apt-transport-https ca-certificates curl gpg
mkdir -p /etc/containerd
containerd config default >/etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl enable --now containerd

# setup Kubernetes tools
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /" \
  >/etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
systemctl enable --now kubelet
apt-mark hold kubelet kubeadm kubectl

if [[ -f /etc/kubernetes/admin.conf ]]; then
  echo "[bootstrap] already initialized, skipping kubeadm init"
else
  echo "[bootstrap] running kubeadm init..."
  kubeadm init \
    --apiserver-advertise-address="${API_IP}" \
    --pod-network-cidr="${POD_CIDR}" \
    --token "${BOOTSTRAP_TOKEN}" \
    --token-ttl 0 \
    --apiserver-cert-extra-sans="${API_IP},127.0.0.1,::1,$(hostname),$(hostname -f)"
fi

mkdir -p "${USER_HOME}/.kube"
cp -f /etc/kubernetes/admin.conf "${USER_HOME}/.kube/config"
chown -R ${USER_NAME}:${USER_NAME} "${USER_HOME}/.kube"

# CNI
su - ${USER_NAME} -c "kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml" || true

echo "[bootstrap] done."

