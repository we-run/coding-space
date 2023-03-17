

# 本工具以 python 3.x 作为运行基础环境

## 个中缘由
在学习ES的过程中（也不完全是因ES学习，而是因ES而更加觉得），发现很多笔记都仅仅是笔记，虽然当时觉得明白了，也记下了，但是日久之后，再次复习，就
会觉得干瘪乏味，觉得是不是可以将笔记转化成一行行的"执行过程（代码）" + "注释"，按照时间线、任务线、主次层次，进行记录，又可以纳入版本管理，最重
要的是**能够和笔记进行交互的过程，让人不得不结构化自己的思路，且加深印象，增加趣味**

## 安装依赖项
- 项目管理参考
  + [Installing packages](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/)
  + [PEP-405](https://peps.python.org/pep-0405/)
```shell
$ python3 -m venv ./env
$ pip install -r requirements.txt
$ pip show fabric2 
$ pip list

# 高版本的此依赖项，会有警告过期输出，所以降级安装
$  pip install cryptography==36.0.2

# PACKAGE_AS_FABRIC2=yes pip install -e .
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



###
本地主机映射关系 ： 
```
node1 : 192.168.87.131 / 172.16.10.131

node2 : 192.168.87.130 / 172.16.10.132

node3 : 192.168.87.132 / 172.16.10.133


192.168.87.131 node1
192.168.87.130 node2
192.168.87.132 node3
```
