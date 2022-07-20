#!/bin/bash

echo $1
if [[ $1 =~ ^[0-9]+$ ]];then
        echo ok
else
        echo err
fi


# function check_ip() {
#     IP=$1
#     VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
#     if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
#         if [ ${VALID_CHECK:-no} == "yes" ]; then
#             echo "IP $IP available."
#         else
#             echo "IP $IP not available!"
#         fi
#     else
#         echo "IP format error!"
#     fi
# }
# # Example
# check_ip 192.168.1.1
# check_ip 256.1.1.1


# function check_ip() {
#     IP=$1
#     if [[ $IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
#         FIELD1=$(echo $IP|cut -d. -f1)
#         FIELD2=$(echo $IP|cut -d. -f2)
#         FIELD3=$(echo $IP|cut -d. -f3)
#         FIELD4=$(echo $IP|cut -d. -f4)
#         if [ $FIELD1 -le 255 -a $FIELD2 -le 255 -a $FIELD3 -le 255 -a $FIELD4 -le 255 ]; then
#             echo "IP $IP available."
#         else
#             echo "IP $IP not available!"
#         fi
#     else
#         echo "IP format error!"
#     fi
# }
# # Example
# check_ip 192.168.1.1
# check_ip 256.1.1.1



# read -p "Please input an integer: " num
# [[ "$num" =~ ^[1-9]+$ ]] && echo OK || echo Wrong



get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo ${IP}
}

check_ip(){
    local checkip=$1   
    local valid_check=$(echo $checkip|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')   
    if echo $checkip|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$" >/dev/null; then   
        if [ ${valid_check:-no} == "yes" ]; then   
            return 0   
        else   
            echo -e "[${red}Error${plain}] IP $checkip not available!"   
            return 1   
        fi   
    else   
        echo -e "[${red}Error${plain}] IP format error!"   
        return 1   
    fi
}
