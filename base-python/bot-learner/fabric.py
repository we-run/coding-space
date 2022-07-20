debug = True
my_run = {
    "echo": True
}

ES_VER = '7.13.0'
pre_settings = [
    #############
    # First Stage : NIT TODOS : set system envrionments for elasticsearch service
    #############
    # {
    #     "sync": True,
    #     "description": "Stage 1 : Init system settgins.",
    #     "steps": [
    #         [
    #             {
    #                 "via": "root@103.105.200.216:22",
    #                 # #"pwd": "_DFQQFD123_", # disable the 'pwd' field and enable the 'pkey' field
    #                 "pkey": "./ssh_certs/idc"
    #             },
    #             {
    #                 "via": "root@192.168.1.11:22",
    #                 "pwd": "dev123",
    #                 "pkey": "./ssh_certs/idc",
    #                 "auto_complete": {  # auto set password for new es user
    #                     "New password:": "dev123",
    #                     "Retype new password:": "dev123"
    #                 },
    #                 "actions": [
    #                     {
    #                         "description": "check and create linux user/group of es.",
    #                         "env": {
    #                             "ES_VER": ES_VER
    #                         },
    #                         "sh_file": "./es/es_host_setting.sh",
    #                         "sh_raw": "echo $ES_VER"
    #                     }
    #                 ]
    #             }
    #         ],
    #         [
    #             {
    #                 "via": "root@103.105.200.216:22",
    #                 #"pwd": "_DFQQFD123_",
    #                 "pkey": "./ssh_certs/idc"
    #             },
    #             {
    #                 "via": "root@192.168.1.12:22",
    #                 "pwd": "dev123",
    #                 "pkey": "./ssh_certs/idc",
    #                 "auto_complete": {  # auto set password for new es user
    #                     "New password:": "dev123",
    #                     "Retype new password:": "dev123"
    #                 },
    #                 "actions": [
    #                     {
    #                         "description": "check and create linux user/group of es.",
    #                         "env": {
    #                             "ES_VER": ES_VER
    #                         },
    #                         "sh_file": "./es/es_host_setting.sh",
    #                         "sh_raw": "echo $ES_VER"
    #                     }
    #                 ]
    #             }
    #         ],
    #         [
    #             {
    #                 "via": "root@103.105.200.216:22",
    #                 #"pwd": "_DFQQFD123_",
    #                 "pkey": "./ssh_certs/idc"
    #             },
    #             {
    #                 "via": "root@192.168.1.13:22",
    #                 "pwd": "dev123",
    #                 "pkey": "./ssh_certs/idc",
    #                 "auto_complete": {  # auto set password for new es user
    #                     "New password:": "dev123",
    #                     "Retype new password:": "dev123"
    #                 },
    #                 "actions": [
    #                     {
    #                         "description": "check and create linux user/group of es.",
    #                         "env": {
    #                             "ES_VER": ES_VER
    #                         },
    #                         "sh_file": "./es/es_host_setting.sh",
    #                         "sh_raw": "echo $ES_VER"
    #                     }
    #                 ]
    #             }
    #         ],
    #     ]
    # },
    #############
    # Second Stage : SET ES : downloads the specified version of elasticsearch
    #############
    # {
    #     "sync": True,
    #     "description": "Download and cache resource files on where the host can provide scp function.",
    #     "steps": [
    #         [
    #             {
    #                 "via": "root@103.105.200.216:22",
    #                 #"pwd": "_DFQQFD123_",
    #                 "pkey": "./ssh_certs/idc",
    #                 "actions": [
    #                     {
    #                         "description": "check existed version and downloads es package and cache it.",
    #                         "env": {
    #                             "ES_VER": ES_VER
    #                         },
    #                         "sh_file": "./es/es_download.sh",
    #                         # "sh_raw": '[[ ! -f "./elasticsearch-"$ES_VER".tar.gz" ]] && curl --progress-bar -o ./elasticsearch-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-"$ES_VER"-linux-x86_64.tar.gz'
    #                     }
    #                 ]
    #             }
    #         ]
    #     ]
    # },
    # {
    #     "sync": False,
    #     "description": "Download and cache resource files on where the host can provide scp function.",
    #     "steps": [
    #         [
    #             {
    #                 "via": "root@103.105.200.216:22",
    #                 #"pwd": "_DFQQFD123_",
    #                 "pkey": "./ssh_certs/idc",
    #                 "actions": [
    #                     {
    #                         "description": "check existed version and downloads es package and cache it.",
    #                         "env": {
    #                             "ES_VER": ES_VER
    #                         },
    #                         # "sh_file": "./es/es_download.sh",
    #                         # "sh_raw": '[[ ! -f "./kibana-"$ES_VER".tar.gz" ]] && curl --progress-bar -o ./kibana-"$ES_VER".tar.gz https://artifacts.elastic.co/downloads/kibana/kibana-"$ES_VER"-linux-x86_64.tar.gz'
    #                     }
    #                 ]
    #             }
    #         ]
    #     ]
    # },
    #############
    # Third Stage : SET ES : downloads the specified version of elasticsearch
    #############
    {
        "sync": False,
        "description": "Read the cached resources and uncompress them,then config them completly.",
        "steps": [
            [
                {
                    "via": "root@103.105.200.216:22",
                    #"pwd": "_DFQQFD123_",
                    "pkey": "./ssh_certs/idc"
                },
                {
                    "via": "es@192.168.1.11:22",
                    "pwd": "dev123",
                    "pkey": "./ssh_certs/idc",
                    "auto_complete": {  # auto set password for new es user
                        "New password:": "dev123",
                        "Retype new password:": "dev123"
                    },
                    "actions": [
                        {
                            "description": ">>> es@192.168.1.11:22 >> action 1 >> checkout and download es!",
                            "env": {
                                "ES_VER": ES_VER,
                                "P_KEY": "~/.ssh/idc"
                            },
                            "sh_file": "./es/es_res_prepare.sh",
                            # "sh_raw": "passwd es",
                            # "sh_raw": "/usr/sbin/ip a | egrep 'inet 192' | awk '{print $2}'"
                        },
                        {
                            "description": ">>> es@192.168.1.11:22 >> action 2 >> reconfig es!",
                            "env": {
                                "ES_VER": ES_VER,
                                "CONFIG_FILE": "/home/es/elasticsearch-" + ES_VER + "/config/elasticsearch.yml"
                            },
                            "config": {
                                "INPUT_FILE": "./es/cluster/config.yml",
                                "cluster.name": "der-es",
                                "node.name": "node-1",
                                "node.attr.rack": "r1",
                                "#path.data": "/path/to/data",
                                "#path.logs": "/path/to/logs",
                                "bootstrap.memory_lock": "true",
                                "network.host": "192.168.1.11",
                                "http.port": "9202",
                                "discovery.seed_hosts": "[\"192.168.1.11\", \"192.168.1.12\", \"192.168.1.13\"]",
                                "cluster.initial_master_nodes": "[\"node-1\"]",
                                "action.destructive_requires_name": "true",
                                "xpack.security.http.ssl.enabled": "true"
                            }
                        },
                        {
                            "description": ">>> es@192.168.1.11:22 >> action 2 >> luanch es!",
                            "env": {
                                "ES_VER": ES_VER,
                            },
                            "sh_file": "./es/es_base_setting.sh"
                        }
                    ],
                    "description": "download remote es installation file and launch it"
                }
            ],
            [
                {
                    "via": "root@103.105.200.216:22",
                    #"pwd": "_DFQQFD123_",
                    "pkey": "./ssh_certs/idc"
                },
                {
                    "via": "es@192.168.1.12:22",
                    "pwd": "dev123",
                    "pkey": "./ssh_certs/idc",
                    "auto_complete": {  # auto set password for new es user
                        "New password:": "dev123",
                        "Retype new password:": "dev123"
                    },
                    "actions": [
                        {
                            "description": ">>> es@192.168.1.12:22 >> action 1 >> checkout and download es!",
                            "env": {
                                "ES_VER": ES_VER,
                                "P_KEY": "~/.ssh/idc"
                            },
                            "sh_file": "./es/es_res_prepare.sh",
                            # "sh_raw": "passwd es",
                            # "sh_raw": "/usr/sbin/ip a | egrep 'inet 192' | awk '{print $2}'"
                        },
                        {
                            "description": ">>> es@192.168.1.12:22 >> action 2 >> reconfig es!",
                            "env": {
                                "ES_VER": ES_VER,
                                "CONFIG_FILE": "/home/es/elasticsearch-" + ES_VER + "/config/elasticsearch.yml"
                            },
                            "config": {
                                "INPUT_FILE": "./es/cluster/config.yml",
                                "cluster.name": "der-es",
                                "node.name": "node-2",
                                "node.attr.rack": "r1",
                                "#path.data": "/path/to/data",
                                "#path.logs": "/path/to/logs",
                                "bootstrap.memory_lock": "true",
                                "network.host": "192.168.1.12",
                                "http.port": "9201",
                                "discovery.seed_hosts": "[\"192.168.1.11\", \"192.168.1.12\", \"192.168.1.13\"]",
                                "cluster.initial_master_nodes": "[\"node-1\"]",
                                "action.destructive_requires_name": "true",
                                "xpack.security.http.ssl.enabled": "true"
                            }
                        },
                        {
                            "description": ">>> es@192.168.1.11:22 >> action 3 >> launch es.",
                            "env": {
                                "ES_VER": ES_VER,
                                "P_KEY": "~/.ssh/idc"
                            },
                            "sh_file": "./es/es_base_setting.sh"
                        }
                    ],
                    "description": "download remote es installation file and launch it"
                }
            ],
            [
                {
                    "via": "root@103.105.200.216:22",
                    #"pwd": "_DFQQFD123_",
                    "pkey": "./ssh_certs/idc"
                },
                {
                    "via": "es@192.168.1.13:22",
                    "pwd": "dev123",
                    "pkey": "./ssh_certs/idc",
                    "auto_complete": {  # auto set password for new es user
                        "New password:": "dev123",
                        "Retype new password:": "dev123"
                    },
                    "actions": [
                        {  # download es and kibana file and unpack thme
                            "description": ">>> es@192.168.1.13:22 >> action 1 >> download es and kibana file and unpack thme",
                            "env": {
                                "ES_VER": ES_VER,
                                "P_KEY": "~/.ssh/idc",
                                "KIB_VER": ES_VER,
                                "CONFIG_FILE": "/home/es/kibana-" + ES_VER + "/config/kibana.yml"
                            },
                            "config": {
                                "INPUT_FILE": "./es/cluster/kibana.yml",
                                "server.host": "192.168.1.13"
                            },
                            "sh_file": "./es/es_res_prepare.sh",
                            # "sh_raw": "/usr/sbin/ip a | egrep 'inet 192' | awk '{print $2}'"
                        },
                        {  # modify es config file
                            "description": ">>> es@192.168.1.13:22 >> action 2 >> config es",
                            "env": {
                                "ES_VER": ES_VER,
                                "CONFIG_FILE": "/home/es/elasticsearch-" + ES_VER + "/config/elasticsearch.yml"
                            },
                            "config": {
                                "INPUT_FILE": "./es/cluster/config.yml",
                                "cluster.name": "der-es",
                                "node.name": "node-3",
                                "node.attr.rack": "r1",
                                "#path.data": "/path/to/data",
                                "#path.logs": "/path/to/logs",
                                "bootstrap.memory_lock": "true",
                                "network.host": "192.168.1.13",
                                "http.port": "9201",
                                "discovery.seed_hosts": "[\"192.168.1.11\", \"192.168.1.12\", \"192.168.1.13\"]",
                                "cluster.initial_master_nodes": "[\"node-1\"]",
                                "action.destructive_requires_name": "true",
                                "xpack.security.http.ssl.enabled": "true"
                            }
                        },
                        {
                            "description": ">>> es@192.168.1.13:22 >> action 3 >> luanch es and kibana",
                            "env": {
                                "ES_VER": ES_VER,
                            },
                            "sh_file": "./es/es_base_setting.sh"
                        }
                    ],
                    "description": "download remote es installation file and launch it"
                }
            ],
        ]
    }
]

# pre_settings = [
#     {
#         "sync": True,
#         "description": "go vpn",
#         "steps": [
#             [
#                 {
#                     "via": "dongfuqiang@127.0.0.1:22",
#                     "pwd": "dev123",
#                     "actions": [
#                         {
#                             "description": "localhost operation ... ",
#                             "local_sh_file": "./deploy/pre.sh",
#                         }
#                     ]
#                 }
#             ],
#             [
#                 {
#                     "via": "root@103.105.200.216:22",
#                     # #"pwd": "_DFQQFD123_",
#                     "pkey": "./ssh_certs/idc"
#                 },
#                 {
#                     "via": "root@159.138.122.25:22",
#                     # "pwd": "dev123",
#                     "pkey": "./ssh_certs/idc",
#                     "auto_complete": {  # auto set password for new es user
#                         # "New password:": "dev123",
#                         # "Retype new password:": "dev123"
#                     },
#                     "actions": [
#                         # {
#                         #     "description": ">>> root@159.138.122.25:22 >> deliver action >> 🇸🇬新加坡...",
#                         #     "env": {
#                         #         "P_KEY": "~/.ssh/idc",
#                         #     },
#                         #     "deliver": [
#                         #         "dist/v2ray-linux-64.tar.gz"
#                         #     ],
#                         # },
#                         {
#                             "description": ">>> root@159.138.122.25:22 >> deploy action >> 🇸🇬新加坡...",
#                             "env": {
#                                 "P_KEY": "~/.ssh/idc",
#                             },
#                             "sh_file": "./deploy/nginx.sh",
#                         }
#                     ],
#                     "description": "download remote es installation file and launch it"
#                 }
#             ],
#             [
#                 {
#                     "via": "root@103.105.200.216:22",
#                     # #"pwd": "_DFQQFD123_",
#                     "pkey": "./ssh_certs/idc"
#                 },
#                 {
#                     "via": "root@158.247.233.3:22",
#                     # "pwd": "dev123",
#                     "pkey": "./ssh_certs/idc",
#                     "auto_complete": {  # auto set password for new es user
#                         # "New password:": "dev123",
#                         # "Retype new password:": "dev123"
#                     },
#                     "actions": [
#                         # {
#                         #     "description": ">>> root@158.247.233.3:22 >> action >> 🇰🇷韩国首尔...",
#                         #     "env": {
#                         #         "P_KEY": "~/.ssh/idc",
#                         #     },
#                         #     "deliver": [
#                         #         "dist/v2ray-linux-64.tar.gz"
#                         #     ],
#                         # }
#                     ],
#                     "description": "download remote es installation file and launch it"
#                 }
#             ]
#         ],
#     },
# ]
