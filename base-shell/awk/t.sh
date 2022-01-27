#!/bin/sh

# awk [opts] 'script' var=value files
# awk [opts] -f scripfile var=value file

WORK_DIR_ABS_PATH="$(cd "$(dirname "$0")";pwd)"

cat > $WORK_DIR_ABS_PATH/log.txt <<EOF
2 this is a test
3 Are you like awk
This\'s a test
10 There are orange,apple,mongo
EOF

# 默认以空格或tab为分隔符
awk '{print $1,$4}' $WORK_DIR_ABS_PATH/log.txt
printf "==== %s\n" 分隔符
## 设定分隔符
awk -F, '{print $1,$2}' $WORK_DIR_ABS_PATH/log.txt

## 使用内建变量
awk 'BEGIN{FS=",} {print $1,$2}' $WORK_DIR_ABS_PATH/log.txt
echo "==== 多次分割"
## 使用多个分隔符 , 先试用空格分割， 然后对分割结果再使用,分割
awk -F '[ ,]' '{print $1,$2,$5}' $WORK_DIR_ABS_PATH/log.txt

## 设置变量 awk -v
echo "==== 内部变量"
awk -va=1 '{print $1,$1+a}' $WORK_DIR_ABS_PATH/log.txt
awk -va=1 -vb=s '{print $1,$1+a,$1b}' $WORK_DIR_ABS_PATH/log.txt

## 外挂脚本
echo "==== 外挂脚本"
awk -f $WORK_DIR_ABS_PATH/cal.awk $WORK_DIR_ABS_PATH/log.txt


## 运算过程
echo "==== 内置运算"
awk '$1>2' $WORK_DIR_ABS_PATH/log.txt
awk '$1>2 && $2="Are" {print $1,$2}' $WORK_DIR_ABS_PATH/log.txt

## 内建变量
echo "==== 内建变量"

awk '{print $NF}' $WORK_DIR_ABS_PATH/log.txt
echo '--> 字段数目'
awk '{print $NF}' $WORK_DIR_ABS_PATH/log.txt
echo "--> 行号"
awk '{print NR}' $WORK_DIR_ABS_PATH/log.txt # 行号

## 使用正则
echo "==== 使用正则"
awk '$2 ~ /th/ {print $2, $4}' $WORK_DIR_ABS_PATH/log.txt
echo '-->忽略大小写'
awk 'BEGIN{IGNORECASE=1} /this/' $WORK_DIR_ABS_PATH/log.txt


## 自己发挥
echo "==== 综合运行"
ls -l | grep "^d" | awk '{print $NF}'