#!/usr/bin/expect

# 批量登录ssh服务器执行操作范例，设定增量的for循环
for {set i 10} {$i <= 12} {incr i} {
    set timeout 30
    set ssh_user [lindex $argv 0]
    spawn ssh -i .ssh/$ssh_user abc$i.com
 
    expect_before "no)?" {
    send "yes\r" }
    sleep 1
    expect "password*"
    send "hello\r"
    expect "*#"
    send "echo hello expect! > /tmp/expect.txt\r"
    expect "*#"
    send "echo\r"
}
exit


# 批量登录ssh并执行命令，foreach语法
#!/usr/bin/expect
if {$argc!=2} {
    send_user "usage: ./expect ssh_user password\n"
    exit
}
foreach i {11 12} {
    set timeout 30
    set ssh_user [lindex $argv 0]
    set password [lindex $argv 1]
    spawn ssh -i .ssh/$ssh_user root@xxx.yy.com
    expect_before "no)?" {
    send "yes\r" }
    sleep 1
 
    expect "Enter passphrase for key*"
    send "password\r"
    expect "*#"
    send "echo hello expect! > /tmp/expect.txt\r"
    expect "*#"
    send "echo\r"
}
exit





# 另一自动ssh范例，从命令行获取服务器IP，foreach语法，expect嵌套

#!/usr/bin/expect
# 使用方法: script_name ip1 ip2 ip3 ...
 
set timeout 20
if {$argc < 1} {
  puts "Usage: script IPs"
  exit 1
}
# 替换你自己的用户名
set user "username"
#替换你自己的登录密码
set password "yourpassword"
 
foreach IP $argv {
spawn ssh $user@$IP
 
expect \
  "(yes/no)?" {
    send "yes\r"
    expect "password:?" {
      send "$password\r"
    }
  } "password:?" {
    send "$password\r"
}
 
expect "\$?"
# 替换你要执行的命令
send "last\r"
expect "\$?"
sleep 10
send "exit\r"
expect eof
}




#  密码过期需要批量修改密码
#!/bin/bash
for i in `cat /root/soft/ip.txt`
do
    /usr/bin/expect << EOF
    spawn /usr/bin/ssh root@$i

    expect {
        "UNIX password" { send "Huawei@123\r" }
    }
    
    expect {
        "New password:" { send "xxHuzzawexxi@1234#\r" }
    }

   expect {
        "Retype new password:" { send "xxHuzzawexxi@1234#\r" }
    }

    expect "*]#"
    send "echo Huawei@123|passwd --stdin root\r"
    expect "*]#"
    send "exit\r"
    expect eof
EOF
done



