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

echo '
$# 传递到脚本参数的个数
$* 一个单字符串显示出所有的参数
$$ 脚本运行的当前进程ID号
$! 后台运行的最后一个进程ID号
$@ 脚本参数列表 同 $* 一样
$- 显示Shell当前选项，与set命令功能相同
$? 命令的退出状态，0表示没有错误
'



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
echo "hello, ${my_name}"
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


## 字符串替换
tmp="My_name_is_daqiang 123"
echo ${tmp/_/ /}
echo ${tmp/23/bb} //abc1bb42341 #替换一次
echo ${tmp//23/bb} //abc1bb4bb41 #双斜杠替换所有匹配
echo ${tmp/#abc/bb} //bb12342341 #以什么开头来匹配，和php中的^有点像

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

for i in {2..254}
do
    echo '172.16.10.'$i
    curl --location --max-time 1 --request GET 'http://172.16.10.'$i
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
PS1="[`basename \`dirname \"$CUR_FILE_ABS_PATH\"\``] $0"

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
wc -l <<EOF
    我们都是为了一个目标而奋斗
    并没有彼此贫富之分
EOF


## 12 > 文件包含， 引入其他脚本文件
# . file 或者 sourcefile



## 13 > 判断文件和目录存在
echo '
### -z [-z string] “string”的长度为零则为真 
### -o 或运算
### -a 与运算
### -n 判空操作 [-n string] or [string] “string”的长度为非零non-zero则为真 
### -x 判断是否存在并且具有可执行权限
### -d 判断目录
### -f 判断文件是否存在，可以正则
### -e 判断对象是否存在
### -s 判断对象存在，并且长度为0
### -nt 判断file1比file2新 与 -ot相反
### -L 判断符号链接是否存在
### -h 判断软连接是否存在
# if [[ ! -x "$my_file" ]]; then
#     mkdir my_file
# fi
# rm -rf my_file

-eq 等于,如:if [ "$a" -eq "$b" ] 
-ne 不等于,如:if [ "$a" -ne "$b" ] 
-gt 大于,如:if [ "$a" -gt "$b" ] 
-ge 大于等于,如:if [ "$a" -ge "$b" ] 
-lt 小于,如:if [ "$a" -lt "$b" ] 
-le 小于等于,如:if [ "$a" -le "$b" ] 
<   小于(需要双括号),如:(("$a" < "$b")) 
<=  小于等于(需要双括号),如:(("$a" <= "$b")) 
>   大于(需要双括号),如:(("$a" > "$b")) 
>=  大于等于(需要双括号),如:(("$a" >= "$b"))

= 等于,如:if [ "$a" = "$b" ] 
== 等于,如:if [ "$a" == "$b" ],与=等价 

[[ $a == z* ]]   # 如果$a以"z"开头(模式匹配)那么将为true 
[[ $a == "z*" ]] # 如果$a等于z*(字符匹配),那么结果为true 
 
[ $a == z* ]     # File globbing 和word splitting将会发生 
[ "$a" == "z*" ] # 如果$a等于z*(字符匹配),那么结果为true 
'
if [ 'x' == 'x'$1 ]; then
    echo "Usage $0 search_dir"
    exit 1
fi


## 14 > 后缀判断
# --------------------------------------------------------------------------- #
# 获取文件名后缀
# Parameter1: 文件名
# output: Yes
# return: None
# --------------------------------------------------------------------------- #
function FileSuffix() {
    local filename="$1"
    if [ -n "$filename" ]; then
        echo "${filename##*.}"
    fi
}

# --------------------------------------------------------------------------- #
# 获取文件名前缀
# Parameter1: 文件名
# output: Yes
# return: None
# --------------------------------------------------------------------------- #
function FilePrefix() {
    local filename="$1"
    if [ -n "$filename" ]; then
        echo "${filename%.*}"
    fi
}

# --------------------------------------------------------------------------- #
# 判断文件后缀是否是指定后缀
# Parameter1: 文件名
# parameter2: 后缀名
# output: None
# return: 0: 表示文件后缀是指定后缀；1: 表示文件后缀不是指定后缀
# --------------------------------------------------------------------------- #
function IsSuffix() {
    local filename="$1"
    local suffix="$2"
    if [ "$(FileSuffix ${filename})" = "$suffix" ]; then
        return 0
    else
        return 1
    fi
}

file="demo.txt"

IsSuffix ${file} "txt"
ret=$?

if [  $ret -eq 0 ]; then
    echo "the suffix of the ${file} is txt"
fi



## 15. 通过 ${?:-?} 进行容错兜底操作
echo ${HOSTS:-"aa"}
echo ${HOST:-"aa"}


## 16. 切分字符串成数组
IFS=', ' read -r -a array <<< "$string"
IFS=',' read -r -a params <<< "$l"

## 17. 后台任务
fg、bg、jobs、&、nohup、ctrl+z、ctrl+c 命令
一、&
加在一个命令的最后，可以把这个命令放到后台执行，如
watch  -n 10 sh  test.sh  &  #每10s在后台执行一次test.sh脚本
二、ctrl + z
可以将一个正在前台执行的命令放到后台，并且处于暂停状态。
三、jobs
查看当前有多少在后台运行的命令
jobs -l选项可显示所有任务的PID，jobs的状态可以是running, stopped, Terminated。但是如果任务被终止了（kill），shell 从当前的shell环境已知的列表中删除任务的进程标识。
四、fg
将后台中的命令调至前台继续运行。如果后台中有多个命令，可以用fg %jobnumber（是命令编号，不是进程号）将选中的命令调出。
五、bg
将一个在后台暂停的命令，变成在后台继续执行。如果后台中有多个命令，可以用bg %jobnumber将选中的命令调出。
六、kill
法子1：通过jobs命令查看job号（假设为num），然后执行kill %num
法子2：通过ps命令查看job的进程号（PID，假设为pid），然后执行kill pid
前台进程的终止：Ctrl+c
七、nohup
如果让程序始终在后台执行，即使关闭当前的终端也执行（之前的&做不到），这时候需要nohup。该命令可以在你退出帐户/关闭终端之后继续运行相应的进程。关闭中断后，在另一个终端jobs已经无法看到后台跑得程序了，此时利用ps（进程查看命令）
