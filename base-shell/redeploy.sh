#!/bin/sh

prod_hosts=\
(
"0_128"
"1_168"
"1_169"
"1_176"
"1_177"
)

WORK_DIR=$(cd $(dirname $0);pwd)
echo > $WORK_DIR/todo.txt
for h in ${prod_hosts[@]};
do
        echo $h
        ssh root@$h docker ps | awk -vhost=$h '$2 ~ /xzl-prod.+(-server|-service)$/ {print host,$(NF-1),$NF}' >> $WORK_DIR/todo.txt
done

sed -ri 's/\S+://g' $WORK_DIR/todo.txt
sed -ri 's/->/ /g' $WORK_DIR/todo.txt
sed -ri 's/\/tcp//g' $WORK_DIR/todo.txt
sed -ri 's/^$//g' $WORK_DIR/todo.txt
sed -ri 's/ /,/g' $WORK_DIR/todo.txt

for l in `cat $WORK_DIR/todo.txt`;
do
        IFS=',' read -r -a params <<< "$l"
        ssh root@${params[0]} docker stop ${params[3]}
        ssh root@${params[0]} docker container rm -f ${params[3]}
        ssh root@${params[0]} docker pull registry-vpc.cn-beijing.aliyuncs.com/xzl-prod/${params[3]}
        ssh root@${params[0]} 'docker run --log-opt max-size=10m --log-opt max-file=5 -d --restart=always -e HOST_IP=$(echo $(hostname -I) | cut -d " " -f1) -e EUREKA_URL=http://10.0.2.129:7990/eureka/ -e RUN_PORT='${params[2]} '-p' ${params[1]}':'${params[2]} '--name' ${params[3]} 'registry-vpc.cn-beijing.aliyuncs.com/xzl-prod/'${params[3]} '--spring.cloud.config.profile=aliyun_prod --spring.profiles.active=aliyun_prod'
        sleep 15
done