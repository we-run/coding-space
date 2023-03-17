#!/bin/sh

## 0. work dir
WORK_ROOT=$(cd $(dirname $0);pwd)
echo 'Woring in ... '$WORK_ROOT
cd $WORK_ROOT

## 1. generate site public
rm -rf $WORK_ROOT/team-blog
rm -f $WORK_ROOT/team-blog.tar.gz
npx hexo clean
npx hexo g

## 2. deploy
mv public team-blog
tar zcvf team-blog.tar.gz team-blog
rm -rf $WORK_ROOT/team-blog
ssh my_huawei 'rm -rf /www/*'
# ssh vpn_vps_1 'rm -rf /var/www/*'
scp -v team-blog.tar.gz my_huawei:'/www/'
# scp -v team-blog.tar.gz vpn_vps_1:'/var/www/'
ssh my_huawei 'cd /www && tar zxvf team-blog.tar.gz'
# ssh vpn_vps_1 'cd /var/www && tar zxvf team-blog.tar.gz'
ssh my_huawei 'rm -f /www/team-blog.tar.gz'
# ssh vpn_vps_1 'rm -f /var/www/team-blog.tar.gz'
rm -f team-blog.tar.gz



