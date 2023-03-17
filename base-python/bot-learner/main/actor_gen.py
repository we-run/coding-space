from collections import deque

class ActorScheduler:
    def __init__(self):
        self._actors = {}
        self._msg_queue = deque()

    def new_actor(self, name , actor):
        self._actors[name] = actor
        self._msg_queue.append((actor, None))

    def send(self, name, msg):
        actor = self._actors.get(name)
        if actor:
            self._msg_queue.append((actor, msg))

    def run(self):
        while self._msg_queue:
            actor, msg = self._msg_queue.popleft()
            try:
                actor.send(msg)
            except StopIteration:
                pass


if __name__ == '__main__':
    print(' Starting ... ')

    def printer():
        while True:
            msg = yield
            print('Got_A : ', msg)

    def printer_1():
        while True:
            msg = yield
            print('Got_B : ', msg)

    def counter(sched):
        while True:
            n = yield
            if n == 0:
                break
            sched.send('printer', n)
            sched.send('printer_1', n)
            sched.send('counter', n - 1)

    sched = ActorScheduler()
    sched.new_actor('printer', printer())
    sched.new_actor('printer_1', printer_1())
    sched.new_actor('counter', counter(sched))

    sched.send('counter', 1000)
    sched.run()
