

# $1 : es version
# $2 : target host ip address
# $3 : cluster ip addresses
# WORK_DIR="$(cd -- "$(dirname "$2")" >/dev/null 2>&1 ; pwd -P )"
judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

cd $HOME
WORK_DIR=$HOME
# ES_VER=$1
# SELF_IP=$2
# CLUSTER_IPS=$3

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
    echo '0 > elasticsearch-'$ES_VER' had exsited.'
fi
TO_ES_HOME=$(find $WORK_DIR -maxdepth 2 -type d -name 'elasticsearch-'$ES_VER)
echo '>>'$TO_ES_HOME
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

# > 2. modify elasticserach config file
# "cluster.name:der-es;node.name:node-1;node.attr.rack:rack-1;node.attr.size:big;path.data:$TO_ES_HOME/data1;network.host:"


# > 3. find taget elasticsearch version and execute it
echo 'Launch the es server of verion : '$ES_VER
TO_KILL_KIB=$(ps aux | awk '$NF ~ /kibana/ {print $2}')
if [[ -n $TO_KILL_KIB ]];then
    echo "Kill old kibana ... "$TO_KILL
    kill -9 $TO_KILL
fi
nohup $TO_KIB_HOME/bin/kibana &

$TO_ES_HOME/bin/elasticsearch -d

# > 4. clear once config
# >> 4.1 清除 discovery.seed_hosts , 只允许其配置一次即可

