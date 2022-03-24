#!/bin/sh

# echo "current host public ip address : "`curl -L ip.tool.lu`

echo `curl -s cip.cc/$1`


# echo "字符串 - 后缀操作"
# the_suffix="GENG WU"
# echo "${the_suffix##* }"
# if [[ "${the_suffix##*}x" = "WU"x ]];then 
#     echo 'do somting'
# fi


# # 解析域名 为ip地址
# dig @172.16.10.16 -p 53 napi.xinzhili.cn


# arr=(
#     1
#     2
#     3
# )
# echo ${!arr[@]}