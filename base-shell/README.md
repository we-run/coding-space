### 关于对 Shell 的理解

1. 初入Linux时，就对Shell这种东西很困惑，因为看不到他的藏身之处，又觉得它无处不在；
2. 后来，看书学习到，shell是一种访问操作系统内核的形式；
3. 再后来，知道其他调用和方式操作系统内容的方式，还有`system call`
4. 对比发现，哦，原来shell真正的含义就是：参数输入->传入目标程序->系统调用->数据处理->输出整个过程的入口形式；
5. 题外话是，初入门时，总觉得`shell` 和 `terminal`，是一回事，现在想想挺搞笑的。。。介绍 `tty` 和 `console`的[传送门>>](https://www.zhihu.com/question/21711307) , [历史遗迹](https://linux.cn/article-14093-1.html#:~:text=%E2%80%9CTTY%E2%80%9D%20%E8%83%8C%E5%90%8E%E7%9A%84%E5%8E%86%E5%8F%B2,%E5%8F%AF%E4%BB%A5%E8%BD%BB%E6%9D%BE%E5%9C%B0%E4%BC%A0%E9%80%92%E6%B6%88%E6%81%AF%E3%80%82)

### 从何而来
1. 每天在用，但是不清不楚，誓要搞清楚这朵乌云
2. 


### 目录说明
1. 以Linux的常用shell命令区分目录；
2. 其中`codes`目录下（git忽略,找作者索要），有下载其他三方的shell源码，进行参考学习
3. 使用`curl -o- https://raw.githubusercontent.com/we-run/coding-space/master/base-shell/ip_get.sh | bash` 




### 内置变量使用

| 表达式          | 含义                                                        |
| :-------------- | :---------------------------------------------------------- |
| ${var}          | 变量var的值, 与$var相同                                     |
|                 |                                                             |
| ${var-DEFAULT}  | 如果var没有被声明, 那么就以$DEFAULT作为其值 *               |
| ${var:-DEFAULT} | 如果var没有被声明, 或者其值为空, 那么就以$DEFAULT作为其值 * |
|                 |                                                             |
| ${var=DEFAULT}  | 如果var没有被声明, 那么就以$DEFAULT作为其值 *               |
| ${var:=DEFAULT} | 如果var没有被声明, 或者其值为空, 那么就以$DEFAULT作为其值 * |
|                 |                                                             |
| ${var+OTHER}    | 如果var声明了, 那么其值就是$OTHER, 否则就为null字符串       |
| ${var:+OTHER}   | 如果var被设置了, 那么其值就是$OTHER, 否则就为null字符串     |
|                 |                                                             |
| ${var?ERR_MSG}  | 如果var没被声明, 那么就打印$ERR_MSG *                       |
| ${var:?ERR_MSG} | 如果var没被设置, 那么就打印$ERR_MSG *                       |
|                 |                                                             |
| ${!varprefix*}  | 匹配之前所有以varprefix开头进行声明的变量                   |
| ${!varprefix@}  | 匹配之前所有以varprefix开头进行声明的变量                   |



### 字符串操作
| 表达式                           | 含义                                                         |
| :------------------------------- | :----------------------------------------------------------- |
| ${#string}                       | $string的长度                                                |
|                                  |                                                              |
| ${string:position}               | 在$string中, 从位置$position开始提取子串                     |
| ${string:position:length}        | 在$string中, 从位置$position开始提取长度为$length的子串      |
|                                  |                                                              |
| ${string#substring}              | 从变量$string的开头, 删除最短匹配$substring的子串            |
| ${string##substring}             | 从变量$string的开头, 删除最长匹配$substring的子串            |
| ${string%substring}              | 从变量$string的结尾, 删除最短匹配$substring的子串            |
| ${string%%substring}             | 从变量$string的结尾, 删除最长匹配$substring的子串            |
|                                  |                                                              |
| ${string/substring/replacement}  | 使用$replacement, 来代替第一个匹配的$substring               |
| ${string//substring/replacement} | 使用$replacement, 代替*所有*匹配的$substring                 |
| ${string/#substring/replacement} | 如果$string的*前缀*匹配$substring, 那么就用$replacement来代替匹配到的$substring |
| ${string/%substring/replacement} | 如果$string的*后缀*匹配$substring, 那么就用$replacement来代替匹配到的$substring |


