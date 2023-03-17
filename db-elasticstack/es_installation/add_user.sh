#!/bin/sh
#ES_GROUP=$1
#ES_USER=$2

for line in `cat ./add_user.log`
do
	echo $line
	IFS=':' read -r -a params <<< "$line"
	ES_GROUP=${params[0]}
	ES_USER=${params[1]}
	echo -e "group : ${ES_GROUP}, user: ${ES_USER}"
	egrep "^$ES_GROUP:" /etc/group >& /dev/null
	if [ $? -ne 0 ]
	then
		groupadd $ES_GROUP
	fi
	egrep "^$ES_USER:" /etc/passwd >& /dev/null
	if [ $? -ne 0 ]
	then
		useradd -g $ES_GROUP $ES_USER
	fi

	mkdir -p /home/${ES_USER}/.ssh/
	cp -r /root/.ssh/* /home/${ES_USER}/.ssh/
	chown -R ${ES_USER} /home/${ES_USER}/.ssh
	chgrp -R ${ES_GROUP} /home/${ES_USER}/.ssh

	passwd ${ES_USER}
done
