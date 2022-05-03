#!/bin/sh

# 1. download specified version of es

# 2. unpacked the package

# 3. build Dockerfile template

# 4. check and create network before running the Docker image
iptables -t filter -F
iptables -t filter -X
systemctl restart docker

# docker network create --subnet 172.20.0.0/16 --ip-range 172.20.240.0/24 br0
# docker network create --driver=bridge --subnet=192.168.0.0/16 br0
docker network create \
  --driver=bridge \
  --subnet=172.28.0.0/16 \
  --ip-range=172.28.5.0/24 \
  --gateway=172.28.5.254 \
  es-cluster

# docker network create -d overlay \
#   --subnet=192.168.10.0/25 \
#   --subnet=192.168.20.0/25 \
#   --gateway=192.168.10.100 \
#   --gateway=192.168.20.100 \
#   --aux-address="my-router=192.168.10.5" --aux-address="my-switch=192.168.10.6" \
#   --aux-address="my-printer=192.168.20.5" --aux-address="my-nas=192.168.20.6" \
#   my-multihost-network
# 5. check and create volumn before running the Docker image 

# 6. run the Docker image 
docker run -itd --network=br0 busybox
docker network connect --ip 172.28.0.1 br0 nginx
