# MCP (Model Context Protocol) 使用指南

> [!metadata]
> - **创建时间**: 2026/1/12 16:42:31
> - **标签**: #MCP #AI工具 #开发工具 #模型上下文协议

## 📖 概述

> [!summary] 什么是 MCP？
> **MCP（Model Context Protocol）** 是一个开源标准协议，旨在统一 AI 模型与外部工具、数据源之间的交互方式。它打破了由于平台差异导致的“孤岛效应”，允许 AI 助手（如 Claude、ChatGPT 等）以标准化的方式安全地访问本地文件、GitHub 仓库、数据库等外部资源，而无需为每个工具单独开发集成代码。

---

## 🎯 核心概念

### 1. MCP 架构示意

```mermaid
flowchart LR
    A["AI 助手<br>(Claude/ChatGPT)"] -->|"MCP 协议"| B["MCP 客户端<br>(Host应用)"]
    B -->|"请求"| C["MCP 服务器<br>(工具/数据提供者)"]
    C -->|"响应"| B
    B -->|"上下文"| A
```

*(注：以上为简化的逻辑架构)*

### 2. 关键组件

| 组件 | 说明 |
| :--- | :--- |
| **MCP 服务器 (Server)** | 负责实际功能的实现，如访问文件系统、查询数据库。它通过 MCP 协议暴露“资源”和“工具”。 |
| **MCP 客户端 (Client)** | 也就是宿主应用（Host），如 Claude Desktop。它负责连接服务器，并将服务器的能力转发给 AI 模型。 |
| **工具 (Tools)** | 服务器提供的具体可执行函数（Function Calling），例如“读取文件”、“执行 SQL”。 |
| **资源 (Resources)** | 服务器暴露的数据内容，AI 可以像读取文件一样读取它们。 |

---

## 🔧 安装与配置

### 1. 客户端准备
目前，**Claude Desktop** 是最常用的 MCP 客户端。通常无需额外安装专门的“MCP 客户端软件”，只需配置 Claude Desktop 的设置文件即可。

### 2. 服务器配置示例
配置文件通常位于 `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) 或 `%APPDATA%\Claude\claude_desktop_config.json` (Windows)。

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/username/Documents",
        "/Users/username/Projects"
      ]
    },
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-token-here"
      }
    }
  }
}
```

---

## 🛠️ 常用 MCP 服务器推荐

这里列出官方和社区维护的高频使用服务器：

### 1. 文件系统 (Filesystem)
允许 AI 读写本地文件，是开发和文档管理的必备工具。
- **安装命令**: `npx -y @modelcontextprotocol/server-filesystem <路径>`
- **主要能力**:
    - `read_file`: 读取文件内容
    - `write_file`: 创建或修改文件
    - `list_directory`: 查看目录结构

### 2. GitHub
让 AI 直接与你的代码仓库交互。
- **安装命令**: `npx -y @modelcontextprotocol/server-github` (需配置 Token)
- **主要能力**:
    - `search_repositories`: 搜索仓库
    - `get_file_contents`: 读取代码
    - `create_issue`: 创建 Issue

### 3. 浏览器 (Browser / Puppeteer)
允许 AI 访问网页内容。
- **安装命令**: `npx -y @modelcontextprotocol/server-puppeteer`
- **主要能力**:
    - `navigate`: 访问 URL
    - `screenshot`: 网页截图
    - `click`: 点击元素

---

## 📝 开发与使用示例

*(以下代码仅为逻辑示意，实际调用通常由 AI 自动完成，或在自定义客户端中通过 SDK 调用)*

### 场景 1: 文件操作流程
```javascript
// 1. 读取原始文件
const content = await client.callTool({
  name: "filesystem_read_file",
  arguments: { path: "/projects/docs/readme.md" }
});

// 2. AI 处理内容...

// 3. 写入新文件
await client.callTool({
  name: "filesystem_write_file",
  arguments: {
    path: "/projects/docs/readme_updated.md",
    content: "# 更新后的文档\n..."
  }
});
```

### 场景 2: 组合多个工具 (工作流)
```javascript
// 1. 搜索项目中的 TODO
const todos = await client.callTool({
  name: "filesystem_grep",
  arguments: { pattern: "TODO", path: "/src" }
});

// 2. 为每个 TODO 创建 GitHub Issue
for (const todo of todos.matches) {
  await client.callTool({
    name: "github_create_issue",
    arguments: {
      title: `Fix: ${todo.text}`,
      body: `Found in ${todo.file}:${todo.line}`
    }
  });
}
```

---

## ⚡ 最佳实践与技巧

### 🛡️ 安全性建议
> [!WARNING] 注意权限控制
> MCP 服务器拥有你赋予的权限（如文件读写）。
> - **最小权限原则**: 只将特定项目目录传递给 `filesystem` 服务器，而不是整个用户目录。
> - **敏感数据**: 不要在配置文件中直接硬编码 API Key，尽量使用环境变量。

### 🚀 性能优化
- **减少上下文窗口占用**: 读取大文件时，尽量先读取目录或摘要，而不是一次性加载所有文件内容。
- **工具链组合**: 将复杂任务拆解为“搜索 -> 读取 -> 处理 -> 写入”的步骤，引导 AI 一步步执行。

### 🔍 调试技巧
如果 Claude 无法连接服务器：
1. 检查 `claude_desktop_config.json` 语法是否正确的 JSON。
2. 查看 Claude Desktop 的日志（通常在 `~/Library/Logs/Claude`）。
3. 尝试在终端单独运行 `npx ...` 命令，确保本地环境（Node.js）配置正确且没有报错。

---

## 🔗 资源导航

> [!TIP] 官方资源
> - **文档**: [Model Context Protocol Docs](https://modelcontextprotocol.io/)
> - **规范**: [MCP Specification](https://spec.modelcontextprotocol.io/)
> - **官方服务器列表**: [MCP Servers Repo](https://github.com/modelcontextprotocol/servers)

---

## 📝 更新日志

| 版本 | 日期 | 更新内容 |
| :--- | :--- | :--- |
| v1.1 | 2026/1/13 | 内容润色，增加 Mermaid 图表，优化配置示例 |
| v1.0 | 2026/1/12 | 初始版本创建 |

> [!note]
> 本指南根据 MCP 协议的最佳实践整理。随着协议升级，建议定期查阅官方文档。
