

from asyncio.subprocess import PIPE
import os
import subprocess
from sys import stdin

def IsCygwin():
    # Function copied from pylib/gyp/common.py
    try:
        out = subprocess.Popen(
            "uname", stdout=subprocess.PIPE, stderr=subprocess.STDOUT
        )
        stdout, _ = out.communicate()
        print(" ---> %s", stdout)
        return "CYGWIN" in stdout.decode("utf-8")
    except Exception:
        return False


def pipe_test():
    p = subprocess.Popen('ls -al', shell=True, stdin=PIPE,stdout=PIPE)
    p.stdin.write('echo Hello\r\n'.encode('GBK'))
    

pipe_test()
print(IsCygwin())