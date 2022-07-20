#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
cd "$(
    cd "$(dirname "$0")" || exit
    pwd
)" || exit
WORK_DIR_ABS_PATH="$(cd "$(dirname "$0")";pwd)"
PROJECT_PATH=$(dirname $(dirname "$WORK_DIR_ABS_PATH"))

echo $PROJECT_PATH
rm -rf "${PROJECT_PATH}/dist/"
mkdir -p "${PROJECT_PATH}/dist"
cd "$PROJECT_PATH/resource/"

xattr -dr com.apple.quarantine v2ray-linux-64
tar zcvf v2ray-linux-64.tar.gz v2ray-linux-64
mv v2ray-linux-64.tar.gz "${PROJECT_PATH}/dist"
