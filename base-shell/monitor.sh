#!/bin/sh

# */1  *  *  *  * /root/devops/deploy/check_scheduler.sh


WORK_DIR=$(cd $(dirname $0);pwd)

echo > $WORK_DIR/dep.log
echo $WORK_DIR

for l in `cat <<EOF
0_128,7030,7030,scheduler-side-server,10.0.0.128
0_128,7010,7010,scheduler-server,10.0.0.128
1_177,7010,7010,scheduler-server,10.0.1.177
1_169,7030,7030,scheduler-side-server,10.0.1.169
1_176,7030,7030,scheduler-side-server,10.0.1.176
EOF`;
do
    IFS=',' read -r -a params <<< "$l"
    echo ${params[0]}'>>'${params[2]}
    r=`curl --location --max-time 2 --request GET 'http://'${params[4]}':'${params[2]}''`
    if [[ -n $r ]];then
        echo `date`' '$0'>>1'$r >> $WORK_DIR/dep.log
        echo '请求成功...'
    else
        echo `date`' '$0'>>请求失败...' >>  $WORK_DIR/dep.log
        echo '0'$r
        health_threads=`ssh ${params[0]} 'ps -eLf | grep java | wc -l'`
        curl 'https://oapi.dingtalk.com/robot/send?access_token=aeea0fdd9847cb32b513a784d987def274fad3ab385f51a43d312ea38a3a6fda' \
        -H 'Content-Type: application/json' \
        -d '{"msgtype": "text","text": {"content":"XZL_ALERT - '${params[0]}'的'${params[3]}'服务无法连接，请及时处理!stats:threas_count>'$health_threads'"},"at":{"isAtAll":true}}'
    fi
done