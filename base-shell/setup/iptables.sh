#!/bin/bash

## register ip and port
IP=$1
VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
	if [[ ${VALID_CHECK:-no} == "yes" ]]; then
	    echo "IP $IP available."
	else
	    echo "IP $IP not available!"
	    exit 1
	fi
else
    echo "IP format error!"
    exit 1
fi
WORK_DIR=$(cd $(dirname $0);pwd)

if [[ "$2" =~ ^[0-9]+$ ]];then
    echo 'Port OK'
    echo $1':'$2 >> $WORK_DIR/.port_using
else
    echo port error!
    exit 1
fi
EXISTED_PORT=$(iptables -t nat -L PREROUTING -n | grep 'DNAT' | grep ':'$2)
if [ -n "$EXISTED_PORT" ];then
   echo 'Existed The Port : '$2
   exit 1
fi

echo 'applying...'$EXISTED_PORT
iptables -t nat -I PREROUTING -i eno1 -p tcp --dport $2 -j DNAT --to-destination $1:$2


## revoke
TO_REVOKE=$(iptables -t nat -L PREROUTING -nv --line | sed -n '3,$p' | awk '{print $1" "$NF}' | grep $1 | awk '{print $1}')
if [[ "$TO_REVOKE" =~ ^[0-9]+$ ]];then
    echo 'find port'
    iptables -t nat -D PREROUTING $TO_REVOKE
else
    echo port error!
    exit 1
fi