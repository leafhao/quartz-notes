---
tags:
  - ssh
  - vscode
---




一般是因为操作系统老旧，可使用vscode1.85，然后设置不自动更新就可以连接。
这里介绍一种使用docker创建一个虚拟机，然后vscode连接这个虚拟机的方式。


### 安装docker(如无)


### 拉取一个新版ubuntu镜像

```bash
sudo docker pull ubuntu:20.04
```
官方镜像无法连接，可网上搜已给可替代的国内镜像
### 运行容器

并将容器的 SSH 端口（22）映射到宿主机的一个端口上（例如 2222 ）。同时，为了方便在容器内访问和修改文件，可以将宿主机的工作目录挂载到容器中。

```bash
sudo docker run -d -p 2222:22 --name trae-dev-env -v /path/to/your/workspace:/root/workspace ubuntu:20.04 tail -f /dev/null
```

`tail -f /dev/null` 是为了让容器保持在后台运行。

### 在容器内配置ssh服务

进入容器
```bash
sudo docker exec -it trae-dev-env /bin/bash # 或 /bin/zsh
```

安装ssh必要的包
```bash
# 更新软件包列表
apt-get update

# 安装 SSH 服务和一些常用工具
apt-get install -y openssh-server vim git

# 允许 root 用户通过 SSH 登录
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 设置 root 用户密码 (请替换为您自己的密码)
echo 'root:your_password' | chpasswd

# 启动 SSH 服务
service ssh start # 重启 restart
```

### 本机连接容器

```bash
ssh root@<your_remote_server_ip> -p 2222
```
这里可以利用ssh-copy-id上传公钥，进行免密登录

### 容器保存为新镜像

为当前容器安装好必要的软件和配置，然后将该容器保存为新的镜像，以后就可以用这个新镜像了

```bash
docker commit -a "Your Name" -m "Install trae and dependencies" trae-ubuntu my-trae-image:v1.0
```


### 下次运行
```bash
sudo docker run -d -p 2222:22 --name vscode-env -v /data4:/data4 vscode-ubuntu:v1.1 tail -f /dev/null # 后台开一个容器

sudo docker exec -it vscode-env /bin/zsh # 进入容器

service ssh start # 启动ssh服务
```