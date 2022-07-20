
# 0. 读取 指定的目录
# 1. 加载 json请求体 <= 
# 2. 构造 url
# 3. 构造 请求头
# 3. 构造 HTTPS认证证书
# 4. 构造 用户授权

import json
import os
import re


class LearnerCatalog(object):
    def __init__(self) -> None:
        # os.path.dirname(os.path.realpath(__file__))
        self._root = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
        self._config_base = self._root + '/config'
        self._active_dir = self._config_base

    def es(self):
        self._active_dir = self._config_base + "/es"
        return self

    def cluster(self):
        self._active_dir = self._config_base + "/es/cluster"
        return self

    def index(self):
        self._active_dir = self._config_base + "/es/index"
        return self

    def query(self):
        self._active_dir = self._config_base + "/es/query"
        return self

    def search(self):
        self._active_dir = self._config_base + "/es/search"
        return self

    def resource(self, target='v2ray'):
        self._active_dir = self._root + "/resource"
        return self

    def dist(self, target='v2ray-linux-64.tar.gz'):
        if target.startswith('dist/'):
            target = target.replace('dist/', '', 1)
        return self._root + "/dist/" + target

    def load_json(self, file_name: str = None):
        if '.' in file_name:
            file_name = file_name.replace('.', '\.')
        for root, dirs, files in os.walk(self._active_dir):
            for file in files:
                if file.endswith('.json') and re.match(file_name, file):
                    print(root + '/' + file)
                    with open(root + '/' + file) as f:
                        return json.load(f)


class ESRequestBuilder(object):

    def __init__(self, catalog: LearnerCatalog = LearnerCatalog()) -> None:
        self._base_url = "http://103.105.200.216:9201"
        self._catalog = catalog

    def search_path(self):
        return "{}/{}".format(self._base_url, self._active_index)
        
    def make_index(self):
        pass
    
    def auth(self):
        self._auth = {
            "user": "elastic",
            "password": "xxx"
        }
    
    @classmethod
    def HEADER(self):
        return {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Basic ZWxhc3RpYzpoSlJmMWdEbFVyZEFwZ1YrUV9QaA=="
        }


# ESRequestBuilder(LearnerCatalog()).auth().

# print(ESRequestBuilder.HEADER())

# print(LearnerCatalog().index().load_json('create_english_a'))
