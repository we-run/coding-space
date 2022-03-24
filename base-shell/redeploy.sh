#!/bin/sh
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

main() {
  [ -z "$1" ] && _process --help && return
  if _startswith "$1" '-'; then _process "$@"; else "$@"; fi
}

_startswith() {
  _str="$1"
  _sub="$2"
  echo "$_str" | grep -- "^$_sub" >/dev/null 2>&1
}

_process() {
    while [ ${#} -gt 0 ]; do
        case "${1}" in
            --help | -h)
                echo 'please input specified server or service name.'
                return
            ;;
            --srv | -s)
                some_srv=$2
                echo "$some_srv"
		deploy $2
            ;;
        esac
        shift 1
    done
}

deploy() {
	for h in ${prod_hosts[@]};
	do
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
			echo 'Starting deploy ... '$l
			IFS=',' read -r -a params <<< "$l"
			ssh root@${params[0]} docker stop ${params[3]}
			ssh root@${params[0]} docker container rm -f ${params[3]}
			ssh root@${params[0]} docker pull registry-vpc.cn-beijing.aliyuncs.com/xzl-prod/${params[3]}
			ssh root@${params[0]} 'docker run --log-opt max-size=10m --log-opt max-file=5 -d --restart=always -e HOST_IP=$(echo $(hostname -I) | cut -d " " -f1) -e EUREKA_URL=http://10.0.2.129:7990/eureka/ -e RUN_PORT='${params[2]} '-p' ${params[1]}':'${params[2]} '--name' ${params[3]} 'registry-vpc.cn-beijing.aliyuncs.com/xzl-prod/'${params[3]} '--spring.cloud.config.profile=aliyun_prod --spring.profiles.active=aliyun_prod'
			#retryCheck 'http://10.0.'${params[0]/_/\.}':80' ${params[3]}
			retryCheck 'http://10.0.'${params[0]/_/\.}':'${params[2]} ${params[3]}
			sleep 15
		done
	else
		echo 'None Todo!'
	fi

}

retryCheck() {
	counter=0
	while(( $counter < 15 ))
	do
		let "counter++"
		r=`curl -s --location --max-time 2 --request GET $1`
		echo 'check count ... '$counter':'$1' for '$2
		if [[ -n $r ]];then
			break
		fi
		sleep 3
	done
	if [ $counter -lt 15 ];then
		echo 'deploy suc for '$1' of '$2
	else
		echo 'deploy fail for '$1' of '$2
		curl 'https://oapi.dingtalk.com/robot/send?access_token=aeea0fdd9847cb32b513a784d987def274fad3ab385f51a43d312ea38a3a6fda' \
		-H 'Content-Type: application/json' \
		-d '{"msgtype": "text","text": {"content":"XZL_ALERT - '$2'的'$1' 服务部署失败，请及时处理!"},"at":{"isAtAll":true}}'
		exit 1
	fi
}

main "$@"