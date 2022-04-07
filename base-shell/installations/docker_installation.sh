
# 自定义es docker镜像
data 目录暴露
logs 目录暴露
certs 证书文件暴露
config 文件要暴露


# 插件安装程序要暴露



## docker compose 2.x
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker} && \
mkdir -p $DOCKER_CONFIG/cli-plugins && \
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose && \
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose && docker compose version