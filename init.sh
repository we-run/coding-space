#!/bin/sh 

## 0. 检查基础环境设置，并对Mac电脑进行必要设置




## 1. 拷贝需要进入博客系统的 Markdown 文件
loop_get_target_fiels(){
    for r in `ls -l | grep "^d" | awk '{print $NF}'`;
    do
        existed_doc="$(cd $r;pwd)/README.md"
        if [[ -f $existed_doc ]];then
            echo "==> 存在在文件 : ${existed_doc}"
        else
            echo "--->"
        fi
    done
}
loop_get_target_fiels

## 2. 



# ai-tensorflow
# base-c_cpp
# base-golang
# base-java_kotlin_scala
# base-javascript
# base-lua
# base-php
# base-python
# base-ruby
# base-shell
# base-sql
# base-swift
# base-typescript
# builds-tool-cmake
# builds-tool-cocoapods
# builds-tool-fastlane
# builds-tool-gradle
# builds-tool-webpack
# ci_cd-gerrit
# ci_cd-gitlab_runner
# ci_cd-jenkins
# db-elasticstack
# db-mysql
# db-postgresql
# efficient-tools-alfred
# efficient-tools-git
# efficient-tools-v2ray
# efficient-tools-vim
# infra-aliyun
# infra-aws
# infra-hashicorp
# infra-runtime-env
# lib-ioproject-reactor
# lib-netty
# lib-zookeeper
# media-img_audio_video
# network-dn42
# network-dns
# network-vpn
# os-ios
# os-linux
# platform-electron
# platform-flutter
# platform-k8s
# platform-openresty
# source-code-shared
# team-blog
# web-css
# web-manual
# web-react
# web-server-nginx
# web-server-node
# web-server-spring_boot
# web-server-tomcat
# web-space
# web-template-ejs
# web-template-nunjucks
# web-vue
# workflow-ldap_confluence_jira