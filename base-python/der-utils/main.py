# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
#!/usr/bin/env python3
#__*__coding:utf8__*__
# import MySQLdb
import os
import re
import sys
import time

import pytz
import arrow

tz = pytz.timezone("Asia/Shanghai")

def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press ⌘F8 to toggle the breakpoint.


# s = "ABACABABAB"
#         #01234567
# p =     "ABCABCAC"
          #
s = "BAAAAAAAAA"
p = "ABABAC"
def buildNxt():
    nxt = []
    nxt.append(0)
    x = 1
    now = 0
    # x = 1>2>3->4->5->6 7
    # now 0 0 0->1->2
    while x < len(p):
        if p[now] == p[x]:
            now += 1
            x += 1
            nxt.append(now)
        elif now:
            now = nxt[now - 1]
        else:
            nxt.append(0)
            x += 1
    return nxt


def search():
    nxt = buildNxt()
    print(''.join(map(str, nxt)))
    tar = 0
    pos = 0
    while tar < len(s):
        if s[tar] == p[pos]:
            tar += 1
            pos += 1
        elif pos:
            print("{} +++> {}".format(tar, pos))
            pos = nxt[pos - 1]
            print("{} ---> {}\n".format(tar, pos))
        else:
            print("{} ===> {}".format(tar, pos))
            tar += 1
            print("{} >>>> {}\n".format(tar, pos))

        if pos == len(p):
            print(tar - pos)
            pos = nxt[pos - 1]



#db = MySQLdb.connect(host='localhost',user='root',passwd='123456',db='testdb')
#access.log :log style is ===>
'''
114.250.90.86  - - [09/Oct/2017:10:48:21 +0800] "GET /p_w_picpaths///book/201709/9787503541216/Cover/9787503541216.jpg HTTP/1.1" 304 0 "http://www.dyz100.net/" "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36" "0.001" "-" "-" "-""10.1.12.201:9092" "304" "0" "0.001"
121.89.208.237 - - [28/Nov/2022:07:43:01 +0800] "GET /css/app.795ac956.css HTTP/1.1" 200 38459 "https://xinzhili.cn/" "Mozilla/5.0 (linux; u; android 9; zh-cn; v1816a build/pkq1.180819.001) applewebkit/537.36 (khtml, like gecko) version/4.0 chrome/57"
'''
def domainName():
    dn_dict = {}
    patten = '(http|https)://[a-z]+.[a-z0-9]+.[a-zA-Z]+'
    g = os.walk("./logs")
    min_time = sys.maxsize
    for path, dirs, files in g:
        for f in files:
            if f.startswith("access"):
                print(os.path.join(path, f))
                log_file = open(os.path.join(path, f), 'r')
                for line in log_file:
                    dt = line.split()
                    dt_str = dt[3] + " " + dt[4]
                    # print(dt_str[1:len(dt_str) - 1])
                    ttt = arrow.get(dt_str[1:len(dt_str) - 1], "DD/MMM/YYYY:HH:mm:ss Z").int_timestamp
                    # print(ttt)
                    min_time = min(min_time, ttt)
                    Domain_Name = re.search(patten, line)
                    if Domain_Name:
                        dn = Domain_Name.group(0)
                        if dn not in dn_dict:
                            dn_dict[dn] = 1
                        else:
                            dn_dict[dn] += 1
    # 使用内建函数sorted（）排序
    # sorted(dict.items(), key=lambda e:e[1], reverse=True)
    dn_ranking = sorted(dn_dict.items(), key=lambda item: item[1], reverse=True)
    print(min_time)
    return dn_ranking


def dispalydomainName():
    '''print top 10 ranking for download '''
    dn_ranking = domainName()
    print("下载量排名前10的域名列表为:")
    for item in dn_ranking[:11]:
        print("域名: %s ===> 下载次数: %d" % (item[0], item[1]))


# def insert():
#     db = MySQLdb.connect(host='localhost',user='root',passwd='123456',db='testdb')
#     cursor = db.cursor()
#     cursor.execute('drop table if exists ranking')
#     sql = 'create table ranking (id int(10) not null primary key auto_increment, domainName varchar(100), download_times int(100))'
#     cursor.execute(sql)
#     dn_ranking = domainName()
#     for item in dn_ranking:
#         sql = '''insert into ranking (domainName,download_times) values ('%s',%d)''' %(item[0],item[1])
#         cursor.execute(sql)
#     # sql = '''insert into ranking (domainName,download_times) values ('wpt',2)'''
#     try:
#         #执行sql语句
#         cursor.execute(sql)
#         db.commit()
#     except:
#         db.rollback()
#     db.close()



# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    # search()
    dispalydomainName()
    # a = "28/Nov/2022:07:43:01 +0800"
    # tt = arrow.get(a, "DD/MMM/YYYY:HH:mm:ss Z").int_timestamp
    # time.mktime()
    # print(time.strptime(a, "%d/%m/%Y:%H:%M:%S %z"))
    # print(tt)
