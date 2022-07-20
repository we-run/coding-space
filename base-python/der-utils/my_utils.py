import re
import os
import sys
import pyautogui
import requests


# import json

def get_mac_address():
    '''
    @summary: return the MAC address of the computer
    '''
    mac = ""
    if sys.platform == "win32":
        for line in os.popen("ipconfig /all"):
            # print(line)
            r = re.search(r'((([a-f\d]{2}:){5})|(([a-f\d]{2}-){5}))[a-f\d]{2}', line, re.IGNORECASE)
            if r is not None:
                # print(r.group(0))
                mac = mac + ">\n" + r.group(0)
            # if line.lstrip().startswith("Physical Address"):
            #       mac = line.split(":")[1].strip().replace("-", ":")
            #       break
    else:
        for line in os.popen("/sbin/ifconfig"):
            # print(line)
            r = re.search(r'((([a-f\d]{2}:){5})|(([a-f\d]{2}-){5}))[a-f\d]{2}', line, re.IGNORECASE)
            if r is not None:
                # print(r.group(0))
                mac = mac + ">\n" + r.group(0)
            # if 'Ether' in line:
            #       mac = line.split()[4]
            #       break
    return mac


res = requests.post('http://api.xzlcorp.com/ntest/devops/upload', None, {
    "username": pyautogui.prompt('请输入姓名:'),
    "content": get_mac_address()
})

pyautogui.alert(res.status_code, "完成")  # always returns "OK"
