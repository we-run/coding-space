#!/bin/bash

WORK_DIR=$(cd $(dirname $0);pwd)

nodes=(
    "node1"
    "node2"
    "node3"
)

remote() {
    ssh -i ~/.ssh/work_rsa es@$1 ${2}
}

cat > setup.sh <<EOF
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
# mv ~/$1 /home/es/
# su - es
# tar zxvf $1

# reboot -n


rm -rf elasticsearch-8.0.0
tar zxvf elasticsearch-8.0.0-linux-x86_64.tar.gz
echo '
xpack.security.enabled: false
xpack.security.transport.ssl.enabled: false
' >> ~/elasticsearch-8.0.0/config/elasticsearch.yml




EOF

# scp -i  ~/.ssh/work_rsa -r es@node1:'/home/es/elasticsearch-8.0.0/config/' .

for host in ${nodes[@]}; do
    echo $host
    # remote $host 'ls -al'
    # ls -l '/Volumes/Seagate\ Exp/Software/CentOSJDK/jdk-11.0.6_linux-x64_bin.rpm'
    # scp -i ~/.ssh/work_rsa '/Volumes/Seagate Exp/Software/CentOSJDK/jdk-11.0.6_linux-x64_bin.rpm' root@$host:'~'
    # remote $host 'cd ~ && rpm -ivh jdk-11.0.6_linux-x64_bin.rpm'
    # remote $host 'rpm -qa | grep -i jdk | xargs -I {} rpm -e {}'
    
    # remote $host 'groupadd devops'
    # remote $host 'useradd -g devops es'
    # remote $host 'passwd es'
    # ssh-copy-id -i ~/.ssh/work_rsa es@$host
    # scp -i ~/.ssh/work_rsa '/Users/dongfuqiang/Desktop/PAN/SpaceV/Downloads/Chrome/elasticsearch-8.0.0-linux-x86_64.tar.gz' es@$host:'~'
    # remote $host 'tar zxvf elasticsearch-8.0.0-linux-x86_64.tar.gz'

    # /home/es/elasticsearch-8.0.0/elasticsearch-setup-passwords auto
    # /home/es/elasticsearch-8.0.0/bin/elasticsearch-certutil ca
    # /home/es/elasticsearch-8.0.0/bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12

    # scp -i ~/.ssh/work_rsa es@$host:'/home/es/elasticsearch-8.0.0/config/elasticsearch.yml' .

    # sed -e "s/\$NODE_NAME/$host/g" -e "s/\$HOSTADDR/${host}.daqiang.me/g" $WORK_DIR/elasticsearch_temp.yml > elasticsearch.yml
    # scp -i ~/.ssh/work_rsa $WORK_DIR/elasticsearch.yml es@$host:'/home/es/elasticsearch-8.0.0/config'
    
    # scp -i  ~/.ssh/work_rsa $WORK_DIR/setup.sh es@$host:'~'
    # remote $host 'sh ~/setup.sh'
    # remote $host "sed -i 's/^nameserver.*/nameserver 172\.16\.10\.16/g' /etc/resolv.conf"

    # curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.0.0-linux-x86_64.tar.gz
    # tar xzvf metricbeat-8.0.0-linux-x86_64.tar.gz
    ssh -i ~/.ssh/work_rsa  root@$host "ip a | sed -e '/inet/p'"
done


# cat < set_passwd.sh <<EOF
# #!/usr/bin/expect
# spawn passwd
# set timeout 30
# match_max 100000
# expect {
#     "新的 密码:" {
#         send "dfqqfd123\n"
#     }
#     "重新输入新的 密码": {
#         send "dfqqfd123\n"
#     }
#  }
# EOF