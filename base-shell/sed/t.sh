#!/bin/sh


### 流编辑 和 交互式文本编辑器 vim的模式不同，需要设定一组规则，对文本进行操作


#### 特点：分为 匹配部分 和 动作部分 ，其中没有匹配时，执行动作在匹配条件中作为前缀,有匹配条件时，做后缀，最后是内容
####### 1. 一行一行的读取，所以如果跨行匹配和编辑，则需要特殊处理；
####### 2. 根据命令规则修改数据，默认不修改源文件，而是复制到缓冲区
####### 3. 将执行结果输出

####### -n 选项需要用p动作进行输出，否则不会输出保持静默

WORK_DIR=$(cd $(dirname $0);pwd)

cat > $WORK_DIR/test.txt <<EOF
HELLO LINUX!  
Linux is a free unix-type opterating system.  
This is a linux testfile!  
Linux test
EOF

# WORK_DIR=$(dirname $$WORK_DIR)


## 1 > 追加一行
sed -e 4a\newline "$(dirname $WORK_DIR)/test1.txt"

## 2 > 
sed -e 4a\newline "$WORK_DIR/test.txt"

## 3 > 以行为单位的新增和删除
echo "==== 删除行"
nl $WORK_DIR/test.txt | sed '2,4d'
nl $WORK_DIR/test.txt | sed '2,$d'
nl $WORK_DIR/test.txt | sed '2i \\tdrink tea'

## 4 > 以行为单位替换
echo "==== 替换行"
nl $WORK_DIR/test.txt | sed '2c \\tdrink tea'

## 5 > 显示出某些行
echo "==== 显示行"
nl $WORK_DIR/test.txt | sed -n '2,3p'


## 6 > 数据搜索显示
echo "==== 搜索，显示行"
nl $WORK_DIR/test.txt | sed '/Linux/p'

## 7 > 数据搜索后，执行命令 , q 表示退出
echo "==== 搜索，执行操作后退出"
nl $WORK_DIR/test.txt | sed -n "/Linux/{s/is/is't/;p;q}"


## 8> 管道连续对一行进行操作
source "$(dirname $WORK_DIR)/os/t.sh"
echo "==== 管道连续对一行进行操作"
is_my_macos
if [[ $? -eq 1 ]]; then 
    echo 'Darwin'
    ifconfig en0 | grep 'inet ' | sed 's/^.*inet //g' | sed 's/netmask.*$//g'
elif [[ `uname` == 'Linux' ]]; then
    echo 'Linux'
fi

## 9> 多点编辑
echo "=== 多点编辑"
cat /etc/passwd | sed -e '1,9d' -e 's/bash/blueshell/'

## 10> 直接修改文件内容
echo "==== 直接修改文件内容"
cat > $WORK_DIR/reg_express.txt <<EOF
runoob.
google.
taobao.
facebook.
zhihu-
weibo-
EOF
cat $WORK_DIR/reg_express.txt

sed -i 's/\.$/\!/g' $WORK_DIR/reg_express.txt

sed -i '$a # This is a test' $WORK_DIR/reg_express.txt


## 11 > 回顾打印
echo "==== 回顾打印"

cat > $WORK_DIR/data6.txt <<EOF
This is line number 1.
This is line number 2.
This is line number 3.
This is line number 4.
This is line number 5.
This is line number 6.
This is line number 7.
EOF
sed -n '2,3p' $WORK_DIR/data6.txt
echo "--- 回顾1 ---"
## 脚本部分： p 有关于打印原始行，s命令用来替换文本并打印出结果
sed -n '/3/{
    p
    s/line/test/p
}' $WORK_DIR/data6.txt

echo '--- 回顾-行号 ---'
sed -n '/number 4/{
    =
    p
}' $WORK_DIR/data6.txt

echo '--- l 列出行 ---'
sed -n 'l' $WORK_DIR/data6.txt


## 12 > 写入文件
# tmp=${WORK_DIR}/test.txt
# sed -n '1,2w test.txt' $WORK_DIR/data6.txt


## 13> 多行文本操作
cat > $WORK_DIR/data1.txt <<EOF
This is the header line.
This is a data line.

This is the last line.
EOF
echo '==== 多行文本操作' 
sed '/^$/d' $WORK_DIR/data6.txt
# n命令将header匹配到的行，向下移动一样执行了d动作
sed '/header/{n ; d}' $WORK_DIR/data1.txt

echo '--- N 命令 ---'
cat > $WORK_DIR/data2.txt <<EOF
This is the header file.
This is the first data line.
This is the second data line.
This is the last line.
EOF
sed '/first/{ N ; s/\n/ / }' $WORK_DIR/data2.txt


cat > data3.txt <<EOF
On Tuesday, the Linux 
EOF
