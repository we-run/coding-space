
### 缘由
1. 原来的frp，莫名其妙地阻塞，还没查清楚到底为何，就随手尝试了一下v2ray的方式，结果很快；
2. v2ray 一直用来快乐上网，frp用来穿透，如果能统一工具，管理就简化了很多；
3. frp属于四年前在用的工具，一直信心不太足，具体原因未知，待探究；


### 使用v2ray内网穿透

特点说明： 
- 客户端的服务声明，在服务端进行配置，对比frp客户端映射的思路，不太一样，各有利弊？
- v2ray 配置弹性灵活，比较frp稍微复杂一点
- 都是golang编写，可以用来解剖源码，学习一下

1. 服务端配置
```json
{
    "reverse": {
        "portals": [
            {
                "tag": "portal",
                "domain": "net.xinzhili.cn"
            },
	    {
                "tag": "portal_es",
                "domain": "netes.xinzhili.cn"
            }
        ]
    },
    "inbounds": [
        {
            "tag": "external",
            "port": 7711,
            "protocol": "dokodemo-door",
            "settings": {
                "address": "127.0.0.1",
                "port": 22,
                "network": "tcp"
            }
        },
	{
            "tag": "external_es",
            "port": 9200,
            "protocol": "dokodemo-door",
            "settings": {
                "address": "127.0.0.1",
                "port": 9200,
                "network": "tcp"
            }
        },
        {
            "tag": "tunnel",
            "port": 16823,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "xxx-xx-xx-xx-xxxx",
                        "alterId": 64
                    }
                ]
            }
        }
    ],
    "routing": {
        "rules": [
            {
                "type": "field",
                "inboundTag": [
                    "external"
                ],
                "outboundTag": "portal"
            },
            {
                "type": "field",
                "inboundTag": [
                    "tunnel"
                ],
                "domain": [
                    "full:net.xinzhili.cn"
                ],
                "outboundTag": "portal"
            },
	    {
                "type": "field",
                "inboundTag": [
                    "external_es"
                ],
                "outboundTag": "portal_es"
            },
	    {
                "type": "field",
                "inboundTag": [
                    "tunnel"
                ],
                "domain": [
                    "full:netes.xinzhili.cn"
                ],
                "outboundTag": "portal_es"
            }

        ]
    }
}
```


2. 客户端配置
```json
{
    "reverse": {
        "bridges": [
            {
                "tag": "bridge",
                "domain": "net.xinzhili.cn"
            },
	    {
                "tag": "bridge",
                "domain": "netes.xinzhili.cn"
            }
        ]
    },
    "outbounds": [
        {
            "tag": "tunnel",
            "protocol": "vmess",
            "settings": {
                "vnext": [
                    {
                        "address": "39.105.21.211",
                        "port": 16823,
                        "users": [
                            {
                                "id": "xxx-xx-xx-xx-xxxx",
                                "alterId": 64
                            }
                        ]
                    }
                ]
            }
        },
        {
            "protocol": "freedom",
            "settings": {},
            "tag": "out"
        }
    ],
    "routing": {
        "rules": [
            {
                "type": "field",
                "inboundTag": [
                    "bridge"
                ],
                "domain": [
                    "full:net.xinzhili.cn",
                    "full:netes.xinzhili.cn"
                ],
                "outboundTag": "tunnel"
            },
            {
                "type": "field",
                "inboundTag": [
                    "bridge"
                ],
                "outboundTag": "out"
            }
        ]
    }
}
```