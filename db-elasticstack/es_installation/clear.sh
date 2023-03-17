#!/bin/sh


for u in `awk -F':' '{print $2}' ./add_user.log`
do
	echo $u' processing ... '
        ps aux | grep '/home/esa' | awk '{print $2}' | xargs -I {} kill -9 {}
	su - $u --c 'ls | cut -d" " -f1 | xargs -I {} rm -rf {}' &
done

wait
echo 'END!'
