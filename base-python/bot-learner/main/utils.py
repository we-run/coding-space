
from copy import copy
from enum import Enum, auto
from mimetypes import init
import os
from getpass import getpass
from invoke import Responder
import paramiko
import re
from paramiko import RSAKey
from fabric2 import Connection, Config
from pathlib import Path


class TodoAction(object):
    def __init__(self, action: dict) -> None:
        pass


def create_conn_chain(chain) -> Connection:
    '''
    create one connection with password or ssh private key of auth
    '''
    if isinstance(chain, list):
        return __create_conn(chain, None)
    return None


def get_runner_auto_responder(auto_res: dict) -> list:
    '''
    create multi auto responder
    '''
    r = []
    for ik, iv in auto_res.items():
        r.append(Responder(
            # pattern=r'\[sudo\] password:'
            pattern=ik,
            response=iv + '\n'
        ))
    if len(r) > 0:
        return r
    else:
        return None


def __create_conn(chain, source: Connection):
    '''
    private method :
    recursive call and create connection with gateway to access remote host
    '''
    if len(chain) == 0:
        return source
    chain_u = chain[0]
    # deconstruct the elements with host info to init ssh connect
    via_host = re.findall(r'(\w+)(?:@)([.\d]+)(?::)(\d+)', chain_u['via'])
    (u, ip, port) = via_host[0]
    BLUE_LOG('PREPARE', "User : {}, IP : {}, Port: {}".format(u, ip, port))
    if chain_u.get('pwd') is not None:
        BLUE_LOG(
            'PREPARE', "Auth Mode - Login with passwords and its value is : {}".format(chain_u['pwd']))
        return __create_conn(chain[1:], Connection(user=u, host=ip, port=port, gateway=source, inline_ssh_env=True, connect_kwargs={
            'password': chain_u['pwd'],
            # 'allow_agent': False
        }))
    else:
        BLUE_LOG('PREPARE', "Auth Mode - Private key and its path is : {}".format(
            GET_CONF_FILE_PATH(chain_u.get('pkey'))))
        return __create_conn(chain[1:], Connection(user=u, host=ip, port=port, gateway=source, inline_ssh_env=True, connect_kwargs={
            'pkey': RSAKey.from_private_key_file(GET_CONF_FILE_PATH(chain_u.get('pkey')))
        }))


# get abs config file path

def GET_CONF_FILE_PATH(rp: str):
    return Path('./config', rp).resolve()


def SET_ENV_FOR_SHELL(env, content):
    for k, v in env.items():
        content = content.replace('$' + k, v)

def deploy_key(key, server, username, password):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(server, username=username, password=password)
    client.exec_command('mkdir -p ~/.ssh/')
    client.exec_command('echo "{}" > ~/.ssh/authorized_keys'.format(key))
    client.exec_command('chmod 644 ~/.ssh/authorized_keys')
    client.exec_command('chmod 700 ~/.ssh/')


def auto_dep():
    key = open(os.path.expanduser('~/.ssh/id_rsa.pub')).read()
    username = os.getlogin()
    password = getpass()
    hosts = ["hostname1", "hostname2", "hostname3"]
    for host in hosts:
        deploy_key(key, host, username, password)

# CUSTOME LOGGING OUTPUT


class LOG_COLOR(Enum):
    RED = 1
    GREEN = 2
    BLUE = 3
    YEELOW = 4


def GREEN_LOG(t, o):
    __LOG(LOG_COLOR.GREEN, t, o)


def RED_LOG(t, o):
    __LOG(LOG_COLOR.RED, t, o)


def BLUE_LOG(t, o):
    __LOG(LOG_COLOR.BLUE, t, o)


def __LOG(color: LOG_COLOR, title, output):
    pre = '--------------------------'
    bottom = copy(pre)
    pre = pre[0:len(pre)-(int)(len(title)/2)]
    upper = '{}{}{}'.format(pre, title, pre)
    print(upper)
    if color == LOG_COLOR.RED:
        print('\033[31m{}\033[0m'.format(output))
    elif color == LOG_COLOR.BLUE:
        print('\033[34m{}\033[0m'.format(output))
    elif color == LOG_COLOR.GREEN:
        print('\033[32m{}\033[0m'.format(output))
    elif color == LOG_COLOR.YEELOW:
        print('\033[33m{}\033[0m'.format(output))
    bottom = bottom[0:len(bottom) - 1]
    bottom = bottom + 'END' + bottom
    if len(bottom) > len(upper):
        bottom = bottom[0:len(bottom) - 1]
    elif len(bottom) < len(upper):
        bottom = bottom + '-'
    print(bottom)
