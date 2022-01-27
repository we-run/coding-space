#!/bin/sh

echo "current host public ip address : "`curl -L ip.tool.lu`


curl cip.cc/$0



echo "字符串 - 后缀操作"
the_suffix="GENG WU"
if [[ "${the_suffix##* }x" = "WU"x ]];then 
    echo 'do somting'
fi


arr=(
    1
    2
    3
)
echo ${!arr[@]}