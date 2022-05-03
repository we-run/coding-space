#!/bin/bash


# useradd –d  /home/sam -m sam
# 此命令创建了一个用户sam，其中-d和-m选项用来为登录名sam产生一个主目录 /home/sam（/home为默认的用户主目录所在的父目录）。

# useradd -s /bin/sh -g group –G adm,root gem
# 此命令新建了一个用户gem，该用户的登录Shell是 /bin/sh，它属于group用户组，同时又属于adm和root用户组，其中group用户组是其主组。
# 这里可能新建组：#groupadd group及groupadd adm

# userdel 选项 用户名
# 常用的选项是 -r，它的作用是把用户的主目录一起删除。

# usermod 选项 用户名
# usermod -s /bin/ksh -d /home/z –g developer sam
# 此命令将用户sam的登录Shell修改为ksh，主目录改为/home/z，用户组改为developer。

# 为该用户指定命令解释程序
# usermod -s /bin/bash helloworld



# 为该用户添加 sudo 权限
# chmod u+w /etc/sudoers
# vim /etc/sudoers
# 找到这行 root ALL=(ALL) ALL 追加新行
# helloworld ALL=(ALL:ALL) ALL
# 撤销 sudoers 文件写权限
# chmod u-w /etc/sudoers

# 创建新用户会自动创建一个以用户名命名的新目录，需要为新目录添加读写权限
# chown helloworld:helloworld -R /home/helloworld/


# 如果一个用户同时属于多个用户组，那么用户可以在用户组之间切换，以便具有其他用户组的权限
# newgrp root

#create group if not exists
ES_GROUP="es_group"
ES_USER="es"
egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
    groupadd $group
fi

#create user if not exists
egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd -g $group $user
fi

#create user if not exists
id $user >& /dev/null
if [ $? -ne 0 ]
then
   useradd -g $group $user
fi
