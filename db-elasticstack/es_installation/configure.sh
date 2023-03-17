#!/bin/sh

ES_VER=8.1.0

output_config_es() {
	user=$2
	work_dir=$3
	uc=$4
	
	cluster_name=$user'_cluster'
	node_name='node'$1
	node_attr_rack='rack'$1
	network_host=$(echo $(hostname -I) | cut -d " " -f1)
	transport_port=$((9300+$1+10*$uc))
	http_port=$((9200+$1+10*$uc))
	discovery_seed_hosts='["'$network_host':'$((9301+10*$uc))'","'$network_host':'$((9302+10*$uc))'","'$network_host':'$((9303+10*$uc))'"]'
	cluster_initial_master_nodes='["node1"]'
	xpack_security_enabled='true'
	xpack_security_transport_ssl_enabled='true'
	xpack_security_enrollment_enabled='true'
	xpack_security_http_ssl_enabled='true'
	xpack_security_transport_ssl_enabled='true'

	echo 'http_port: '$http_port' ,trasport_port: '$transport_port
#	eval "cat <<EOF
#$(< /root/es/templ/es.yml)
#EOF" > ~/elasticsearch.yml
# 后续节点加入集群通过enroll token，所以不需要种子地址
	if [[ $1 == 1 ]]; then
	su - $user -- <<EOF
cat <<CODE > $work_dir/elasticsearch.yml
cluster.name: $cluster_name
node.name: $node_name
node.attr.rack: $node_attr_rack
#path.data: /path/to/data
#path.logs: /path/to/logs
#bootstrap.memory_lock: true
network.host: $network_host
#transport.host: 0.0.0.0
transport.port: $transport_port
http.port: $http_port
discovery.seed_hosts: $discovery_seed_hosts
cluster.initial_master_nodes: $cluster_initial_master_nodes
#action.destructive_requires_name: true

#xpack.security.enabled: $xpack_security_enabled
#xpack.security.transport.ssl.enabled: $xpack_security_transport_ssl_enabled
#xpack.security.enrollment.enabled: $xpack_security_enrollment_enabled
#xpack.security.http.ssl:
#  enabled: $xpack_security_http_ssl_enabled
#  keystore.path: certs/http.p12
#xpack.security.transport.ssl:
#  enabled: $xpack_security_transport_ssl_enabled
#  verification_mode: certificate
#  keystore.path: certs/transport.p12
#  truststore.path: certs/transport.p12
#http.host: [_local_, _site_]
#transport.host: [_local_, _site_]
CODE

sed -ri 's/^#.*-Xms.+g/-Xms2g/g' $work_dir/jvm.options
sed -ri 's/^##.*-Xms.+g/-Xms2g/g' $work_dir/jvm.options
sed -ri 's/^.*-Xms.+g/-Xms2g/g' $work_dir/jvm.options
sed -ri 's/^#.*-Xmx.+g/-Xmx2g/g' $work_dir/jvm.options
sed -ri 's/^##.*-Xmx.+g/-Xmx2g/g' $work_dir/jvm.options
sed -ri 's/^.*-Xmx.+g/-Xmx2g/g' $work_dir/jvm.options

EOF
	else
	
	su - $user -- <<EOF
cat <<CODE > $work_dir/elasticsearch.yml
cluster.name: $cluster_name
node.name: $node_name
node.attr.rack: $node_attr_rack
#path.data: /path/to/data
#path.logs: /path/to/logs
#bootstrap.memory_lock: true
network.host: $network_host
#transport.host: 0.0.0.0
transport.port: $transport_port
http.port: $http_port
#discovery.seed_hosts: $discovery_seed_hosts
cluster.initial_master_nodes: $cluster_initial_master_nodes
#action.destructive_requires_name: true

#xpack.security.enabled: $xpack_security_enabled
#xpack.security.transport.ssl.enabled: $xpack_security_transport_ssl_enabled
#xpack.security.enrollment.enabled: $xpack_security_enrollment_enabled
#xpack.security.http.ssl:
#  enabled: $xpack_security_http_ssl_enabled
#  keystore.path: certs/http.p12
#xpack.security.transport.ssl:
#  enabled: $xpack_security_transport_ssl_enabled
#  verification_mode: certificate
#  keystore.path: certs/transport.p12
#  truststore.path: certs/transport.p12
#http.host: [_local_, _site_]
#transport.host: [_local_, _site_]
CODE

sed -ri 's/^#.*-Xms.+g/-Xms2g/g' $work_dir/jvm.options
sed -ri 's/^##.*-Xms.+g/-Xms2g/g' $work_dir/jvm.options
sed -ri 's/^.*-Xms.+g/-Xms2g/g' $work_dir/jvm.options
sed -ri 's/^#.*-Xmx.+g/-Xmx2g/g' $work_dir/jvm.options
sed -ri 's/^##.*-Xmx.+g/-Xmx2g/g' $work_dir/jvm.options
sed -ri 's/^.*-Xmx.+g/-Xmx2g/g' $work_dir/jvm.options

EOF
	
	fi
}

user_count=0
for u in `awk -F':' '{print $NF}' ./add_user.log`
do
	let "count++"
	echo $u$count
	cp ./start.sh /home/$u/
	chown $u /home/$u/start.sh
	chgrp es /home/$u/start.sh
 	for i in {1..3}
	do
		echo $i
	 	work_dir=$(find /home/$u/node$i -maxdepth 2 -type d -name 'elasticsearch*')		
		echo $work_dir
		output_config_es $i $u $work_dir/config $count
	done	
done


