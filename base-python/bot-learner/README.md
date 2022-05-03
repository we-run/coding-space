

# 本工具以 python 3.x 作为运行基础环境

## 安装依赖项
- 项目管理参考
  + [Installing packages](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/)
  + [PEP-405](https://peps.python.org/pep-0405/)
```shell
$ python3 -m venv ./env
$ pip install -r requirements.txt
$ pip show fabric2 
$ pip list
```

## 基本功能说明
1. 批量在远程主机执行配置文件中的shell程序
2. 可以配置多个远程主机，并区分执行程序
3. 可以在多个远程主机拷贝和下载文件
4. 远程主机支持跳板方式访问和执行
5. 远程主机认证支持自定义证书或密钥
6. 通过ssh，隧道（forward_local）连接其他远程主机本身及其内网的其他服务，如DB服务


## ElasticStack 学习路线功能说明
1. 下载并配置集群
2. 根据配置，重启集群
3. 不同版本之间切换集群
4. 清理指定版本集群
5. 根据学习路线，与集群进行请求和响应的交互


## 自定义管理远程集群功能说明
1. 管理数据库服务
2. 管理k8s服务
