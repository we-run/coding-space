#!/bin/sh

ES_VER=$1
echo '-----'
echo $ES_VER
echo '-----'

systemctl stop firewalld || true
systemctl disable firewalld || true
iptables -F || true

# step 1 : Disable swapping
swapoff -a
sed -ri '/\bswap\b/s/^/#/g' /etc/fstab

# step 2 : Increase file descriptors
nolimit_filehandle() {
	user=$1
	if [[ -z $(grep -i "${user}-not-limit" /etc/security/limits.conf) ]]; then
	cat >> /etc/security/limits.conf <<EOF
# ${user}-not-limit
${user} hard nofile 65536
${user} soft nofile 65536
${user} memlock unlimited
${user} hard nproc 4096
${user} soft nproc 4096
EOF
	fi
}
ulimit -n 65535
for user in `awk -F':' '{print $2}' ./add_user.log`
do
nolimit_filehandle "${user}"
done

nolimit_filehandle "root"

# step 3: Ensure sufficient virtual memory
add_mem() {
	if [[ -z $(grep -i "es-not-limit" /etc/sysctl.conf) ]]; then
		sysctl -w vm.max_map_count=262144
		cat >> /etc/sysctl.conf <<EOF
# es-not-limit
vm.max_map_count = 262144
net.ipv4.tcp_retries2 = 5
EOF
fi
		sysctl vm.max_map_count
}
add_mem

# step 4: Ensure sufficient threads 
ulimit -u 4096
# permanent config in /etc/security/limits.conf above


# step 5: Temporary directory
export ES_TMPDIR=/var/tmp
mkdir -p $ES_TMPDIR


# step 6: Tcp retransmission timeout
sysctl -w net.ipv4.tcp_retries2=5
# set 'net.ipv4.tcp_retries2 = 5' above
sysctl net.ipv4.tcp_retries2
