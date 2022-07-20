# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press ⌘F8 to toggle the breakpoint.


# s = "ABACABABAB"
#         #01234567
# p =     "ABCABCAC"
          #
s = "BAAAAAAAAA"
p = "ABABAC"
def buildNxt():
    nxt = []
    nxt.append(0)
    x = 1
    now = 0
    # x = 1>2>3->4->5->6 7
    # now 0 0 0->1->2
    while x < len(p):
        if p[now] == p[x]:
            now += 1
            x += 1
            nxt.append(now)
        elif now:
            now = nxt[now - 1]
        else:
            nxt.append(0)
            x += 1
    return nxt


def search():
    nxt = buildNxt()
    print(''.join(map(str, nxt)))
    tar = 0
    pos = 0
    while tar < len(s):
        if s[tar] == p[pos]:
            tar += 1
            pos += 1
        elif pos:
            print("{} +++> {}".format(tar, pos))
            pos = nxt[pos - 1]
            print("{} ---> {}\n".format(tar, pos))
        else:
            print("{} ===> {}".format(tar, pos))
            tar += 1
            print("{} >>>> {}\n".format(tar, pos))

        if pos == len(p):
            print(tar - pos)
            pos = nxt[pos - 1]


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    search()
