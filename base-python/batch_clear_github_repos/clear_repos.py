
from mimetypes import init
from time import sleep
import requests

headers = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": "token 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",
    "X-OAuth-Scopes": "repo"
}


class AccessHeader:
    def __init__(self) -> None:
        self.Accept = "application/vnd.github.v3+json"
        self.X_OAuth_Scopes = "repo"

    def __format__(self, __format_spec: str) -> str:
        print(" ---> ")
        return str(headers)

if __name__ == '__main__':
    with open('./repos.txt', 'r', encoding='utf-8') as f:
        data = f.readlines()

    # res = requests.get(url="https://api.github.com/repositories", headers="".format(AccessHeader()))
    # print(" list repos : {}".format(res.content))

    url = "https://api.github.com/repos/{}/{}"
    urls = []
    for line in data:
        try_line = line.strip()
        if len(try_line) > 0:
            name, repo = line.strip().split("/")
            urls.append(url.format(name, repo))
    
    for l in urls:
        print("starting ... {}".format(l))
        res = requests.delete(url=l, headers=headers)
        print(res.content)
        sleep(2)

    print("access header : {}".format(AccessHeader()))
