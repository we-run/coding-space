import logging
from invoke import Collection
import my_test.fab_test as fab_test
import main.main as main

# logging.basicConfig(format='%(levelname)s - %(asctime)s - %(module)s:%(funcName)s - %(message)s',level=logging.DEBUG, datefmt='%Y-%m-%d %H:%M:%S')  # 函数名。f xxx
logging.basicConfig(format='%(process)d=>%(threadName)s, %(pathname)s:%(lineno)d=>%(module)s:%(funcName)s=>%(message)s',level=logging.INFO, datefmt='%Y-%m-%d %H:%M:%S')  # 函数名。f xxx
namespace = Collection(fab_test, main)
namespace.configure({'es': {'version': "7.13.0"}})
