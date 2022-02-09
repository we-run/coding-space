


### Expect采用的是一种叫做Tcl （Tool Command Language ）的脚本语言，所以你至少要学习一下TCL它的语法。

TCL资料
TCL网站
Tcl/Tk 8.5 Manual: http://www.tcl.tk/man/tcl8.5/ & http://tmml.sourceforge.net/doc/tcl/index.html
Tcl Tutorial: http://www.tcl.tk/man/tcl8.5/tutorial/tcltutorial.html
Tcl syntax help: http://wiki.tcl.tk/1019
Learning Tcl: http://wiki.tcl.tk/20789
上面几个网站都属于Tclers Wiki http://wiki.tcl.tk/ 下面的分支来的。

TCL书籍
还有一本书《Practical Programming in Tcl and Tk》

http://www.beedub.com/book/
亚马逊链接： Tcl/Tk入门经典(第2版)





```
-c:执行脚本前先执行的命令，可多次使用。
-d:debug模式，可以在运行时输出一些诊断信息，与在脚本开始处使用exp_internal 1相似。
-D:启用交换调式器,可设一整数参数。
-f:从文件读取命令，仅用于使用#!时。如果文件名为"-"，则从stdin读取(使用"./-"从文件名为-的文件读取)。
-i:交互式输入命令，使用"exit"或"EOF"退出输入状态。
--:标示选项结束(如果你需要传递与expect选项相似的参数给脚本时)，可放到#!行:#!/usr/bin/expect --。
-v:显示expect版本信息。
```




# 使用普通用户登录远程主机，并通过sudo到root权限，通过for循环批量在远程主机执行命令.
```shell
$ cat timeout_login.txt 
10.0.1.8
10.0.1.34
10.0.1.88
10.0.1.76
10.0.1.2
10.0.1.3
```

```shell
#!/bin/bash

for i in `cat /home/admin/timeout_login.txt`
do
    /usr/bin/expect << EOF
    spawn /usr/bin/ssh -t -p 22022 admin@$i "sudo su -"
    
    expect {
        "yes/no" { send "yes\r" }
    }   

    expect {
        "password:" { send "xxo1#qaz\r" }
    }
    
    expect {
        "*password*:" { send "xx1#qaz\r" }
    }

    expect "*]#"
    send "df -Th\r"
    expect "*]#"
    send "exit\r"
    expect eof
EOF
done
```