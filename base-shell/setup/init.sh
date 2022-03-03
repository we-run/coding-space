#!/bin/bash

WORK_DIR=$(cd $(dirname $0);pwd)

nodes=(
    "172.16.10.131"
    "172.16.10.132"
    "172.16.10.133"
)

remote() {
    ssh -i ~/.ssh/work_rsa root@$1 ${2}
}

cat > setup.sh <<EOF
# centos 8
# cd /etc/yum.repos.d/
# ls
# sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
# sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
# yum update -y


systemctl stop firewalld
systemctl disable firewalld
# # 暂时
sudo swapoff -a
# # 永久
# # vim /etc/fstab # 注释掉swap
sed -ri 's/.+\bswap\b/#&/g' /etc/fstab
sed -ri '/\bswap\b/s/^/#/g' /etc/fstab

# 添加参数
echo '
vm.max_map_count = 262144
fs.file-max = 2097152
vm.swappiness = 1
' >> /usr/lib/sysctl.d/50-default.conf

sysctl -p
ulimit -Hn 65536

echo '
#用户 #文件类型
root  hard nofile 65536
root  soft nofile 65536
root  memlock unlimited
es hard nofile 65536
es soft nofile 65536
es memlock unlimited
' >> /etc/security/limits.conf

EOF

# scp -i  ~/.ssh/work_rsa -r es@node1:'/home/es/elasticsearch-8.0.0/config/' .

for host in ${nodes[@]}; do
    echo $host
    # ssh-copy-id -i ~/.ssh/work_rsa root@$host
    # scp -i ~/.ssh/work_rsa $WORK_DIR/setup.sh root@$host:'~'
    # ssh -i ~/.ssh/work_rsa root@$host 'sh setup.sh'
    scp -i ~/.ssh/work_rsa '/Users/dongfuqiang/Desktop/PAN/SpaceV/Downloads/Chrome/es&lucene/elasticsearch-8.0.0-linux-x86_64.tar.gz' es@$host:'~'
    ssh -i ~/.ssh/work_rsa es@$host 'tar zxvf elasticsearch-8.0.0-linux-x86_64.tar.gz'
    # ssh -i ~/.ssh/work_rsa root@$host 'reboot -n'
    # curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.0.0-linux-x86_64.tar.gz
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