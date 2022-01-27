#!/bin/sh

## 0> # 多行注释
:<<EOF
这里都是注释内容...
这里都是注释内容...
这里都是注释内容...
EOF

# :<<'
# 其他符号闭合也可以注释...
# 其他符号闭合也可以注释...
# 其他符号闭合也可以注释...
# '

:<<!
en ，是的
en ，是的
en ，是的
!

## 1> 变量使用方式
## var define and using
echo '============ var defined ============'
my_name="daqiang"
echo ${my_name}

# 只读变量一经设定，不能再改
echo '变量只读 : '
my_url="http://daqiang.me"
readonly my_url
# my_url="http://baidu.com"  # error

# 移除变量，不再使用
echo '移除变量 : '
unset my_name
echo $my_name

# 变量类型 ： 局部、环境、shell变量
my_name='damiao'
### 字符串 ：
##### 单引号时，其中变量无效，内部不能转义单引号
##### 双引号时， 可以变量拼接，可以有转义字符
##### 拼接字符串
echo "hello, "${my_name}""
echo 'hello, single '${my_name}'!'
echo "\"it is bad!"

echo "get string length : ${#my_name}"
echo "get sub str : ${my_name:1:3}"
str="runoob is a great site"

# 反引号执行命令，并且输出 ， 如：查找 i 或者 o 的位置
echo `expr index "$str" io` # mac os 有问题

### 1.1> 字符串操作 - 后缀判断 - ## 符号是贪婪操作符，从左到右匹配，知道最右边的.，移除包含.号在内的左边的内容
##### 多加了x，是为了防止字符串为空时报错
echo "字符串 - 后缀操作"
the_suffix="GENG.js"
if [[ "${the_suffix##*.}x" = "js"x ]];then 
    echo 'do somting1'
fi

the_suffix="GENG WU"
if [[ "${the_suffix##* }x" = "WU"x ]];then 
    echo 'do somting2'
fi

## 2> 数组使用方式
# 数组，bash支持一维数组，不支持多维
array_name=(v0 v1 v2 v3)
array_name[10]=v10

echo "数组下标访问 : ${array_name[3]}"
echo "@符号，获取所有元素列表 : ${array_name[@]}"

echo "数组长度： ${#array_name[@]}"
echo "数组长度： ${#array_name[*]}"
echo "单元素长度: ${#array_name[10]}"
echo "数组索引列表 ${!array_name[@]}"

## 3> 循环使用方式
echo '============ for loop ============'
echo "current path : $"
for f in `ls -ld ./`; do
    echo "for loop - currren dir files : ${f}"
done

for str in Ada Coffe Action Java; do
    echo " for loop - This is a kill (1): $str en !"
    echo " for loop - This is a skill (2): ${str}"
done 

int=1
while(( $int<=5 ))
do
    echo "while loop count ... ${int}"
    let "int++" # let 用于执行一个或多个表达式,变量计算中不需要加上 $ 来表示变量
    # int=`expr $int + 1`
done

while read FILM
do 
    echo "YES! $FILM DONE!"
    if [ $FILM -eq 1 ]
    then
        break
    fi
done 

## 4> 参数传递方式 , 
### $n 的形式获取给脚本传入的参数
echo $0
echo "当前工作目录 ： `pwd`"
echo "当前文件父级目录: `dirname $0`"
CUR_FILE_ABS_PATH=$(cd "$(dirname "$0")";pwd)
# CUR_FILE_ABS_PATH=$(dirname $(readlink -f "$0"))  # mac os 有问题

echo $CUR_FILE_ABS_PATH
# sh "$(pwd)/ip_get.sh" 172.16.10.57


## 5> 当前活跃目录和上级目录
echo "获取目录路径 ... "
echo " cur dir : $(pwd)"
p_dir=$(dirname $(pwd))



## 6> 关系判断 : 只支持数值
a=10
b=20
if [ $a -eq $b ] 
then 
    echo "="
else
    echo "!="
fi

## 布尔运算符号 : ! -o -a
if [  $a -lt 100 -a $b -gt 15 ] 
then
    echo "suc"
fi



## 7> 读入标准输入 
read name
echo "$name is your input ... "


## 8> printf 格式化输出 : %s %c %d %f 都是格式占位符
printf "hello , Shell \n"
printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg
printf "%-10s %-8s %-4.2f\n" 你  男  66.909
printf "%-10s %-8s %-4.2f\n" 我  女  77.89
printf "%-10s %-8s %-4.2f\n" 她   -  45.000



## 9> 多选语句
read aNum
case $aNum in 
    1) echo 'select 1'
    ;;
    2) echo 'select 2'
    ;;
    *) echo 'any one'
    ;;
esac


## 10> 函数
echo " 10 > 函数定义和使用 "
foo() {
    echo "调用一次函数..."
}
foo # 调用

fooWithReturn(){
    echo " 计算两个数字之和开始... "
    echo "第一个数字是 ？ "
    read a
    echo "第二个数字是 ?"
    read b
    return $(($a + $b))
}
fooWithReturn
echo "数字求和 : $? !"


fooWithParam(){
    echo "第一个参数 : $1"
    echo "第二个参数 : $2"
    echo "第三个参数 : $3"
    echo "第十个参数 : ${10}"
    echo "参数zognshu  : $#"
    echo "参数清单 : $*"
}
fooWithParam 1 2 3 4 5 6 7 8 9 9 10


## 11 > 输入输出重定向
### n >& m 将输出文件文件m和n合并 
### n <& m 将输入文件m和n合并
### << tag 将开始标记tag和结束标记tag之间的内容作为输入

who > users
cat users
wc -l users
wc -l < users
# cmd < infile > outfile # 从文件infile读取， 然后出书到outfile中
# cmd > file 2>&1 # 标准输出和标准错误合并后从定向到file
# cmd < f1 > f2 # 标准输入定向到f1, 标准输出定向到f2

# Here Document 重定向
# cmd << delimiter
# doc
# delimiter
wc -l << EOF
    我们都是为了一个目标而奋斗
    并没有彼此贫富之分
EOF


## 12 > 文件包含， 引入其他脚本文件
# . file 或者 sourcefile



## 13 > 判断文件和目录存在
### -x 判断是否存在并且具有可执行权限
### -d 判断目录
### -f 判断文件 
### -e 判断对象是否存在
### -s 判断对象存在，并且长度为0
### -nt 判断file1比file2新 与 -ot相反
### -L 判断符号链接是否存在
### -h 判断软连接是否存在
# if [[ ! -x "$my_file" ]]; then
#     mkdir my_file
# fi
# rm -rf my_file
