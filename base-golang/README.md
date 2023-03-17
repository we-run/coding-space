### golang语言观感

### 无法访问外国网站
```shell
# 如果您使用的 Go 版本是 1.13 - 1.15 需要手动设置GO111MODULE=on, 开启方式如下命令, 如果你的 Go 版本 是 1.16 ~ 最新版 可以忽略以下步骤一
# 步骤一、启用 Go Modules 功能
go env -w GO111MODULE=on 
# 步骤二、配置 GOPROXY 环境变量
go env -w GOPROXY=https://goproxy.cn,https://goproxy.io,direct

# 如果嫌弃麻烦,可以使用go generate 编译前自动执行代码, 不过这个不能使用 `Goland` 或者 `Vscode`的命令行终端
cd server
go generate -run "go env -w .*?"

# 使用如下命令下载swag
go get -u github.com/swaggo/swag/cmd/swag
```

### 前期准备

    1. 翻墙 VPN 要开启，以下载国外golang模块
### 开发工具

    1. vs code 配置
    2. Goland 配置   
#### Golang 模块机制一览


    ```sh
    #!/usr/bin/env bash

    # init go mod
    go mod init daqiang.me/hello
    # renew test
    go test


    # 添加依赖
    # import "rsc.io/quote"
    go test

    # 列出依赖项
    go list -m all
    # 当前模块(也称为主模块)始终是第一行, 后面是按模块路径排序的依赖项

    go get -x -v -u golang.org/x/text


    go get rsc.io/sampler

    # 列出标记版本
    go list -m -versions rsc.io/sampler

    # 获取指定版本的依赖  默认版本值为 @latest
    go get rsc.io/sampler@1.3.1

    # go mod 规定一个主版本就是一个独立的模块 方便过度升级
    # import {
    #   "rsc.io/quote"
    #   quoteV3 "rsc.io/quote/v3"
    # }

    go mod edit -require="github.com/objcoding/testmod@v1.0.1"

    # 查看文档
    go doc rsc.io/quote/v3

    # 清除未使用的依赖项 并且下载新的依赖项
    go mod tidy


    # https://lingchao.xin/post/using-go-modules.html
    # https://research.swtch.com/deps


    ```
