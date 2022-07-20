

## 依赖项说明
```shell
pip install pyinstaller
```

## 编译出二进制文件
(pyinstaller 参考)[https://ningyu1.github.io/site/post/59-py2exe-pyinstaller/]

(python UI组件参考)[https://www.devdungeon.com/content/dialog-boxes-python]

```shell
pip install pyinstaller
pip install requests
python -m pip install pyautogui

# 编译二进制文件输出
pyinstaller -w -F -p . my_utils.py
```


## 运行环境安装

### Resinstall Xcode
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install

### Install zlib and bzip2 using brew
```shell
brew reinstall zlib bzip2
```
 
### Install tcl-tk tkinter
```shell
brew install tcl-tk
```

### Uninstall previous versions from python
```shell
pyenv uninstall 3.8.3
pyenv uninstall 3.9.0
```

### Install python 3.8.3 patched
```shell
env \
  PATH="$(brew --prefix tcl-tk)/bin:$PATH" \
  LDFLAGS="-L$(brew --prefix tcl-tk)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" \
  CPPFLAGS="-I$(brew --prefix tcl-tk)/include -L$(brew --prefix zlib)/include -L$(brew --prefix bzip2)/include" \
  PKG_CONFIG_PATH="$(brew --prefix tcl-tk)/lib/pkgconfig" \
  CFLAGS="-I$(brew --prefix tcl-tk)/include -I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix zlib)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include" \
  LDFLAGS="-I$(brew --prefix tcl-tk)/lib -L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib"
  pyenv install --patch 3.8.3 < <(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch\?full_index\=1)
```
  
```shell
env \
  PYTHON_CONFIGURE_OPTS="--enable-framework" \
  PATH="$(brew --prefix tcl-tk)/bin:$PATH" \
  LDFLAGS="-L$(brew --prefix tcl-tk)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" \
  CPPFLAGS="-I$(brew --prefix tcl-tk)/include -L$(brew --prefix zlib)/include -L$(brew --prefix bzip2)/include" \
  PKG_CONFIG_PATH="$(brew --prefix tcl-tk)/lib/pkgconfig" \
  CFLAGS="-I$(brew --prefix tcl-tk)/include -I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix zlib)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include" \
  LDFLAGS="-I$(brew --prefix tcl-tk)/lib -L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix zlib)/lib -L$(brew --prefix bzip2)/lib" \
  pyenv install 3.10.4
```
