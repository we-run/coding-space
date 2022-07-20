#!/bin/sh
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
ssl_update_file="/usr/bin/ssl_update_me.sh"

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


domain_check
ssl_judge_and_install
