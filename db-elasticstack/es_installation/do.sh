#!/bin/sh
ES_VER=8.1.0
NODE=$1

if [[ $2 = 'token' ]]; then
	echo $2
	./$NODE/elasticsearch-8.1.0/bin/elasticsearch-create-enrollment-token -s node
elif [[ $1 == 'restart' ]]; then
	echo 'restart the esa es cluster'
	ps aux | grep '/home/esa' | awk '{print $2}' | xargs -I {} kill -9 {}
	sleep 3
	for i in {1..3}
	do
		./node$i/elasticsearch-8.1.0/bin/elasticsearch -d
		sleep 2
	done
else
	./$NODE/elasticsearch-8.1.0/bin/elasticsearch -d
fi
