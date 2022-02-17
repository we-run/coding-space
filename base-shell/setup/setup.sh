# cd /etc/yum.repos.d/
# ls
# sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
# sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
# yum update -y

# systemctl stop firewalld
# systemctl disable firewalld
# # 暂时
# sudo swapoff -a
# # 永久
# # vim /etc/fstab # 注释掉swap

# # 添加参数
# echo '
# vm.max_map_count = 262144
# fs.file-max = 2097152
# vm.swappiness = 1
# ' >> /usr/lib/sysctl.d/50-default.conf

# sysctl -p
# ulimit -Hn 65536

# echo '
# #用户 #文件类型
# root  hard nofile 65536
# root  soft nofile 65536
# root  memlock unlimited
# es hard nofile 65536
# es soft nofile 65536
# es memlock unlimited
# ' >> /etc/security/limits.conf

# groupadd devops
# useradd -g devops es
# mv ~/ /home/es/
# su - es
# tar zxvf 

# reboot -n


rm -rf elasticsearch-8.0.0
tar zxvf elasticsearch-8.0.0-linux-x86_64.tar.gz
echo '
xpack.security.enabled: false
xpack.security.transport.ssl.enabled: false
' >> ~/elasticsearch-8.0.0/config/elasticsearch.yml




