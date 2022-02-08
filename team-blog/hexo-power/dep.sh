#!/bin/sh

## 0. work dir
WORK_ROOT=$(cd $(dirname $0);pwd)
echo 'Woring in ... '$WORK_ROOT
cd $WORK_ROOT

## 1. generate site public
npx hexo clean
npx hexo g 

## 2. deploy
mv public team-blog
tar zcvf team-blog.tar.gz team-blog
ssh vpn_vps 'rm -rf /etc/nginx/wordpress/team-blog'
scp team-blog.tar.gz vpn_vps:'/etc/nginx/wordpress'
ssh vpn_vps 'cd /etc/nginx/wordpress && tar zxvf team-blog.tar.gz'
ssh vpn_vps 'rm -f /etc/nginx/wordpress/team-blog.tar.gz'
rm -f team-blog.tar.gz