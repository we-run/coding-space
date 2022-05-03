
from mimetypes import init
import random
from manim import *


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


class VectorArrow(Scene):
    def construct(self):
        dot = Dot(ORIGIN)
        arrow = Arrow(ORIGIN, [2, 2, 0], buff=0)
        numberplane = NumberPlane()
        origin_text = Text('(0, 0)').next_to(dot, DOWN)
        tip_text = Text('(2, 2)').next_to(arrow.get_end(), RIGHT)
        self.add(numberplane, dot, arrow, origin_text, tip_text)



def script_main():
    bingo = BingoCage(range(3))
    print(' - Caller Test bingo.pick() : {:3}'.format(bingo.pick()))
    print(' - Caller Test bingo() : {:3}'.format(bingo()))
    print(' 函数内省 >>> ')
    return __name__
