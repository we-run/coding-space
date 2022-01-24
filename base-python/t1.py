

import argparse
import os.path
import re
import shlex
import sys
import collections
from collections.abc import Mapping
import m1

import json




print(collections.__file__)
print(os.path.abspath('./'))


print([1] + [1, 2, 3])


class MYApp:
    def __init__(self) -> None:
        pass

    def go(self):
        return 'YES'


app = MYApp()
print(hasattr(app, 'go'))
print(hasattr(app, 'gos'))

print('DQ - VERSION : {}'.format(sys.version))
print(' DQ - CALLER : {}', callable(app))

# def as_json(kv):
#     print('DQ - %s' % kv)
#     assert '=' in kv
#     k, v = kv.split('=', 1)
#     v2 = 'GEN_DQ'
#     try:
#         return k, json.loads(v2)
#     except ValueError as e:
#         print((k, v, v2))
#         raise e


# print(dict(map(as_json, "current_cpu=x64")))

# with open('./test.json', 'w') as f:
#     json.dump()


print(' ====> <=== ')



if __name__ == "__main__":

    print(" >>> m1 running ... ")
    m1.script_main()
    sys.exit(0)
