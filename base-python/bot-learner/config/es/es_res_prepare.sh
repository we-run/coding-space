
# if [[ ! -f "./elasticsearch-$ES_VER.tar.gz" ]];then
#     curl --progress-bar -o ./elasticsearch-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$ES_VER"-linux-x86_64.tar.g
# else
#     echo 'Exsited The File!'
# fi
RF="$HOME/elasticsearch-$ES_VER.tar.gz"
echo $RF
if [[ ! -f "$RF" ]]; then
    echo 'ES SCHEL 3 : copy es file ... '$ES_VER
    scp -i $P_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dongfuqiang@192.168.87.1:'~/elasticsearch-'$ES_VER'.tar.gz' .
    tar -zxf elasticsearch-"$ES_VER".tar.gz
else
    echo 'Existed The es tar file.'$ES_VER
fi

KF="$HOME/kibana-$KIB_VER.tar.gz"
if [ ! -f "$KF" ] && [ $KIB_VER ]; then
    echo 'ES SCHEL 3 : copy kibana file ... '$KIB_VER
    echo '~/kibana-'$KIB_VER'.tar.gz'
    scp -i $P_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dongfuqiang@192.168.87.1:'~/kibana-'$KIB_VER'.tar.gz' .
    tar -zxf kibana-"$KIB_VER".tar.gz
    mv $(find ./ -maxdepth 2 -type d -name 'kibana*') "kibana-"$KIB_VER
else
    echo 'Exsited Kibana file.'
fi

#  scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.254:~/*.tar.gz .
# ssh -i $P_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.254 ls -l

# (
#     echo 'scp root@192.168.1.254:~/*.gz .'
#     sleep 5
#     echo '_Xinzhili901_'
#     sleep 5
#     echo 'exit'
# ) |

# python -c 'import pty; pty.spawn("/usr/bin/bash")'


