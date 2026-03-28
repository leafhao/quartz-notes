---
tags:
  - ssh
---

## **SSH连接服务器**

SSH连接服务器也可以直接使用`ssh user@ip -p port`来连接，但是有两个缺点：

1. 繁琐，每次连接的命令太长
2. 安全性不好，所有人都可以连接

因此，我们使用密钥连接.

### **生成密钥**

```bash
ssh-keygen -t rsa -b 4096 -C "hlf.hao"
```

全部按`Enter`，最后会在`~/.ssh/`文件夹下生成`id_rsa`和`id_rsa.pub`文件，分别为密钥和公钥

### **远程服务器连接**

```bash
mkdir .ssh
touch .ssh/authorized_keys
chmod 700 .ssh
chmod 644 .ssh/authorized_keys
```

然后把公钥复制到`authorized_keys`文件内

### **使用ssh连接远程服务器**

```bash
ssh user@ip -p port -i id_rsa_path
```

这样还是太麻烦了，可以把服务器信息存在本地配置文件中

```bash
# vim ~/.ssh/config
Host XXX
    Hostname ip
    User user
    IdentityFile ~/.ssh/id_rsa
```

可以通过`ssh XXX`直接连接

## **SSH连接GitHub**

### **配置本地git**

```bash
git config --global user.name "username"
git config --global user.email "email"
```

把公钥添加到github网站上,验证是否成功`ssh -T git@github.com`提示如下信息，说明连接成功