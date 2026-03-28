---
tags:
  - python
---

## 预安装

有时安装会因为缺少必要的环境导致失败，因此需要提前安装一下相关环境

```bash
sudo apt-get install -y make build-essential libssl-dev \\
	zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \\
	wget curl llvm libncurses5-dev libncursesw5-dev \\
	xz-utils tk-dev libffi-dev liblzma-dev
```

## 安装pyenv

1. 安装

```bash
curl -L <https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer> | bash
```

<aside> 💡 如果报连接失败，可以把pyenv-installer手动下载到本地，然后`bash pyenv-installer` 完成安装

</aside>

1. 添加环境至`~/.zshrc`或`~/.bashrc`

```bash
# XXX 是个人目录地址
export PATH="/home/XXX/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

1. 刷新终端

```bash
source ~/.bashrc #或 source ~/.zshrc
```

1. 安装python环境，官方略慢，可以使用国内镜像

```bash
# 安装pyenv
v=3.7.0;wget <https://npm.taobao.org/mirrors/python/$v/Python-$v.tar.xz> -P ~/.pyenv/cache/;pyenv install $v
```

1. 验证

```bash
pyenv versions
```

## python切换

```bash
pyenv global 2.7.3 # 设置全局的 Python 版本，通过将版本号写入 ~/.pyenv/version 文件的方式。
pyenv local 2.7.3 # 设置 Python 本地版本，通过将版本号写入当前目录下的 .python-version 文件的方式。通过这种方式设置的 Python 版本优先级较 global 高。
pyenv shell 2.7.3 # 设置面向 shell 的 Python 版本，通过设置当前 shell 的 PYENV_VERSION 环境变量的方式。这个版本的优先级比 local 和 global 都要高。–unset 参数可以用于取消当前 shell 设定的版本
pyenv shell --unset
pyenv rehash # 创建垫片路径（为所有已安装的可执行文件创建 shims，如：~/.pyenv/versions/*/bin/*，因此，每当你增删了 Python 版本或带有可执行文件的包（如 pip）以后，都应该执行一次本命令）
```

<aside> 💡 python优先级

shelll > local > global

</aside>

## 常用命令