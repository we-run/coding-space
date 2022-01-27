#!/bin/sh

ABS_WORK_PATH=$(cd $(dirname "$0");pwd)

OLD_FS=$IFS
export IFS=","
sales='"衬衫","羊毛衫","雪纺衫","裤子","高跟鞋","袜子"'
values='5,10,15,66,9,88'

s1_arr=($sales)
s2_arr=($values)

template="{name:var1,value:var2}"
for i in ${!s1_arr[@]};
do 
    var1=${s1_arr[$i]}
    var2=${s2_arr[$i]}
    echo $template | sed "s/var1/$var1/g" | sed "s/var2/$var2/g" >> $ABS_WORK_PATH/r.txt
done 