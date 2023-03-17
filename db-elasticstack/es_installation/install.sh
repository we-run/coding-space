#!/bin/sh

ES_VER=8.1.0
KIB_VER=8.1.0

#notification information
Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"
#fonts color
Green="\033[32m"
Red="\033[31m"

judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

new_es_node() {
    user=$1
    es_work=$2
    es_seq=$3
    echo 'new node for '$user
    kib_cmd=""
    if [[ $es_seq == 'node1' ]]; then
       echo 'write es and kib command...'
su - $user -- <<EOF
mkdir -p $es_work/$es_seq
tar -zxf /home/${user}/elasticsearch-${ES_VER}.tar.gz -C $es_work/$es_seq
tar -zxf /home/${user}/kibana-${KIB_VER}.tar.gz -C $es_work/$es_seq
EOF
    else
	echo 'write es only ... '
su - $user -- <<EOF
mkdir -p $es_work/$es_seq
tar -zxf /home/${user}/elasticsearch-${ES_VER}.tar.gz -C $es_work/$es_seq
EOF
    fi

}

copy_targets() {
for u in `awk -F':' '{print $2}' ./add_user.log`
do
	echo $u
	RF="/home/${u}/elasticsearch-$ES_VER.tar.gz"
	echo $RF
	if [[ ! -f "$RF" ]]; then
	    echo 'ES SCHEL 3 : copy es file ... '$ES_VER
	    #scp -i $P_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dongfuqiang@192.168.87.1:'~/elasticsearch-'$ES_VER'.tar.gz' .
	    cp ../elasticsearch-"$ES_VER".tar.gz /home/$u/
#	    su - $u -c 'tar -zxf /home/'$u'/elasticsearch-'$ES_VER'.tar.gz'
	else
	    echo 'Existed The es tar file.'$ES_VER
	fi

	KF="/home/${u}/kibana-$KIB_VER.tar.gz"
	echo $KF
	if [ ! -f "$KF" ] && [ $KIB_VER ]; then
	    echo 'ES SCHEL 3 : copy kibana file ... '$KIB_VER
	    echo '~/kibana-'$KIB_VER'.tar.gz'
	    #scp -i $P_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dongfuqiang@192.168.87.1:'~/kibana-'$KIB_VER'.tar.gz' .
	    cp ../kibana-"$KIB_VER".tar.gz /home/$u/
#	    su - $u -c 'tar -zxf /home/'$u'/kibana-'$KIB_VER'.tar.gz'
#	    #mv $(find ./ -maxdepth 2 -type d -name 'kibana*') "kibana-"$KIB_VER
	else
	    echo 'Exsited Kibana file.'
	fi
        for i in {1..3}
	do
	    new_es_node $u /home/$u 'node'$i &
	done
done
}

copy_targets

wait
