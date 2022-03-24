#!/bin/sh

# physical id: 指的是物理封装的处理器的 id。
# cpu cores: 位于相同物理封装的处理器中的内核数量。
# core id: 每个内核的 id。
# siblings: 位于相同物理封装的处理器中的逻辑处理器的数量。
# processor: 逻辑处理器的 id。

## 获取IP V4地址
IP_ADDR=$(ip -4 addr | sed -ne 's|^.* inet \([^/]*\)/.* scope global.*$|\1|p' | head -1)


function is_my_macos(){
    if [[ `uname` -eq 'Darwin' ]]; then 
        return 1
    else 
        return 0
    fi 
}
function is_my_linux(){
    if [[ `uname` -eq 'Linux' ]]; then 
        return 1
    else 
        return 0
    fi 
}

#  查看系统已用的句柄数量
cat /proc/sys/fs/file-nr

# 系统总限制数
cat /proc/sys/fs/file-max
lsof -n| awk '{print $2}' | sort | uniq -c | sort -nr | more
ps aux | grep scheduler-server | grep java | awk '{print $2}' | xargs -I {} lsof -p {} | wc -l
ps -aef|grep 24204  

ls -l /proc/进程ID/fd | wc -l

2_129,8071,8071,notify-service
2_129,8070,8070,sidecar-server
2_129,7980,7980,config-server
2_129,7990,7990,eureka-server

0_128,7030,7030,scheduler-side-server
1_169,7030,7030,scheduler-side-server
1_176,7030,7030,scheduler-side-server

0_128,7010,7010,scheduler-server
1_177,7010,7010,scheduler-server

2_129,8060,8060,research-service

1_168,8000,8000,apis-service
2_129,8000,8000,apis-service

1_176,8030,8030,med-service
2_130,8030,8030,med-service

1_176,8040,8040,contact-service
2_130,8040,8040,contact-service

1_177,8020,8020,console-service
2_131,8020,8020,console-service

1_177,8010,8010,naming-service
2_131,8010,8010,naming-service