config_firewall(){
    if centosversion 6; then
        /etc/init.d/iptables status > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            for port in ${ports}; do
                iptables -L -n | grep -i ${port} > /dev/null 2>&1
                if [ $? -ne 0 ]; then
                    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${port} -j ACCEPT
                    if [ ${port} == "53" ]; then
                        iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${port} -j ACCEPT
                    fi
                else
                    echo -e "[${green}Info${plain}] port ${green}${port}${plain} already be enabled."
                fi
            done
            /etc/init.d/iptables save
            /etc/init.d/iptables restart
        else
            echo -e "[${yellow}Warning${plain}] iptables looks like not running or not installed, please enable port ${ports} manually if necessary."
        fi
    elif centosversion 7 || centosversion 8; then
        systemctl status firewalld > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            default_zone=$(firewall-cmd --get-default-zone)
            for port in ${ports}; do
                firewall-cmd --permanent --zone=${default_zone} --add-port=${port}/tcp
                if [ ${port} == "53" ]; then
                    firewall-cmd --permanent --zone=${default_zone} --add-port=${port}/udp
                fi
                firewall-cmd --reload
            done
        else
            echo -e "[${yellow}Warning${plain}] firewalld looks like not running or not installed, please enable port ${ports} manually if necessary."
        fi
    fi
}
