
#!/bin/sh

## -F 文件类型 ， / 表示目录， @ 表示文件的符号链接， * 表示可执行文件
ls -F | grep "/$"

ls -al | grep "^d"
ls -al | grep "^-"