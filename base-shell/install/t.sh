#!/bin/sh


# install 将目标文件或者目录，进行拷贝（可以设置 mode group owner ）


CUR_FILE_ABS_PATH=$(cd "$(dirname "$0")";pwd)
echo $(dirname $CUR_FILE_ABS_PATH)
install -m 644 $(dirname $CUR_FILE_ABS_PATH)/test1.txt $CUR_FILE_ABS_PATH/test_x.txt 


