
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




#### 安装NGINX
nginx_dir="/etc/nginx"
nginx_version="1.20.1"
openssl_version="1.1.1k"
jemalloc_version="5.2.1"
nginx_openssl_src="/usr/local/src"

#notification information
Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"
#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"
THREAD=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)

source '/etc/os-release'

judge() {
    if [[ 0 -eq $? ]]; then
        echo -e "${OK} ${GreenBG} $1 完成 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} $1 失败${Font}"
        exit 1
    fi
}

is_root() {
    if [ 0 == $UID ]; then
        echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font}"
        sleep 3
    else
        echo -e "${Error} ${RedBG} 当前用户不是root用户，请切换到root用户后重新执行脚本 ${Font}"
        exit 1
    fi
}

check_system() {
    if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Centos ${VERSION_ID} ${VERSION} ${Font}"
        INS="yum"
        elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 8 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${VERSION} ${Font}"
        INS="apt"
        $INS update
        ## 添加 Nginx apt源
        elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -ge 16 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME} ${Font}"
        INS="apt"
        rm /var/lib/dpkg/lock
        dpkg --configure -a
        rm /var/lib/apt/lists/lock
        rm /var/cache/apt/archives/lock
        $INS update
    else
        echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内，安装中断 ${Font}"
        exit 1
    fi
    
    $INS install dbus
    
    systemctl stop firewalld
    systemctl disable firewalld
    echo -e "${OK} ${GreenBG} firewalld 已关闭 ${Font}"
    
    systemctl stop ufw
    systemctl disable ufw
    echo -e "${OK} ${GreenBG} ufw 已关闭 ${Font}"
}

dependency_install() {
    ${INS} install wget git lsof -y
    
    if [[ "${ID}" == "centos" ]]; then
        ${INS} -y install crontabs
    else
        ${INS} -y install cron
    fi
    judge "安装 crontab"
    
    if [[ "${ID}" == "centos" ]]; then
        touch /var/spool/cron/root && chmod 600 /var/spool/cron/root
        systemctl start crond && systemctl enable crond
    else
        touch /var/spool/cron/crontabs/root && chmod 600 /var/spool/cron/crontabs/root
        systemctl start cron && systemctl enable cron
    fi
    judge "crontab 自启动配置 "
    
    ${INS} -y install bc
    judge "安装 bc"

    ${INS} -y install bzip2
    judge "安装 bzip2"
    
    ${INS} -y install unzip
    judge "安装 unzip"
    
    # ${INS} -y install qrencode
    # judge "安装 qrencode"
    
    ${INS} -y install curl
    judge "安装 curl"
    
    # if [[ "${ID}" == "centos" ]]; then
    #     ${INS} -y groupinstall "Development tools"
    # else
    #     ${INS} -y install build-essential
    # fi
    # judge "编译工具包 安装"
    yum install centos-release-scl scl-utils-build -y
    yum install devtoolset-10-toolchain -y
    scl enable devtoolset-10 bash
    # judge '安装 '$(gcc --version)
    echo "source /opt/rh/devtoolset-10/enable" >>/etc/profile
    
    if [[ "${ID}" == "centos" ]]; then
        ${INS} -y install pcre pcre-devel zlib-devel epel-release
    else
        ${INS} -y install libpcre3 libpcre3-dev zlib1g-dev dbus
    fi
    
    # 系统熵池扩大
    ${INS} -y install rng-tools
    judge "rng-tools 安装"
    
    ${INS} -y install haveged
    judge "haveged 安装"
    
    sed -i -r '/^HRNGDEVICE/d;/#HRNGDEVICE=\/dev\/null/a HRNGDEVICE=/dev/urandom' /etc/default/rng-tools
    
    if [[ "${ID}" == "centos" ]]; then
        systemctl start rngd && systemctl enable rngd
        judge "rng-tools 启动"
        systemctl start haveged && systemctl enable haveged
        judge "haveged 启动"
    else
        systemctl start rng-tools && systemctl enable rng-tools
        judge "rng-tools 启动"
        systemctl start haveged && systemctl enable haveged
        judge "haveged 启动"
    fi
    
    mkdir -p /usr/local/bin >/dev/null 2>&1
}

nginx_install() {
    if [[ -d "/etc/nginx" ]];then
        rm -rf /etc/nginx
    fi

    wget -nc --no-check-certificate http://nginx.org/download/nginx-${nginx_version}.tar.gz -P ${nginx_openssl_src}
    judge "Nginx 下载"
    wget -nc --no-check-certificate https://www.openssl.org/source/openssl-${openssl_version}.tar.gz -P ${nginx_openssl_src}
    judge "openssl 下载"
    wget -nc --no-check-certificate https://github.com/jemalloc/jemalloc/releases/download/${jemalloc_version}/jemalloc-${jemalloc_version}.tar.bz2 -P ${nginx_openssl_src}
    judge "jemalloc 下载"

    cd ${nginx_openssl_src} || exit
    [[ -d "headers-more-nginx-module" ]] && rm -rf headers-more-nginx-module
    git clone https://github.com/openresty/headers-more-nginx-module.git
    judge "headers-more-nginx-module 下载"

    [[ -d nginx-"$nginx_version" ]] && rm -rf nginx-"$nginx_version"
    tar -zxvf nginx-"$nginx_version".tar.gz

    [[ -d openssl-"$openssl_version" ]] && rm -rf openssl-"$openssl_version"
    tar -zxvf openssl-"$openssl_version".tar.gz

    [[ -d jemalloc-"${jemalloc_version}" ]] && rm -rf jemalloc-"${jemalloc_version}"
    tar -xvf jemalloc-"${jemalloc_version}".tar.bz2

    [[ -d "$nginx_dir" ]] && rm -rf ${nginx_dir}

    echo -e "${OK} ${GreenBG} 即将开始编译安装 jemalloc ${Font}"
    sleep 2

    cd jemalloc-${jemalloc_version} || exit
    ./configure
    judge "编译检查"
    make -j "${THREAD}" && make install
    judge "jemalloc 编译安装"
    echo '/usr/local/lib' >/etc/ld.so.conf.d/local.conf
    ldconfig

    echo -e "${OK} ${GreenBG} 即将开始编译安装 Nginx, 过程稍久，请耐心等待 ${Font}"
    sleep 4

    cd ../nginx-${nginx_version} || exit

    ./configure --prefix="${nginx_dir}" \
        --with-http_ssl_module \
        --with-http_sub_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-pcre \
        --with-http_realip_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_secure_link_module \
        --with-http_v2_module \
        --with-cc-opt='-O3' \
        --with-ld-opt="-ljemalloc" \
        --with-openssl=../openssl-"$openssl_version"
        --add-dynamic-module=../headers-more-nginx-module
    judge "编译检查"
    make -j "${THREAD}" && make install
    judge "Nginx 编译安装"

    # 修改基本配置
    sed -i 's/#user  nobody;/user  root;/' ${nginx_dir}/conf/nginx.conf
    sed -i 's/worker_processes  1;/worker_processes  3;/' ${nginx_dir}/conf/nginx.conf
    sed -i 's/    worker_connections  1024;/    worker_connections  4096;/' ${nginx_dir}/conf/nginx.conf
    sed -i '$i include conf.d/*.conf;' ${nginx_dir}/conf/nginx.conf
    sed -i 'load_module /etc/nginx/modules/ngx_http_headers_more_filter_module.so; 1a' ${nginx_dir}/conf/nginx.conf

    # 删除临时文件
    rm -rf ../nginx-"${nginx_version}"
    rm -rf ../openssl-"${openssl_version}"
    rm -rf ../nginx-"${nginx_version}".tar.gz
    rm -rf ../openssl-"${openssl_version}".tar.gz

    # 添加配置文件夹，适配旧版脚本
    mkdir ${nginx_dir}/conf/conf.d
}

is_root
check_system
dependency_install
nginx_install