
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