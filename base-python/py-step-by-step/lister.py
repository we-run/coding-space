#!/usr/bin/env python


# - 列表推导

print([x for x in 'abc'])
print([symbol for symbol in '$¢£¥€¤'])
print([ord(s) for s in 'abc' if ord(s) > 97])

l = list(
        filter(lambda c: c > 127, map(ord, '$¢£¥€¤'))
    )
print(l.__class__)
print(''.__class__)


colors = ['black', 'white']
sizes = ['S' , 'M', 'L']

tshirts = [(c, s) for c in colors for s in sizes]
print(tshirts)


import collections
Card = collections.namedtuple('Card', ['rank', 'suit'])

class FrenchDeck:
    ranks = [str(n) for n in range(2, 11)] + list('JQKA')
    # suits = 'spades diamonds clubs hearts'
    suits = '黑桃 方片 梅花 红桃'
    def __init__(self) -> None:
        self._cards = [
            Card(rank, suit) 
            for suit in self.suits.split(" ")
            for rank in self.ranks
        ]

    def __len__(self):
        return len(self._cards)

    def __getitem__(self, pos):
        return self._cards[pos]


deck = FrenchDeck()

print('==> %s' % deck[12::13])

from random import choice
print(choice(deck))

print(' ---> {}'.format(Card('a', 'b')))


# - 生成器表达式， 不会一下生成所有元素， 而是迭代的逐个产出元素
symbols = '$¢£¥€¤'
tp = tuple(ord(symbol) for symbol in symbols)


import array
arr = array.array('I', (ord(symbol) for symbol in symbols))


print(arr, tp)



for thirt in ('%s %s'%(c, s) for c in colors for s in sizes):
    print(thirt)

a, *b, c = range(5)
print(a, c)



metro_areas = [
    ('Tokyo', 'JP', 36.933, (35.689722, 139.691667)),
    ('Delhi NCR', 'IN', 21.935, (28.613889, 77.208889)),
    ('Mexico City', 'MX', 20.142, (19.433333, -99.133333)),
    ('New Yourk-Newark', 'US', 20.104, (20.808611, -74.020386)),
    ('Sao Paulo', 'BR', 19.649, (-23.57778, -46.635833))
]
print('{:15} | {:^9} | {:^9}'.format('', 'lat.', 'long.'))
fmt = '{:15} | {:9.4} | {:9.4f}'

for name, cc, pop, (latitude, longitude) in metro_areas:
    if longitude <= 0:
        print(fmt.format(name, latitude, longitude))