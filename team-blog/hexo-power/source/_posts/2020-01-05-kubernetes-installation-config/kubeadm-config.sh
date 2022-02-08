#!/bin/bash

# 192.168.0.99 本机
hosts=\
(
    # home-host
    # "192.168.0.100"
    # head-1
    "192.168.0.101"
    # head-2
    # "192.168.0.102"

    # node-1
    "192.168.0.111"
    # node-2
    "192.168.0.112"
)
# scp $1 
# get length for array : ${#hosts[@]}
for host in ${hosts[@]}
do
    # scp -r /Volumes/SpaceV/PAN/SpaceV/bakup/littleTools root@$host:"~"

    # ssh root@$host 'rm -f /root/actor.sh'
    # scp /Volumes/SpaceV/PAN/SpaceV/Application/Blog/blog.daqiang.me/source/_posts/2020-01-05-kubernetes-installation-config/actor.sh root@$host:"~"
    # ssh root@$host 'bash /root/actor.sh'

    # ssh root@$host 'systemctl start docker'
    ssh root@$host 'systemctl enable docker.service'
done