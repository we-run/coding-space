#!/usr/bin/expect -f

### 跳板机 -> 目标机 自动登陆

spawn ssh ${YOUR_NAME}@${YOUR_HOST}
set timeout 30
match_max 100000
expect {
    "(yes/no)?" {
        send "yes\n"
        expect "password:"
        send "${YOUR_PASSWORD}\n"
        expect "~]"
        send "ssh ${YOUR_HOST_2}"
        expect {
            "(yes/no)?" {
                send "yes\n"
                expect "password:"
                send "${YOUR_PASSWD_2}"
            }
            "password:" {
                send "${YOUR_PASSWD_2}"
            }
        }
    }
    "password:" {
        send "${YOUR_PASSWORD}\n"
        expect "~]"
        send "ssh ${YOUR_HOST_2}"
        expect {
            "(yes/no)?" {
                send "yes\n"
                expect "password:"
                send "${YOUR_PASSWD_2}"
            }
            "password:" {
                send "${YOUR_PASSWD_2}"
            }
        }
    }
 }