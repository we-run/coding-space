#!/bin/sh
# bash <(curl -s -S -L https://raw.githubusercontent.com/we-run/coding-space/master/base-shell/setup/jump.sh)

read -rp "input your target host ip to connect : " host_ip
if [[ ! -n "${host_ip}" ]];then
    echo 'please input you IP address!'
    exit 1
fi

mkdir -p $HOME/.ssh

# sed -i '/#XZL_AUTO_START/{:begin;n;d;/#XZL_AUTO_END/!bbegin}' $HOME/.ssh/config
sed -i '{:begin /#XZL_AUTO_END/! { $! { N; b begin }; }; s/#XZL_AUTO_START.*END//;};' $HOME/.ssh/config

echo '' >> $HOME/.ssh/config
echo '#XZL_AUTO_START' >> $HOME/.ssh/config


cat > $HOME/.ssh/idc <<EOF
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
EOF

base64 --decode >> $HOME/.ssh/config <<EOF
SG9zdCBpZGNfb2NyCiAgICBIb3N0TmFtZSAgICAgICAgMTE5LjkwLjM2LjcwCiAgICBQb3J0ICAgICAgICAgICAgMjIKICAgIFVzZXIgICAgICAgICAgICByb290CiAgICBJZGVudGl0eUZpbGUgICAgfi8uc3NoL2lkYwpIT1NUIGd1ZXN0X21lCiAgICBIb3N0TmFtZSBteV9ob3N0CiAgICBVc2VyIHJvb3QKICAgIFByb3h5Q29tbWFuZCBzc2ggLWkgfi8uc3NoL2lkYyAtcSAtVyAlaDolcCBpZGNfb2Ny
EOF

chmod 600 $HOME/.ssh/idc
chmod 644 $HOME/.ssh/idc.pub

sed -i "s/my_host/"$host_ip"/g" $HOME/.ssh/config


echo '' >> $HOME/.ssh/config
echo '#XZL_AUTO_END' >> $HOME/.ssh/config
sed -i '/^$/d' $HOME/.ssh/config