#!/usr/bin/expect -f

# send 用于向进程发送字符串
# expect 从进程接收字符串
# spawn 启动新的进程
# interact 允许用户交互

# send命令接收一个字符串参数，并将该参数发送到进程。
# expect命令和send命令相反，expect通常用来等待一个进程的反馈，我们根据进程的反馈，再发送对应的交互命令。
# spawn命令用来启动新的进程，spawn后的send和expect命令都是和使用spawn打开的进程进行交互。
# interact命令用的其实不是很多，一般情况下使用spawn、send和expect命令就可以很好的完成我们的任务；但在一些特殊场合下还是需要使用interact命令的，interact命令主要用于退出自动化，进入人工交互。比如我们使用spawn、send和expect命令完成了ftp登陆主机，执行下载文件任务，但是我们希望在文件下载结束以后，仍然可以停留在ftp命令行状态，以便手动的执行后续命令，此时使用interact命令就可以很好的完成这个任务

spawn ssh $1@$$2
set timeout 30
match_max 100000
expect "*password*"
send -- "xxxxxxx\n"
expect "~]"
interact



