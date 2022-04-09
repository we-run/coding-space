

from ctypes import sizeof
import os
import sys


# st_mode : inode保护模式
# st_ino : inode节点号
# st_dev : inode驻留的设备
# st_nlink : inode的连接数
# st_uid : 所有者的用户ID
# st_gid : 所有者的组ID
# st_size : 普通文件大小，字节为单位
# st_atime : 最后一次访问时间
# st_mtime : 最后一次修改时间
# st_ctime : 文件创建时间

collector = {}


# def list_store_hardlinks(target_path):
#     print(" start ... ")
#     for root, dirs, files in os.walk(target_path, topdown=False):
#         for f in files:
#             if not f.startswith("."):
#                 print(" --- file : %s" % os.path.join(root, f))
#                 print(" f : {} -> os mode : {}".format(f,
#                       os.stat(os.path.join(root, f))))
#         for d in dirs:
#             if not f.startswith("."):
#                 print(" == dir : %s" % os.path.join(root, d))
#                 print(" d : {} -> os mode : {}".format(f,
#                       os.stat(os.path.join(root, d))))


def init_collector(dir):
    for r, dl, fl in os.walk(dir, topdown=True, followlinks=True):
        for f in fl:
            f = os.path.join(r, f)
            st = os.stat(f)
            if st.st_nlink > 1 and st.st_ino == 16777231:
                print(" scan file : {} => {}" .format(f, st))
                collector[st.st_ino] = {
                    'link': f
                }

def continue_collect(dir):
    for r, dl, fl in os.walk(dir, topdown=False, followlinks=True):
        for f in fl:
            f = os.path.join(r, f)
            # if "node_module" in f:
            # print(" id : {}".format(os.path.join(r, f)))
            tryto = os.stat(f).st_ino
            if tryto in collector:
                print(" FOUND  :  %s" % f)

def parrent_dir(d):
    return os.path.split(os.path.abspath(d))[0]

def root_dir():
    return parrent_dir(parrent_dir(parrent_dir(__file__)))

def target_dir():
    return os.path.join(root_dir(), "base-shell/ln")


if __name__ == '__main__':
    init_collector(os.path.join(os.path.expanduser('~'), '.pnpm-store/v3/files'))
    # init_collector('/Volumes/DFQ/PAN/Work/5-TECH/web/xzl-webs')
    # continue_collect('/Volumes/DFQ/PAN/Work/5-TECH/web/xzl-webs')
    # continue_collect(os.path.join(os.path.expanduser('~'), '.pnpm-store/v3/files'))
    # print(sizeof(collector.keys))
    # print(len(collector))
    # init_collector(target_dir())
    # print(collector)
    # continue_collect(target_dir())
