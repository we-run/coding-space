
### VPS资源
(DMIT)[https://vpsxueyuan.com/dmit-vps-tutorial/]
(CN2 GIA VPS)[https://vpsxueyuan.com/cn2-gia-vps-merchants/]
(VPN兼顾建站需求 VPS商家)[https://vpsxueyuan.com/vps-for-host-site/]
(大带宽大流量VPS商家汇总)[https://netfiles.pw/large-bandwith-traffic-vps-summary/]
### Trojan
- 资源
    (原版C++ trojan)[https://github.com/trojan-gfw/trojan]
    (支持CDN的trojan-go)[https://github.com/p4gefau1t/trojan-go]
    (Trojan基本原理)[https://p4gefau1t.github.io/trojan-go/basic/trojan/]

### XRay
(XRay 源码)[https://github.com/XTLS]
安装：
```sh
bash <(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh) install
```

### ClashX Pro 
Github ： https://github.com/Dreamacro/clash/releases 
其发布地址 ： https://install.appcenter.ms/users/clashx/apps/clashx-pro/distribution_groups/public

### 解锁流媒体服务
- 为什么不能正常看？
1. 完全无法看， 一个IP，很多账号登陆，会被封锁；
2. 部分解锁？
3. 百分百解锁
4. 检测是否可以看的脚本： https://github.com/Netflixxp/NF

### 集成环境
(xrayr-project)[https://crackair.gitbook.io/xrayr-project/xrayr-pei-zhi-wen-jian-shuo-ming/config]

- 资料：
1. 视频：https://www.youtube.com/watch?v=Z5kHGt8giVY ， 博客： https://ybfl.xyz/106.html
2. 树莓派安装OpenWrt： https://www.youtube.com/watch?v=jlHWnKVpygw
3. 中文魔改版OpenWrt，准确说是ImmortalWrt ： https://github.com/SuLingGG/OpenWrt-Rpi
4. 使用树莓派做副路由： https://www.cnblogs.com/dingshaohua/p/13525230.html
5. https://doc.openwrt.cc/3-OpenWrt-Buildbot/
6. OpenWrt - Led 版 ： https://github.com/coolsnowwolf/lede
7. OpenWrt - Official 版 ： https://github.com/openwrt/openwrt/tree/master
8. OpenWrt 固件系列区别 ： http://www.mlapp.cn/1004.html
9. 各种编译好的固件下载 ： https://openwrt.mpdn.fun:8443/
10. 编译OpenWrt - [OpenWrt](https://www.moewah.com/archives/4003.html)
11. 左须之男 - 路由器固件开发实力开发者 ： https://forgotfun.org/
12. OpernWrt Buildbot : https://buildbot.openwrt.org/master/images/#/console
13. 黑群晖、猫盘等网络技术
14. 目前市面上上千款设备支持运行OpenWrt系统，如小米路由、newifi、netgear路由、360路由等
15. 各大wifi芯片厂商的sdk开始采用OpenWrt，比如高通qsdk、mtk的OpenWrt sdk等
16. 4G模块 Quectel EC20 R2.0
17. GL-MiFi，神器， 相比，usb 上网卡有比较通用的驱动
18. zbt wg3526 带 SIM 口
19. (VMware安装OpenWrt虚拟机让宿主机上网)[https://blog.yqxpro.com/2019/10/04/VMware%E5%AE%89%E8%A3%85OpenWrt%E8%99%9A%E6%8B%9F%E6%9C%BA%E8%AE%A9%E5%AE%BF%E4%B8%BB%E6%9C%BA%E4%B8%8A%E7%BD%91/]
20. (Proxmox VE 虚拟机安装 OpenWrt 配置旁路由教程)[https://www.moewah.com/archives/3643.html]
21. USB无线网卡
    - Netgear Nighthawk A7000 USB 无线网卡
    - Glam Hobby Ourlink U631 AC600 双频 USB 无线网卡
    - Net-Dyn AC1200 USB 无线网卡
    - 
22. (MacOS SDFormater 下载)[https://www.sdcard.org/downloads/formatter/eula_mac/SDCardFormatterv5_Mac.zip]
23. 


- 碎片
1. Dnsmasq 
2. SNI proxy反向代理
3. MacOS 烧录系统到SD卡
   ```sh
    # 0. SDFormater 格式化
    # 1. 查看存储卡路径
    diskutil list
    # 2、卸载设备
    diskutil unmountDisk + SD卡设备路径
    # 3、写入 ： 注意：文件路径不要出现中文。可以将bs=1m改为bs=4m加快烧录的速度。
    
    sudo dd if=/Users/dongfuqiang/Desktop/PAN/immortalwrt-bcm27xx-bcm2711-rpi-4-ext4-factory.img of=/dev/disk4 bs=1m;sync
   ```


关于 OpenWrt
openwrt是嵌入式设备上运行的linux系统。
OpenWrt 的文件系统是可写的，开发者无需在每一次修改后重新编译，
令它更像一个小型的 Linux 电脑系统，也加快了开发速度。
你会发现无论是 ARM, PowerPC 或 MIPS 的处理器，都有很好的支持。
并且附带3000左右的软件包，用户可以方便的自定义功能来制作固件。
也可以方便的移植各类功能到openwrt下。
