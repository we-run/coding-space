#!/bin/sh


# 软连接和硬链接的区别是： 
## 有只宠物狗，一根绳子拴上，是一个硬链接，你一个，我一个，他一个，可以增加多个,所以硬链接只能是目录
## 软连接却是，只能在家里画一个这只宠物狗或者拍张照片，自己回家找个绳子栓照片去，软连接可以是文件或目录
## 另外，硬链接不能跨文件系统创建


WORK_DIR=$(cd $(dirname $0);pwd)
rm -rf $WORK_DIR/links

echo 'It is one dog ! ' > $WORK_DIR/raw.txt

SUB_DIR=$WORK_DIR/links
mkdir -p $SUB_DIR
# ### 软连接 
echo $SUB_DIR"|软连接到文件"
ln -s $WORK_DIR/raw.txt $SUB_DIR/soft_link 
ln -s $WORK_DIR/raw.txt $SUB_DIR/soft_link 


LINK_TAR_DIR=$(dirname $WORK_DIR)
LINK_TAR_DIR=$LINK_TAR_DIR/ls
echo $LINK_TAR_DIR"|软连接到目录"
rm -rf $WORK_DIR/outer
ln -s $LINK_TAR_DIR $WORK_DIR/outer

# ### 硬链接
echo $SUB_DIR"|硬连接到文件"
ln $WORK_DIR/raw.txt  $SUB_DIR/hard_link

echo $SUB_DIR"|二次硬连接软连接指向的文件"
ln $SUB_DIR/soft_link $SUB_DIR/hard_link_overlay

## 
ls -al $WORK_DIR/links
ls -al $WORK_DIR



## 查找文件对应的硬连接 , 硬链接和原文件具有相同的inode号，所以可以 find -inum 和 -samefile 参数来查询
# stat $WORK_DIR/raw.txt
# find $WORK_DIR/ -inum 


## 查找文件对应的软连接