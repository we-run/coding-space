
echo '-----'
echo $ES_VER
echo '-----'

systemctl stop firewalld || true
systemctl disable firewalld || true
iptables -F || true

# https://www.elastic.co/guide/en/elasticsearch/reference/7.13/index.html
# > 0. init env
# >> 0.1 set up system running env
# >>> Disable swapping
# https://www.elastic.co/guide/en/elasticsearch/reference/7.13/setup-configuration-memory.html
swapoff -a
sed -ri '/\bswap\b/s/^/#/g' /etc/fstab

# >>> Increase file descriptors
# https://www.elastic.co/guide/en/elasticsearch/reference/7.13/file-descriptors.html
ulimit -n 65535
if [[ -z $(grep -i 'es-not-limit' /etc/security/limits.conf) ]]; then
cat >> /etc/security/limits.conf <<EOF
# es-not-limit
#用户 #文件类型
root  hard nofile 65536
root  soft nofile 65536
root  memlock unlimited
es hard nofile 65536
es soft nofile 65536
es memlock unlimited

root hard nproc 4096
root soft nproc 4096
es hard nproc 4096
es soft nproc 4096
EOF
fi

# >>> Ensure sufficient virtual memory
# https://www.elastic.co/guide/en/elasticsearch/reference/7.13/vm-max-map-count.html
sysctl -w vm.max_map_count=262144
if [[ -z $(grep -i '#es-not-limit' /etc/sysctl.conf) ]]; then
cat >> /etc/sysctl.conf <<EOF
# es-not-limit
vm.max_map_count = 262144
net.ipv4.tcp_retries2 = 5
EOF
fi
sysctl vm.max_map_count

# >>> Ensure sufficient threads
# https://www.elastic.co/guide/en/elasticsearch/reference/7.13/max-number-of-threads.html
ulimit -u 4096
# permanent config in /etc/security/limits.conf above

# >>> JVM DNS cache settings

# >>> Temporary directory
# https://www.elastic.co/guide/en/elasticsearch/reference/7.13/executable-jna-tmpdir.html
export ES_TMPDIR=/var/tmp
mkdir -p $ES_TMPDIR
# -Djna.tmpdir=<path>

# >>> Tcp retransmission timeout
# https://www.elastic.co/guide/en/elasticsearch/reference/7.13/system-config-tcpretries.html
sysctl -w net.ipv4.tcp_retries2=5
# set 'net.ipv4.tcp_retries2 = 5' above
sysctl net.ipv4.tcp_retries2


# >>> create es user and group with password
ES_GROUP="esg"
ES_USER="es"
egrep "^$ES_GROUP" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
    groupadd $ES_GROUP
fi
egrep "^$ES_USER" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd -g $ES_GROUP $ES_USER
fi


# >>> 
mkdir -p /home/es/.ssh/
cp -r /root/.ssh/* /home/es/.ssh/
chown -R es /home/es/.ssh
chgrp -R esg /home/es/.ssh


passwd es
