# centos 8
# cd /etc/yum.repos.d/
# ls
# sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
# sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
# yum update -y


# systemctl stop firewalld
# systemctl disable firewalld
# # # 暂时
# sudo swapoff -a
# # # 永久
# # # vim /etc/fstab # 注释掉swap
# sed -ri 's/.+\bswap\b/#&/g' /etc/fstab

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

for i in {0..6}
do
    # ssh 'guest_me_'$i 'echo "export https_proxy=http://192.168.1.1:1087 http_proxy=http://192.168.1.1:1087 all_proxy=socks5://192.168.1.1:1080" >> ~/.bash_profile'
    # ssh 'guest_me_'$i curl https://google.com >> ~/test.txt
    ssh 'guest_me_'$i 'ip a'
done