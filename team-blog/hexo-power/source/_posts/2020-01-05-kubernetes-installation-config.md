---
title: Kubernetes 安装与配置
tags:
  - k8s
  - mircoservice
date: 2020-01-05 13:10:15
categories:
  - [DevOps, Kubernetes]
---

{% asset_img banner-image banner.jpeg 550rem 370rem "k8s-image'banner'" %}
### 知识背景
1. 对虚拟化的了解
  从2017年接触Docker，对虚拟化、容器化的了解，愈来愈广泛，原来所有的硬件设施的能力，均可以被虚拟化，包括：`NVF(Network Functions Virtualization)`、`SDN(Software Defined Network)`，到对操作系统以及运行操作系统的硬件能力进行虚拟化的技术，包括：`KVM架构(QEMU)`、`Xen架构`、`ESXi架构`
2. 对虚拟化的管理
<!-- more -->


### 环境准备

1. 三台主机 
192.168.0.101 head1.daqiang.me
192.168.0.111 node1.daqiang.me
192.168.0.112 node11.daqiang.me

2. 主机配置


- Common
  + 远程批量配置
    ```shell
    # 192.168.0.99 本机
    hosts=\
    (
      # home-host
      # "192.168.0.100"
      # head-1
      "192.168.0.101"
      # head-2
      # "192.168.0.102"

      # node-1
      "192.168.0.111"
      # node-2
      "192.168.0.112"
    )

    # scp $1 
    # get length for array : ${#hosts[@]}
    for host in ${hosts[@]}
    do
      ssh root@$host 'rm -f /root/kubeadmin.sh'
      scp ./kubeadmin.sh root@$host:"~"
      ssh root@$host 'bash /root/kubeadmin.sh'
    done
    ```
  + 关闭防火墙
    ```shell
    systemctl stop firewalld && systemctl disable firewalld
    ```
  + 配置地址解析
    ```shell
    cat <<EOF > /etc/hosts
    192.168.0.101 head1.daqiang.me
    192.168.0.111 node1.daqiang.me
    192.168.0.112 node11.daqiang.me
    EOF
    ```
  + 升级内核至 4.10 以上
    ```shell
    rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    yum --enablerepo=elrepo-kernel install kernel-ml-devel kernel-ml -y
    cat /boot/grub2/grub.cfg | grep menuentry
    grub2-set-default "CentOS Linux (5.4.6-1.el7.elrepo.x86_64) 7 (Core)"
    # 验证
    grub2-editenv list
    ```
  + 切换nft到iptables
    ```shell
    update-alternatives --set iptables /usr/sbin/iptables-legacy
    ```
  + 安装Docker,配置Docker
    ```shell
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2 && \
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    sudo yum install docker-ce docker-ce-cli containerd.io -y && \
    sudo systemctl enable docker \
    sudo systemctl start docker
    ```
    ```shell
    # Create /etc/docker directory.
    mkdir /etc/docker
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
    ```
  + 关闭交换分区
    ```shell
    swapoff -a
    free -h
    sed -i "s/\/swap/#^.+$/" /etc/fstab
    ```
  + 修改内核参数
    ```shell
    cat <<EOF > /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    sysctl --system
    ```
  + 修改SELinux
    ```shell
    setenforce 0
    sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
    ```
  + 安装Google国内镜像拉取方式
    ```shell
    scp -r ./littleTools root@$host:"~"
    chmod -R a+x ~/littleTools/bin
    bash ~/kubeadmin.sh
    
    ### kubeadmin.sh
    ~/littleTools/bin/azk8spull k8s.gcr.io/kube-apiserver:v1.17.0
    ~/littleTools/bin/azk8spull k8s.gcr.io/kube-controller-manager:v1.17.0
    ~/littleTools/bin/azk8spull k8s.gcr.io/kube-scheduler:v1.17.0
    ~/littleTools/bin/azk8spull k8s.gcr.io/etcd:3.4.3-0

    ##### nodes && heads
    ~/littleTools/bin/azk8spull k8s.gcr.io/kube-proxy:v1.17.0
    ~/littleTools/bin/azk8spull k8s.gcr.io/coredns:1.6.5
    ~/littleTools/bin/azk8spull k8s.gcr.io/pause:3.1
    ```
  + 安装kubeadm
    ```shell
    # 1. 增加yum repo
    # cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    # [kubernetes]
    # name=Kubernetes
    # baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
    # enabled=1
    # gpgcheck=1
    # repo_gpgcheck=1
    # gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
    # EOF

    cat <<EOF > /etc/yum.repos.d/kubernetes.repo
    [kubernetes]
    name=Kubernetes
    baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
    enabled=1
    gpgcheck=1
    repo_gpgcheck=1
    gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
    EOF
    ```
    ```shell
    yum install -y kubelet kubeadm kubectl kubernetes-cni #--disableexcludes=kubernetes
    systemctl enable --now kubelet

    systemctl daemon-reload
    systemctl restart kubelet
    ```
  + 网络插件 [官方文档>>](https://kubernetes.io/docs/concepts/cluster-administration/addons/)
    ```shell
    ```

  + 初始化集群
  ```shell
    kubeadm init --apiserver-advertise-address 192.168.0.101 --apiserver-bind-port 6443 --node-name head1.daqiang.me --pod-network-cidr 172.16.0.0/16 --service-dns-domain daqiang.me
  ```

  + reboot

- Master
1. 安装插件
  ```shell

  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  ```

  `kubectl get cs,node` 验证网络插件安装成功，即Status的状态变为Ready

2. 安装Dashboard [官方文档>>](https://github.com/kubernetes/dashboard)

```shell
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

$ kubectl proxy
# dashboard 配置方式和过程
$ kubectl proxy --address='192.168.0.101' --port=8011 --accept-hosts '.*'
# 获取dashboard 登录token
$ kubectl -n kubernetes-dashboard get secret
$ kubectl -n kubernetes-dashboard describe secrets kubernetes-dashboard-token-shprj
```

`http://192.168.0.101:8011/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`


##### 以下待求证？
`kubectl apply -f dashboard-adminuser.yaml`

```yaml  dashboard-adminuser.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```

`kubectl apply -f cluster-role.yaml`

```yaml  cluster-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

```shell
$ kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

`kubectl delete -f `
- Node



admin-dashboard.yaml 文件
```yaml
# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

apiVersion: v1
kind: Namespace
metadata:
  name: kubernetes-dashboard

---

apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard

---

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  ports:
    - port: 443
      targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-certs
  namespace: kubernetes-dashboard
type: Opaque

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-csrf
  namespace: kubernetes-dashboard
type: Opaque
data:
  csrf: ""

---

apiVersion: v1
kind: Secret
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-key-holder
  namespace: kubernetes-dashboard
type: Opaque

---

kind: ConfigMap
apiVersion: v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard-settings
  namespace: kubernetes-dashboard

---

kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
rules:
  # Allow Dashboard to get, update and delete Dashboard exclusive secrets.
  - apiGroups: [""]
    resources: ["secrets"]
    resourceNames: ["kubernetes-dashboard-key-holder", "kubernetes-dashboard-certs", "kubernetes-dashboard-csrf"]
    verbs: ["get", "update", "delete"]
    # Allow Dashboard to get and update 'kubernetes-dashboard-settings' config map.
  - apiGroups: [""]
    resources: ["configmaps"]
    resourceNames: ["kubernetes-dashboard-settings"]
    verbs: ["get", "update"]
    # Allow Dashboard to get metrics.
  - apiGroups: [""]
    resources: ["services"]
    resourceNames: ["heapster", "dashboard-metrics-scraper"]
    verbs: ["proxy"]
  - apiGroups: [""]
    resources: ["services/proxy"]
    resourceNames: ["heapster", "http:heapster:", "https:heapster:", "dashboard-metrics-scraper", "http:dashboard-metrics-scraper"]
    verbs: ["get"]

---

kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
rules:
  # Allow Metrics Scraper to get metrics from the Metrics server
  - apiGroups: ["metrics.k8s.io"]
    resources: ["pods", "nodes"]
    verbs: ["get", "list", "watch"]

---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: kubernetes-dashboard
subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kubernetes-dashboard

---

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kubernetes-dashboard
subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kubernetes-dashboard

---

kind: Deployment
apiVersion: apps/v1
metadata:
  labels:
    k8s-app: kubernetes-dashboard
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: kubernetes-dashboard
  template:
    metadata:
      labels:
        k8s-app: kubernetes-dashboard
    spec:
      containers:
        - name: kubernetes-dashboard
          image: kubernetesui/dashboard:v2.0.0-beta8
          imagePullPolicy: Always
          ports:
            - containerPort: 8443
              protocol: TCP
          args:
            - --auto-generate-certificates
            - --namespace=kubernetes-dashboard
            # Uncomment the following line to manually specify Kubernetes API server Host
            # If not specified, Dashboard will attempt to auto discover the API server and connect
            # to it. Uncomment only if the default does not work.
            # - --apiserver-host=http://my-address:port
          volumeMounts:
            - name: kubernetes-dashboard-certs
              mountPath: /certs
              # Create on-disk volume to store exec logs
            - mountPath: /tmp
              name: tmp-volume
          livenessProbe:
            httpGet:
              scheme: HTTPS
              path: /
              port: 8443
            initialDelaySeconds: 30
            timeoutSeconds: 30
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            runAsUser: 1001
            runAsGroup: 2001
      volumes:
        - name: kubernetes-dashboard-certs
          secret:
            secretName: kubernetes-dashboard-certs
        - name: tmp-volume
          emptyDir: {}
      serviceAccountName: kubernetes-dashboard
      nodeSelector:
        "beta.kubernetes.io/os": linux
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
        - key: node-role.kubernetes.io/master
          effect: NoSchedule

---

kind: Service
apiVersion: v1
metadata:
  labels:
    k8s-app: dashboard-metrics-scraper
  name: dashboard-metrics-scraper
  namespace: kubernetes-dashboard
spec:
  ports:
    - port: 8000
      targetPort: 8000
  selector:
    k8s-app: dashboard-metrics-scraper

---

kind: Deployment
apiVersion: apps/v1
metadata:
  labels:
    k8s-app: dashboard-metrics-scraper
  name: dashboard-metrics-scraper
  namespace: kubernetes-dashboard
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: dashboard-metrics-scraper
  template:
    metadata:
      labels:
        k8s-app: dashboard-metrics-scraper
      annotations:
        seccomp.security.alpha.kubernetes.io/pod: 'runtime/default'
    spec:
      containers:
        - name: dashboard-metrics-scraper
          image: kubernetesui/metrics-scraper:v1.0.1
          ports:
            - containerPort: 8000
              protocol: TCP
          livenessProbe:
            httpGet:
              scheme: HTTP
              path: /
              port: 8000
            initialDelaySeconds: 30
            timeoutSeconds: 30
          volumeMounts:
          - mountPath: /tmp
            name: tmp-volume
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            runAsUser: 1001
            runAsGroup: 2001
      serviceAccountName: kubernetes-dashboard
      nodeSelector:
        "beta.kubernetes.io/os": linux
      # Comment the following tolerations if Dashboard must not be deployed on master
      tolerations:
        - key: node-role.kubernetes.io/master
          effect: NoSchedule
      volumes:
        - name: tmp-volume
          emptyDir: {}
```


#### 疑问
Configure cgroup driver used by kubelet on control-plane node
When using Docker, kubeadm will automatically detect the cgroup driver for the kubelet and set it in the /var/lib/kubelet/kubeadm-flags.env file during runtime.

If you are using a different CRI, you have to modify the file /etc/default/kubelet (/etc/sysconfig/kubelet for CentOS, RHEL, Fedora) with your cgroup-driver value, like so:

KUBELET_EXTRA_ARGS=--cgroup-driver=<value>
This file will be used by kubeadm init and kubeadm join to source extra user defined arguments for the kubelet.

Please mind, that you only have to do that if the cgroup driver of your CRI is not cgroupfs, because that is the default value in the kubelet already.

Restarting the kubelet is required:

systemctl daemon-reload
systemctl restart kubelet
The automatic detection of cgroup driver for other container runtimes like CRI-O and containerd is work in progress.

