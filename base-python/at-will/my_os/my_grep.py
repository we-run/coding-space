

import os
import sys

total = 0

def find_files(path, names):
    for root,dirs,files in os.walk(path):
        for f in files:
            name = os.path.join(root, f)
            names.append(name)


def search_word(path, word):
    lnum = 1
    global total
    with open(path, 'r', encoding='UTF-8', errors='ignore') as f:
        for line in f.readlines():
            if word in line:
                print('total : %d' % total)
                print(' file : %d' + path)
                print(' line : %d' % lnum + line)
                total = total + 1
        lnum = lnum + 1

dire = sys.argv[1]
word = sys.argv[2]
paths = []

find_files(dire, paths)
l = len(paths)


for i in range(l):
    search_word(paths[i], word)

