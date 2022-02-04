
from importlib.resources import path
from math import fabs
import os 
import sys


print(" USER HOME 1 > %s" % os.environ['HOME'])
print(" USER HOME 2 > %s " % os.path.expandvars('$HOME'))
print(" USER HOME 3 > %s" % os.path.expanduser('~'))

print(" 1> 当前工作目录 : %s " % os.getcwd())
print(" >>> 文件路径 : %s" % sys.path[0])
print(" >>> 文件: %s" % __file__)
print(" >>>> 绝对路径 : %s" % os.path.abspath(__file__))
print(" >>>> 所在路径: %s" % os.path.realpath(__file__))
print(" >>>> split : {}" .format( os.path.split(os.path.realpath(__file__)) ))


print(" 2> 当前目录列表 :" )
for f in os.listdir(path="../"):
    if not f.startswith('.'):
        print(f)


print(" 3> 遍历文件列表: ")

# for root, dirs, files in os.walk("", topdown=True):
#     for name in files:
#         print(os.path.join(root, name))
#     for name in dirs:
#         print(os.path.join(root, name))

print(" 3> 过滤目标文件: ")
# for d in os.listdir():
    
    