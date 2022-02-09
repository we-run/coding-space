
#!/usr/bin/expect -f
spawn ssh ${YOUR_NAME}@${YOUR_HOST}
set timeout 30
match_max 100000
expect {
    "(yes/no)?" {
        send "yes\n"
        expect "password:"
        send "${YOUR_PASSWORD}\n"
    }
    "password:" {
        send "${YOUR_PASSWORD}\n"
    }
 }