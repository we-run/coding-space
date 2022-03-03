#!/bin/sh


### 流编辑 和 交互式文本编辑器 vim的模式不同，需要设定一组规则，对文本进行操作


#### 特点：分为 匹配部分 和 动作部分 ，其中没有匹配时，执行动作在匹配条件中作为前缀,有匹配条件时，做后缀，最后是内容
####### 1. 一行一行的读取，所以如果跨行匹配和编辑，则需要特殊处理；
####### 2. 根据命令规则修改数据，默认不修改源文件，而是复制到缓冲区
####### 3. 将执行结果输出

####### -n 选项需要用p动作进行输出，否则不会输出保持静默
# :  # label
# =  # line_number
# a  # append_text_to_stdout_after_flush
# b  # branch_unconditional             
# c  # range_change                     
# d  # pattern_delete_top/cycle          
# D  # pattern_ltrunc(line+nl)_top/cycle 
# g  # pattern=hold                      
# G  # pattern+=nl+hold                  
# h  # hold=pattern                      
# H  # hold+=nl+pattern                  
# i  # insert_text_to_stdout_now         
# l  # pattern_list                       
# n  # pattern_flush=nextline_continue   
# N  # pattern+=nl+nextline              
# p  # pattern_print                     
# P  # pattern_first_line_print          
# q  # flush_quit                        
# r  # append_file_to_stdout_after_flush 
# s  # substitute                                          
# t  # branch_on_substitute              
# w  # append_pattern_to_file_now         
# x  # swap_pattern_and_hold             
# y  # transform_chars 

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


cat > $WORK_DIR/data3.txt <<EOF
On Tuesday, the Linux 
EOF


## 14> 多行替换
cat > $WORK_DIR/data11.txt <<EOF
有文本 test.txt
123
456kaishi33333
ddd
jieshu66666
ddd
444444
EOF
sed -e "{:begin;  /jieshu/! { $! { N; b begin }; }; s/kaishi.*jieshu/COMMENT/; };" $WORK_DIR/data11.txt
# :begin，这是一个标号，man中叫做label，也就是跳转标记，供b和t命令用，本例中使用了b命令。
# /jieshu/!是要替换内容的结束标记，带上!就是说当一行处理完毕之后，如果没有发现结束标记就继续，jieshu就是你要结束的搜索词
# $!，$在正则中表示字符串结尾，在sed中代表文件的最后一行，本句和上一句结合起来的意思就是：如果在本行没有发现结束标记，并且当前扫描过的行并不是文件的最后一行。
# N;，把下一行的内容追加（append）到缓冲区（pattern）之后，在我们的例子中，在处理456kaishi33333这一行的内容时，就会执行到这里，然后把下一行的内容ddd，依次类推把
# jieshu66666一起放入缓冲区，相当于“合并”成了一行（sed的缓冲区中默认都只会包含一行的内容）。
# b begin，由于仍然没有找到结束标记jieshu（注意上一条说的缓冲区还没有被处理），所以在这里跳回到标号begin，重新开始命令。如果开始和结束标记之间间隔了多行，那么就会有多次跳转发生。
# s/kaishi.*jieshu/COMMENT/;，终于，/jieshu/!不再匹配成功，也就是我们已经找到了结束标记，那么用s命令来进行替换。如果开始和结束标记在一行的话，就会越过上面那些复杂的处理，直接执行到这里了

