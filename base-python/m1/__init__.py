
from mimetypes import init
import random


# 验证自定义可调用类型
class BingoCage:
    def __init__(self, items) -> None:
        self._items = list(items)
        random.shuffle(self._items)
    def pick(self):
        try:
            return self._items.pop()
        except IndexError:
            raise LookupError('pick from empty BingoCage')
    def __call__(self):
        return self.pick()


def script_main():
    bingo = BingoCage(range(3))
    print(' - Caller Test bingo.pick() : {:3}'.format(bingo.pick()))
    print(' - Caller Test bingo() : {:3}'.format(bingo()))

    print(' 函数内省 >>> ')
    
    return __name__