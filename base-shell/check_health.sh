#!/bin/sh

# r=`curl --location --max-time 2 --request GET 'http://172.16.10.204:8000/v1/ms/yx/message/test.eJ15QN' \
# --header 'xzl-client-id: xzl-ios-patient' \
# --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwcm9kLnI0cUxWVyIsImlhdCI6MTY0NTQyNDY5OCwiZXhwIjoxNzMxODI0Njk4fQ.VLJSEd-tvZcp3QZ9q1KKoyhA6oeNlUUXZeGirlulkrA'`

# read -d '' tmp <<-"_EOF_"
# scheduler-server 10.0.0.128 7010
# scheduler-server 10.0.0.128 7010
# _EOF_
# echo $tmp
# tmp=


# */1  *  *  *  * /root/devops/deploy/check_scheduler.sh

for l in `cat <<EOF
0_128,7030,7030,scheduler-side-server
0_128,7010,7010,scheduler-server
1_169,7010,7010,scheduler-server
1_169,7030,7030,scheduler-side-server
1_176,7030,7030,scheduler-side-server
EOF`;
do
    IFS=',' read -r -a params <<< "$l"
    
    echo ${params[0]}'>>'${params[2]}
    r=`curl --location --max-time 2 --request GET 'http://172.16.10.204:8000'`
    if [[ -n $r ]];then
        echo '1'$r
        echo '请求成功...'
    else
        echo '请求失败...'
        echo '0'$r
        curl 'https://oapi.dingtalk.com/robot/send?access_token=aeea0fdd9847cb32b513a784d987def274fad3ab385f51a43d312ea38a3a6fda' \
        -H 'Content-Type: application/json' \
        -d '{"msgtype": "text","text": {"content":"XZL_ALERT - @所有人'${params[0]}'的'${params[3]}'服务无法连接，请及时处理!"}}'
    fi
done





prod_hosts=\
(
"0_128"
"1_168"
"1_169"
"1_176"
"1_177"
"2_129"
"2_130"
"2_131"
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

if [[ -n $1 ]];then
        echo 'todo ... '$1
        for l in `awk '$NF ~ /'$1'$/ {print $0}' $WORK_DIR/todo.txt`;
        do
                echo $l
                echo "=====>"
                IFS=',' read -r -a params <<< "$l"
                ssh root@${params[0]} docker stop ${params[3]}
                ssh root@${params[0]} docker container rm -f ${params[3]}
                ssh root@${params[0]} docker pull registry-vpc.cn-beijing.aliyuncs.com/xzl-prod/${params[3]}
                ssh root@${params[0]} 'docker run --log-opt max-size=10m --log-opt max-file=5 -d --restart=always -e HOST_IP=$(echo $(hostname -I) | cut -d " " -f1) -e EUREKA_URL=http://10.0.2.129:7990/eureka/ -e RUN_PORT='${params[2]} '-p' ${params[1]}':'${params[2]} '--name' ${params[3]} 'registry-vpc.cn-beijing.aliyuncs.com/xzl-prod/'${params[3]} '--spring.cloud.config.profile=aliyun_prod --spring.profiles.active=aliyun_prod'
                sleep 15
        done
else
        echo 'None Todo!'
fi