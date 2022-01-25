#!/usr/bin/env python
from math import hypot


print('A' 'B' 'C')
print(hypot(-1, -2))


class Vector:
    def __init__(self, x = 0, y = 0) -> None:
        self.x = x
        self.y = y
    def __repr__(self) -> str:
        return 'Vector(%r, %r)' % (self.x, self.y)
    def __abs__(self):
        return hypot(self.x, self.y)
    def __bool__(self):
        return bool(abs(self))
    def __add__(self, other):
        x = self.x + other.x
        y = self.y + other.y
        return Vector(x, y)
    def __mul__(self, scalar):
        return Vector(self.x * scalar.x , self.y * scalar.y)

v1 = Vector(1, -2)
v2 = Vector(3, 4)
print(bool(v1))
print(abs(v1))

print(v1 + v2)
# 列表、元组、数组、队列
# list  tuple collections.deque -> 不同的数据类型
# str bytes bytearray memoryview array.array -> 一种类型
