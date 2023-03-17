#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

cd "$(
    cd "$(dirname "$0")" || exit
    pwd
)" || exit

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

nginx_version="1.20.1"
nginx_dir="/etc/nginx"
nginx_conf_dir="/etc/nginx/conf/conf.d"
nginx_systemd_file="/etc/systemd/system/nginx.service"
nginx_openssl_src="/usr/local/src"
openssl_version="1.1.1k"
jemalloc_version="5.2.1"

ssl_update_file="/usr/bin/ssl_update_me.sh"

source '/etc/os-release'


### entrance function

main() {
  [ -z "$1" ] && _process --help && return
  if _startswith "$1" '-'; then _process "$@"; else "$@"; fi
  cert_install
}


_process() {
    while [ ${#} -gt 0 ]; do
        case "${1}" in
            --help | -h)
                echo '--nginx_conf_dir : nginx config directory'
                return
            ;;
            --nginx-conf-dir | -ncd)
                nginx_conf_dir=$2
                echo "$nginx_conf_dir"
            ;;
        esac
        shift 1
    done
}

cert_install() {
    is_root
    # check_system
    # dependency_install
    # basic_optimization
    
    domain_check
    port_set
    
    port_exist_check 80
    port_exist_check "${port}"
    
    # nginx_exist_check
    # nginx_conf_add
    # web_camouflage

    ssl_judge_and_install
    nginx_systemd
    
    tls_type
    # start_process_systemd
    acme_cron_update
}


### base function

_startswith() {
  _str="$1"
  _sub="$2"
  echo "$_str" | grep -- "^$_sub" >/dev/null 2>&1
}

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
    
    if [[ "${ID}" == "centos" ]]; then
        ${INS} -y install pcre pcre-devel zlib-devel epel-release
    else
        ${INS} -y install libpcre3 libpcre3-dev zlib1g-dev dbus
    fi
    
    #    ${INS} -y install rng-tools
    #    judge "rng-tools 安装"
    
    # ${INS} -y install haveged
    #    judge "haveged 安装"
    
    #    sed -i -r '/^HRNGDEVICE/d;/#HRNGDEVICE=\/dev\/null/a HRNGDEVICE=/dev/urandom' /etc/default/rng-tools
    
    # if [[ "${ID}" == "centos" ]]; then
    #     #       systemctl start rngd && systemctl enable rngd
    #     #       judge "rng-tools 启动"
    #     systemctl start haveged && systemctl enable haveged
    #     #       judge "haveged 启动"
    # else
    #     #       systemctl start rng-tools && systemctl enable rng-tools
    #     #       judge "rng-tools 启动"
    #     systemctl start haveged && systemctl enable haveged
    #     #       judge "haveged 启动"
    # fi
    
    mkdir -p /usr/local/bin >/dev/null 2>&1
}


port_exist_check() {
    if [[ 0 -eq $(lsof -i:"$1" | grep -i -c "listen") ]]; then
        echo -e "${OK} ${GreenBG} $1 端口未被占用 ${Font}"
        sleep 1
    else
        echo -e "${Error} ${RedBG} 检测到 $1 端口被占用，以下为 $1 端口占用信息 ${Font}"
        lsof -i:"$1"
        echo -e "${OK} ${GreenBG} 5s 后将尝试自动 kill 占用进程 ${Font}"
        sleep 5
        lsof -i:"$1" | awk '{print $2}' | grep -v "PID" | xargs kill -9
        echo -e "${OK} ${GreenBG} kill 完成 ${Font}"
        sleep 1
    fi
}


### domain function

domain_check() {
    read -rp "请输入你的域名信息(eg:daqiang.me):" domain
    domain_ip=$(ping "${domain}" -c 1 | sed '1{s/[^(]*(//;s/).*//;q}')
    echo -e "${OK} ${GreenBG} 正在获取 公网ip 信息，请耐心等待 ${Font}"
    local_ip=$(curl https://api-ipv4.ip.sb/ip)
    echo -e "域名dns解析IP：${domain_ip}"
    echo -e "本机IP: ${local_ip}"
    sleep 2
    if [[ $(echo "${local_ip}" | tr '.' '+' | bc) -eq $(echo "${domain_ip}" | tr '.' '+' | bc) ]]; then
        echo -e "${OK} ${GreenBG} 域名dns解析IP 与 本机IP 匹配 ${Font}"
        sleep 2
    else
        echo -e "${Error} ${RedBG} 请确保域名添加了正确的 A 记录，否则将无法正常使用 ${domain} ${Font}"
        echo -e "${Error} ${RedBG} 域名dns解析IP 与 本机IP 不匹配 是否继续安装？（y/n）${Font}" && read -r install
        case $install in
            [yY][eE][sS] | [yY])
                echo -e "${GreenBG} 继续安装 ${Font}"
                sleep 2
            ;;
            *)
                echo -e "${RedBG} 安装终止 ${Font}"
                exit 2
            ;;
        esac
    fi
}


port_set() {
    read -rp "请输入连接端口（default:443）:" port
    [[ -z ${port} ]] && port="443"
}

modify_nginx_port() {
    sed -i "/ssl http2;$/c \\\tlisten ${port} ssl http2;" ${nginx_conf_dir}/${domain}.conf
    sed -i "3c \\\tlisten [::]:${port} http2;" ${nginx_conf_dir}/${domain}.conf
    judge "config port 修改"
    echo -e "${OK} ${GreenBG} 端口号:${port} ${Font}"
}
modify_nginx_other() {
    sed -i "/server_name/c \\\tserver_name ${domain};" ${nginx_conf_dir}/${domain}.conf
    # sed -i "/location/c \\\tlocation ${camouflage}" ${nginx_conf_dir}/${domain}.conf
    sed -i "/proxy_pass/c \\\tproxy_pass http://127.0.0.1:${PORT};" ${nginx_conf_dir}/${domain}.conf
    sed -i "/return/c \\\treturn 301 https://${domain}\$request_uri;" ${nginx_conf_dir}/${domain}.conf
    #sed -i "27i \\\tproxy_intercept_errors on;"  ${nginx_dir}/conf/nginx.conf
}

nginx_systemd() {
    cat >$nginx_systemd_file <<EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/etc/nginx/logs/nginx.pid
ExecStartPre=/etc/nginx/sbin/nginx -t
ExecStart=/etc/nginx/sbin/nginx -c ${nginx_dir}/conf/nginx.conf
ExecReload=/etc/nginx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

    judge "Nginx systemd ServerFile 添加"
    systemctl daemon-reload
}

tls_type() {
    if [[ -f "$(which nginx)" ]] && [[ -f "${nginx_conf_dir}/${domain}.conf" ]]; then
        echo "请选择支持的 TLS 版本（default:3）:"
        # echo "请注意,如果你使用 Quantaumlt X / 路由器 / 旧版 Shadowrocket / 低于 4.18.1 版本的 V2ray core 请选择 兼容模式"
        echo "1: TLS1.1 TLS1.2 and TLS1.3（兼容模式）"
        echo "2: TLS1.2 and TLS1.3 (兼容模式)"
        echo "3: TLS1.3 only"
        read -rp "请输入：" tls_version
        [[ -z ${tls_version} ]] && tls_version=3
        if [[ $tls_version == 3 ]]; then
            sed -i 's/ssl_protocols.*/ssl_protocols         TLSv1.3;/' ${nginx_conf_dir}/${domain}.conf
            echo -e "${OK} ${GreenBG} 已切换至 TLS1.3 only ${Font}"
        elif [[ $tls_version == 1 ]]; then
            sed -i 's/ssl_protocols.*/ssl_protocols         TLSv1.1 TLSv1.2 TLSv1.3;/' ${nginx_conf_dir}/${domain}.conf
            echo -e "${OK} ${GreenBG} 已切换至 TLS1.1 TLS1.2 and TLS1.3 ${Font}"
        else
            sed -i 's/ssl_protocols.*/ssl_protocols         TLSv1.2 TLSv1.3;/' ${nginx_conf_dir}/${domain}.conf
            echo -e "${OK} ${GreenBG} 已切换至 TLS1.2 and TLS1.3 ${Font}"
        fi
        systemctl restart nginx
        judge "Nginx 重启"
    else
        echo -e "${Error} ${RedBG} Nginx 或 配置文件不存在 或当前安装版本为 h2 ，请正确安装脚本后执行${Font}"
    fi
}



### cert function

ssl_judge_and_install() {
    if [[ -f "/data/${domain}.key" || -f "/data/${domain}.crt" ]]; then
        echo "/data 目录下证书文件已存在"
        echo -e "${OK} ${GreenBG} 是否删除 [Y/N]? ${Font}"
        read -r ssl_delete
        case $ssl_delete in
        [yY][eE][sS] | [yY])
            rm -rf /data/*
            echo -e "${OK} ${GreenBG} 已删除 ${Font}"
            ;;
        *) ;;

        esac
    fi

    if [[ -f "/data/${domain}.key" || -f "/data/${domain}.crt" ]]; then
        echo "证书文件已存在"
    elif [[ -f "$HOME/.acme.sh/${domain}_ecc/${domain}.key" && -f "$HOME/.acme.sh/${domain}_ecc/${domain}.cer" ]]; then
        echo "证书文件已存在"
        "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /data/${domain}.crt --keypath /data/${domain}.key --ecc
        judge "证书应用"
    else
        ssl_install
        acme
    fi
}

ssl_install() {
    if [[ "${ID}" == "centos" ]]; then
        ${INS} install socat nc -y
    else
        ${INS} install socat netcat -y
    fi
    judge "安装 SSL 证书生成脚本依赖"

    ## codes 目录下有 get_acme.sh 备份
    curl https://get.acme.sh | sh
    judge "安装 SSL 证书生成脚本"
}

acme() {
    "$HOME"/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    if "$HOME"/.acme.sh/acme.sh --issue --insecure -d "${domain}" --standalone -k ec-256 --force --test; then
        echo -e "${OK} ${GreenBG} SSL 证书测试签发成功，开始正式签发 ${Font}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        sleep 2
    else
        echo -e "${Error} ${RedBG} SSL 证书测试签发失败 ${Font}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        exit 1
    fi

    if "$HOME"/.acme.sh/acme.sh --issue --insecure -d "${domain}" --standalone -k ec-256 --force; then
        echo -e "${OK} ${GreenBG} SSL 证书生成成功 ${Font}"
        sleep 2
        mkdir /data
        if "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /data/${domain}.crt --keypath /data/${domain}.key --ecc --force; then
            echo -e "${OK} ${GreenBG} 证书配置成功 ${Font}"
            sleep 2
        fi
    else
        echo -e "${Error} ${RedBG} SSL 证书生成失败 ${Font}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        exit 1
    fi
}


### auto function

ssl_update_manuel() {
    [ -f ${amce_sh_file} ] && "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" || echo -e "${RedBG}证书签发工具不存在，请确认你是否使用了自己的证书${Font}"
    # domain="$(info_extraction '\"add\"')" # 自动抽取域名，进行判断
    "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /data/${domain}.crt --keypath /data/${domain}.key --ecc
}

acme_cron_update() {
    # wget -N -P /usr/bin --no-check-certificate "https://raw.githubusercontent.com/wulabing/V2Ray_ws-tls_bash_onekey/dev/ssl_update.sh"
    cat > $ssl_update_file <<EOF
        #!/usr/bin/env bash
        PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
        export PATH

        systemctl stop nginx &> /dev/null
        sleep 1
        "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /dev/null
        "/root/.acme.sh"/acme.sh --installcert -d ${domain} --fullchainpath /data/${domain}.crt --keypath /data/${domain}.key --ecc
        sleep 1
        systemctl start nginx &> /dev/null
EOF
    echo "checking ${ssl_update_file} ..."
    cat $ssl_update_file

    if [[ $(crontab -l | grep -c "ssl_update_me.sh") -lt 1 ]]; then
      if [[ "${ID}" == "centos" ]]; then
          #        sed -i "/acme.sh/c 0 3 * * 0 \"/root/.acme.sh\"/acme.sh --cron --home \"/root/.acme.sh\" \
          #        &> /dev/null" /var/spool/cron/root
          sed -i "/acme.sh/c 0 3 * * 0 bash ${ssl_update_file}" /var/spool/cron/root
      else
          #        sed -i "/acme.sh/c 0 3 * * 0 \"/root/.acme.sh\"/acme.sh --cron --home \"/root/.acme.sh\" \
          #        &> /dev/null" /var/spool/cron/crontabs/root
          sed -i "/acme.sh/c 0 3 * * 0 bash ${ssl_update_file}" /var/spool/cron/crontabs/root
      fi
    fi
    judge "cron 计划任务更新"
}

uninstall_acme() {
    echo -e "${OK} ${Green} 是否卸载acme.sh及证书 [Y/N]? ${Font}"
    read -r uninstall_acme
    case $uninstall_acme in
    [yY][eE][sS] | [yY])
      /root/.acme.sh/acme.sh --uninstall
      rm -rf /root/.acme.sh
      rm -rf /data/*
      ;;
    *) ;;
    esac
}

### 服务管理
start_process_systemd() {
    systemctl daemon-reload
    chown -R root.root /var/log/
    systemctl restart nginx
    judge "Nginx 启动"
}


main "$@"
