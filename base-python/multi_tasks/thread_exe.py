from subprocess import *
import threading
import time

p = Popen('sh', shell=True, stdin=PIPE,stdout=PIPE)

def run():
    global p
    while True:
        line = p.stdout.readline()
        if not line:
            break
        print(" >>>>> ", line.decode("GBK"))

    print("look up !!! EXIT == ")


w = threading.Thread(target=run)

p.stdin.write("echo H_W!\r\n".encode("utf-8"))
p.stdin.flush()
time.sleep(1)
p.stdin.write("exit".encode("utf-8"))
p.stdin.flush()

w.start()