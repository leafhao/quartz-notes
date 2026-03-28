---
tags:
  - python
  - jupyter
  - jupyterlab
---

## 安装

```bash
pip install jupyterlab
# 或者使用 conda
# conda install -c conda-forge jupyterlab
```

## 配置与运行

### 方法一：临时启动（推荐，最快）

**1. 在调试机启动**
建议先设置密码（仅需执行一次）：
```bash
jupyter lab password
```

启动 JupyterLab，允许外部连接：
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

**2. 在本地浏览器访问**

*   **方式 A：SSH 隧道（最安全）**
    在本地终端运行：
    ```bash
    ssh -N -f -L 8888:localhost:8888 用户名@调试机IP
    ```
    访问地址：`http://localhost:8888`

*   **方式 B：直接访问**
    确保调试机防火墙已开放端口，访问地址：`http://调试机IP:8888`

---

### 方法二：永久配置文件

**1. 生成配置文件**
```bash
jupyter lab --generate-config
```

**2. 修改配置文件**
编辑 `~/.jupyter/jupyter_lab_config.py`，取消注释并修改：
```python
c.ServerApp.allow_remote_access = True  # 允许远程连接
c.ServerApp.ip = '0.0.0.0'              # 监听所有地址
c.ServerApp.open_browser = False        # 不打开浏览器
c.ServerApp.port = 8888                 # 端口号
```
*注：新版本推荐使用 `c.ServerApp`，如果无效可尝试 `c.NotebookApp`。*

**3. 启动**
```bash
jupyter lab
```

---

## 进阶：后台运行与 VS Code 连接

### 1. 后台持久运行

为了防止断开 SSH 后 Jupyter 进程停止，可以使用以下方式：

**使用 `nohup` (简单):**
```bash
nohup jupyter lab --ip=0.0.0.0 --port=8888 --no-browser > jupyter.log 2>&1 &
```

**使用 `tmux` (推荐):**
1. 开启新 session: `tmux new -s jupyter`
2. 运行 jupyter 启动命令。
3. 按 `Ctrl+B` 然后按 `D` 退出 session。
4. 重新进入: `tmux attach -t jupyter`

### 2. 在 VS Code 中使用该远程内核

无需打开浏览器，直接在 VS Code 编辑器中调用远程算力：

1. **准备工作**：确保本地 VS Code 安装了 `Jupyter` 插件。
2. **连接地址**：
   - 若使用了 SSH 隧道：使用 `http://localhost:8888`
   - 若未用隧道：使用 `http://调试机IP:8888`
3. **配置内核**：
   - 打开 `.ipynb` 文件。
   - 点击右上角 **“选择内核 (Select Kernel)”** -> **“现有 Jupyter 服务器 (Existing Jupyter Server...)”**。
   - 输入上述地址并按回车。
   - 如提示密码，输入之前 `jupyter lab password` 设置的密码。
4. **获取 Token (如未设密码)**：
   ```bash
   jupyter server list
   ```
