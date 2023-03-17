#!/bin/sh
# $1 : es version
# $2 : target host ip address
# $3 : cluster ip addresses

# 用户组、用户、版本、工作目录、集群IP

ES_GROUP="esg"
ES_USER="es"
# shellcheck disable=SC2164
cd $HOME
WORK_DIR=$HOME
# ES_VER=$1
# SELF_IP=$2
# CLUSTER_IPS=$3

# WORK_DIR="$(cd -- "$(dirname "$2")" >/dev/null 2>&1 ; pwd -P )"

judge() {
    if [[ 0 -eq $? ]]; then
        # shellcheck disable=SC2154
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        # shellcheck disable=SC2154
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

get_es() {
    
    
    # if [[ ! -f "./elasticsearch-$ES_VER.tar.gz" ]];then
    #     curl --progress-bar -o ./elasticsearch-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$ES_VER"-linux-x86_64.tar.g
    # else
    #     echo 'Exsited The File!'
    # fi
    ES_VER=8.1.0
    RF="$HOME/elasticsearch-$ES_VER.tar.gz"
    echo $RF
    if [[ ! -f "$RF" ]]; then
        echo 'ES SCHEL 3 : copy es file ... '$ES_VER
        scp -i $P_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dongfuqiang@192.168.87.1:'~/elasticsearch-'$ES_VER'.tar.gz' .
        tar -zxf elasticsearch-"$ES_VER".tar.gz
    else
        echo 'Existed The es tar file.'$ES_VER
    fi
    
    KF="$HOME/kibana-$KIB_VER.tar.gz"
    if [ ! -f "$KF" ] && [ $KIB_VER ]; then
        echo 'ES SCHEL 3 : copy kibana file ... '$KIB_VER
        echo '~/kibana-'$KIB_VER'.tar.gz'
        scp -i $P_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dongfuqiang@192.168.87.1:'~/kibana-'$KIB_VER'.tar.gz' .
        tar -zxf kibana-"$KIB_VER".tar.gz
        mv $(find ./ -maxdepth 2 -type d -name 'kibana*') "kibana-"$KIB_VER
    else
        echo 'Exsited Kibana file.'
    fi
    
    #  scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.254:~/*.tar.gz .
    # ssh -i $P_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.254 ls -l
    
    # (
    #     echo 'scp root@192.168.1.254:~/*.gz .'
    #     sleep 5
    #     echo '_Xinzhili901_'
    #     sleep 5
    #     echo 'exit'
    # ) |
    
    # python -c 'import pty; pty.spawn("/usr/bin/bash")'
    
    
}

set_host() {
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
${ES_USER} hard nofile 65536
${ES_USER} soft nofile 65536
${ES_USER} memlock unlimited

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
    mkdir -p /home/${ES_USER}/.ssh/
    cp -r /root/.ssh/* /home/${ES_USER}/.ssh/
    chown -R ${ES_USER} /home/${ES_USER}/.ssh
    chgrp -R ${ES_GROUP} /home/${ES_USER}/.ssh
    
    passwd ${ES_USER}
}



# echo 'ES VERSION: '$ES_VER ', SELF_IP : '$SELF_IP ', CLUSTER_IPS:'$CLUSTER_IPS
echo 'ES VERSION : '$ES_VER

# >> 0.2 check and download elasticsearch to localhost
# https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.1.2-linux-x86_64.tar.gz
# https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.13.0-linux-x86_64.tar.gz
TO_ES_HOME=$(find ./ -maxdepth 2 -type d -name 'elasticsearch-'$ES_VER)
TO_KIB_HOME=$(find ./ -maxdepth 2 -type d -name 'kibana-'$ES_VER)



if [ -z $TO_ES_HOME ]; then
    echo '0 > need to download elasticsearch-'$ES_VER'... '
    tar -zxf elasticsearch-"$ES_VER".tar.gz
    # curl --progress-bar -o ./elasticsearch-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$ES_VER"-linux-x86_64.tar.gz && tar -zxf elasticsearch-"$ES_VER".tar.gz
else
    echo '0 > elasticsearch-'$ES_VER' had existed.'
fi
TO_ES_HOME=$(find $WORK_DIR -maxdepth 2 -type d -name 'elasticsearch-'$ES_VER)
echo ">>$TO_ES_HOME"
# >> 0.3 set up es running env

# >>> Heap size settings
echo 'modify '$TO_ES_HOME'/config/jvm.options for Heap size settings'
sed -ri 's/^#.*-Xms.+g/-Xms2g/g' "$TO_ES_HOME"/config/jvm.options
sed -ri 's/^##.*-Xms.+g/-Xms2g/g' "$TO_ES_HOME"/config/jvm.options
sed -ri 's/^.*-Xms.+g/-Xms2g/g' "$TO_ES_HOME"/config/jvm.options
sed -ri 's/^#.*-Xmx.+g/-Xmx2g/g' "$TO_ES_HOME"/config/jvm.options
sed -ri 's/^##.*-Xmx.+g/-Xmx2g/g' "$TO_ES_HOME"/config/jvm.options
sed -ri 's/^.*-Xmx.+g/-Xmx2g/g' "$TO_ES_HOME"/config/jvm.options

# >>> JVM heap dump path setting

# >>> GC logging settings

# >>> Temporary directory settings

# >>> JVM fatal error log setting

# >>> Cluster backups

# >>>

# > 1. check and kill exsited elasticsearch process
TO_KILL=$(ps aux | awk '$(NF-1)$NF ~ /bootstrap.Elasticsearch/ {print $2}')
# TO_KILL=$(ps aux | grep -E -e 'org.elasticsearch.bootstrap.Elasticsearch' | awk '$11 ~ /java$/ {print $2}')
if [[ -n $TO_KILL ]];then
    echo "Kill old es ..."$TO_KILL
    kill -9 $TO_KILL
fi

# > 2. modify elasticsearch config file
# "cluster.name:der-es;node.name:node-1;node.attr.rack:rack-1;node.attr.size:big;path.data:$TO_ES_HOME/data1;network.host:"


# > 3. find target elasticsearch version and execute it
echo 'Launch the es server of verion : '$ES_VER
TO_KILL_KIB=$(ps aux | awk '$NF ~ /kibana/ {print $2}')
if [[ -n $TO_KILL_KIB ]];then
    echo "Kill old kibana ... "$TO_KILL
    kill -9 $TO_KILL
fi

#nohup $TO_KIB_HOME/bin/kibana &
#$TO_ES_HOME/bin/elasticsearch -d

# > 4. clear once config
# >> 4.1 清除 discovery.seed_hosts , 只允许其配置一次即可

