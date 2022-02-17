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

# 如果一个用户同时属于多个用户组，那么用户可以在用户组之间切换，以便具有其他用户组的权限
# newgrp root