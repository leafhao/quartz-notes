---
tags:
  - mongo
---

## Mongodb安装

[下载地址](https://www.mongodb.com/try/download/community)

MongoDB server: 数据库服务器
Compass: 数据库操作的GUI

## 创建用户

```bash
use admin 
db.createUser({ 
	user: 'mongoadmin', 
	pwd: 'secret', 
	roles: [ { role: "root", db: "admin" } ] 
});
```

给普通用户授权
```bash
db.grantRolesToUser('admin': [{role: 'root', db: 'admin'}])
```

验证是否可以登录
```bash
use admin
db.auth("mongoadmin","secret")
```

查看进程是否启动
```
netstat -lanp | grep 27017
```

## 数据库配置

建议放在安装目录的`etc/xx.conf`内
```
systemLog:
  destination: file
  path: "path/mongodb.log" # 指定日志文件的路径
  logAppend: true # 是否追加的方式写， 默认true
storage:
  dbPath: "path/data" # 指定数据存储路径
  journal:
    enabled: true # 启用日志文件，默认启用
  wiredTiger:
    engineConfig:
      cacheSizeGB: 20 # 非常重要，不写的话会沾满整个内存，建议不要太大
processManagement:
  fork: true # 是否以守护进程的方式运行，默认false
net:
  bindIp: 0.0.0.0 # 设置ip
  port: 27017 # 设置端口
```

## 数据库启动

```bash
config=configpath

// 启动
numactl --interleave=all mongod --config $config --fork

// 关闭
numactl --interleave=all mongod --config $config --shutdown
```