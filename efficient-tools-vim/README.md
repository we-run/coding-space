### Vim 技巧

1.  另起一行可以回车，也可以esc + o
2.   b 命令移动到单词开头
3.  aw 表示一个完整单词，daw 删除整个单词
4.  *nn 会自动遍历所有选中的内容回到原位置
5.  * 查找目标内容后，执行 :set hls 看到高亮
6. <ctrl-r>0 召唤寄存器中的内容
8. gv 重选前一次的选中区域
9. ｏ 切换选中区域的边界 头尾,o 在普通模式还可以直接进入插入模式并一空行
10. it 这个motion是可以定位到标签中间的文本内容，例如vit 即可选中标签中间的内容
    1. U 切换大写字母
11. set shiftwidth  softtabstop expandtab
12. 字符可视模式，可以根据关键字符直接跳转选中到目标，如ctrl-v 后 jje 即跳转选中到单词结束位置
13. 插入模式下，<ctrl-r>= 会访问表达式寄存器，命令行模式也激活
14. Ex命名 : edit 从磁盘获取文件覆盖到当前缓冲区，  :write 保存
15. :h ex-cmd-index 查看所有Ex命令
16. @: 重复Ex命令
17. <ctrl-r><ctrl-w> 复制内容到Ex
18.  q: 进入命令行窗口
19.  大写  J 的意思 ？ join 链接两行
20.  ! 前缀运行外部程序
21.  Ctrl+z 挂起vim， jobs查看作业列表，fg 唤醒到前台
22. yi"$p 
23. vim *.txt 
24.  :next :previous 
25.  :args 查看当前打开的文件列表
26.  :source batch.vim 批量执行Ex命令
27.  :argdo  source batch.vim 批量执行多文件（p72）
28.   


多文件管理
一个文件一个对应到内存的缓冲区
1. :write :update :saveas  直接操作文件，而不是缓冲区（k37）
2.  :ls 直接显示缓冲区列表
3.   :bnext 切换下一个缓冲区。:bfirst   :blast 
4.   <ctrl-^> 轮换缓冲区文件 井号表示轮换文件
5.   :buffer N/pattern 快速切换文件
6.  :bufdo 缓冲区所有文件执行操作
7.  删除缓冲区 :bdelete n1 n2 n3 或 :n,m bdelete 
8. Go 到文件底部下插一行
9.  参数列表 对缓冲区分组 
10.  :args *.*   添加文件到缓冲区
11.  :args **/*.js
12.  反引号结构指定文件 :args ‘ chapters'
13.  隐藏缓冲区
14.  :wall  :qall 
15.  <ctrl-w>s   水平分割  <ctrl-w>v 垂直分割
16.   <ctrl-w>w 循环切换窗口
17.  多标签页创建 :tabnew :edit 
18.  缓冲区去到独立标签页 ctrl-w + T


目录管理



1. Ok
￼



看第 14 章和第 15章。
表5-1 操作缓冲区文本的 Ex 命令
命令
[range]delete [x]
[range]yank [x]
用途
删除指定范围内的行[到寄存器×中]
复制指定范围的行[到寄存器x中〕
[line]put [x]
在指定行后粘贴容存器×中的内容
:[range]copy (address}
把指定范围内的行拷贝到 {address} 指定的行之下
:[range]move (address}
把指定范围内的行移动到 {add ress} 指定的行之下
:[range]join
连接指定范围内的行
[range]normal {commands]
对指定范围内的每一行执行普通模式命令 {commands}
[range]substitute/(pattern}/
{string}/[flags]
:[range]global/(pattern}/[cmd]
把指定范围内出现{pattern}的地方替换为{string}
对指定范围内匹配fpattern}的所有行执行 Ex 命令
{cmd}.


￼
