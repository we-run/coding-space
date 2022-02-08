#!/bin/bash

systemctl stop firewalld && systemctl disable firewalld
# yum install ntp -y
# systemctl enable ntpd && systemctl start ntpd

### ----
cat <<EOF > /etc/hosts
192.168.0.101 head1.daqiang.me
192.168.0.111 node1.daqiang.me
192.168.0.112 node11.daqiang.me
EOF



### ----
# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
# yum --enablerepo=elrepo-kernel install kernel-ml-devel kernel-ml -y
# cat /boot/grub2/grub.cfg | grep menuentry
# grub2-set-default "CentOS Linux (5.4.6-1.el7.elrepo.x86_64) 7 (Core)"
# # 验证
# grub2-editenv list


### ----
update-alternatives --set iptables /usr/sbin/iptables-legacy



### ----
# sudo yum install -y yum-utils device-mapper-persistent-data lvm2 && \
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
# sudo yum install docker-ce docker-ce-cli containerd.io -y && \
# sudo systemctl enable docker \
# sudo systemctl start docker


### ----
# Create /etc/docker directory.
mkdir -p /etc/docker
# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2",
    "storage-opts": [
        "overlay2.override_kernel_check=true"
    ]
}
EOF

ls -al /etc/docker/
cat /etc/docker/daemon.json
mkdir -p /etc/systemd/system/docker.service.d

# Restart Docker
systemctl daemon-reload
systemctl restart docker



### ----
# swapoff -a
# free -h
# sed -i "s/\/swap/#^.+$/" /etc/fstab
cat /etc/fstab


### ----
chmod -R a+x ~/littleTools/bin

### kubeadmin
~/littleTools/bin/azk8spull k8s.gcr.io/kube-apiserver:v1.17.0
~/littleTools/bin/azk8spull k8s.gcr.io/kube-controller-manager:v1.17.0
~/littleTools/bin/azk8spull k8s.gcr.io/kube-scheduler:v1.17.0
~/littleTools/bin/azk8spull k8s.gcr.io/etcd:3.4.3-0

##### nodes && heads
~/littleTools/bin/azk8spull k8s.gcr.io/kube-proxy:v1.17.0
~/littleTools/bin/azk8spull k8s.gcr.io/coredns:1.6.5
~/littleTools/bin/azk8spull k8s.gcr.io/pause:3.1

# k8s.gcr.io/kube-proxy                                    v1.17.0             7d54289267dc        5 weeks ago         116MB
# k8s.gcr.io/kube-apiserver                                v1.17.0             0cae8d5cc64c        5 weeks ago         171MB
# k8s.gcr.io/kube-controller-manager                       v1.17.0             5eb3b7486872        5 weeks ago         161MB
# k8s.gcr.io/kube-scheduler                                v1.17.0             78c190f736b1        5 weeks ago         94.4MB
# k8s.gcr.io/coredns                                       1.6.5               70f311871ae1        2 months ago        41.6MB
# k8s.gcr.io/etcd                                          3.4.3-0             303ce5db0e90        2 months ago        288MB
# k8s.gcr.io/pause                                         3.1                 da86e6ba6ca1        2 years ago         742kB

# weaveworks/weave-npc                                     2.6.0               5105e13e253e        2 months ago        34.9MB
# weaveworks/weave-kube                                    2.6.0               174e0e8ef23d        2 months ago        114MB

### ----
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config



### ----
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet


### 网络插件
# https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#pod-network
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


### ----
reboot