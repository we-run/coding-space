

def consumer():
    r = ''
    while True:
        n = yield r
        if not n:
            return
        print(' CONSUMER - eating data %s ... ' % n)
        r = '200 OK'


def produce(c):
    c.send(None)
    n = 0
    while n < 5:
        n = n + 1
        print(" PRODUCER - product data %s ... " % n)
        r = c.send(n)
        print(' PRODUCER - consumer return : %s !' % r)
    c.close()


c = consumer()
produce(c)