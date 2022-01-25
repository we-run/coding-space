### k8s 笔记



1. Error creating: No API token found for service account "default", retry after the token is automatically created and added to the service account

   -  配置文件的配置项内容有问题

     ```
     # /etc/kubernetes/apiserver  ----> KUBE_API_ARGS
     # The address on the local server to listen to.
     KUBE_API_ADDRESS="--insecure-bind-address=0.0.0.0"

     # The port on the local server to listen on.
     # KUBE_API_PORT="--port=8080"

     # Port minions listen on
     # KUBELET_PORT="--kubelet-port=10250"

     # Comma separated list of nodes in the etcd cluster
     KUBE_ETCD_SERVERS="--etcd-servers=http://0.0.0.0:2379"

     # Address range to use for services
     KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"

     # default admission control policies
     KUBE_ADMISSION_CONTROL="--admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"
     #KUBE_ADMISSION_CONTROL=""
     # Add your own!
     KUBE_API_ARGS="--service-account-key-file=/etc/kubernetes/serviceaccount.key"
     ####################################################
     ####################################################
     /etc/kubernetes/controller-manager
     ###
     # The following values are used to configure the kubernetes controller-manager

     # defaults from config and apiserver should be adequate

     # Add your own! --service-account-private-key-file
     KUBE_CONTROLLER_MANAGER_ARGS="--service-account-private-key-file=/etc/kubernetes/serviceaccount.key"
     ```

     ​

2. open /etc/docker/certs.d/registry.access.redhat.com/redhat-ca.crt: no such file or directory

   ```
   yum install -y rhsm
   https://access.redhat.com/solutions/2328381


   wget http://mirror.centos.org/centos/7/os/x86_64/Packages/python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm
   rpm2cpio python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm | cpio -iv --to-stdout ./etc/rhsm/ca/redhat-uep.pem | tee /etc/rhsm/ca/redhat-uep.pem

   docker pull registry.access.redhat.com/rhel7/pod-infrastructure:latest
   ```

   ​