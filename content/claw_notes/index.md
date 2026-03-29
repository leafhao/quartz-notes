---
title: 🍃 小叶子笔记索引
description: Claw Notes 动态管理面板
---

# 🍃 小叶子笔记索引

> 最后更新：`$= dv.current().file.mtime`

---

## 📊 概览

| 分类 | 笔记数量 |
|------|----------|
| 📚 arXiv 论文 | `$= dv.pages('"claw_notes/arxiv-daily"').length` |
| ✍️ 博客摘要 | `$= dv.pages('"claw_notes/blog-digest"').length` |
| 🤖 AI 工具 | `$= dv.pages('"claw_notes/ai-tools"').length` |
| 📖 书籍推荐 | `$= dv.pages('"claw_notes/books"').length` |
| 🏢 厂商动态 | `$= dv.pages('"claw_notes/vendor-watch"').length` |
| 🐦 Twitter 热点 | `$= dv.pages('"claw_notes/x-insights"').length` |
| 🤖 机器人日志 | `$= dv.pages('"claw_notes/bot-logs"').length` |
| **总计** | **`$= dv.pages('"claw_notes"').length`** |

---

## 📚 arXiv 论文

最近 10 篇：

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) as "笔记",
  file.mtime as "更新时间"
FROM "claw_notes/arxiv-daily"
SORT file.mtime DESC
LIMIT 10
```

📁 [查看全部 arXiv 笔记](arxiv-daily/)

---

## ✍️ 博客摘要

最近 10 篇：

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) as "笔记",
  file.mtime as "更新时间"
FROM "claw_notes/blog-digest"
SORT file.mtime DESC
LIMIT 10
```

📁 [查看全部博客摘要](blog-digest/)

---

## 🤖 AI 工具推荐

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) as "笔记",
  file.mtime as "更新时间"
FROM "claw_notes/ai-tools"
SORT file.mtime DESC
LIMIT 10
```

📁 [查看全部 AI 工具](ai-tools/)

---

## 📖 书籍推荐

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) as "笔记",
  file.mtime as "更新时间"
FROM "claw_notes/books"
SORT file.mtime DESC
LIMIT 10
```

📁 [查看全部书籍](books/)

---

## 🏢 厂商动态

最近更新：

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) as "笔记",
  file.mtime as "更新时间"
FROM "claw_notes/vendor-watch"
SORT file.mtime DESC
LIMIT 10
```

📁 [查看全部厂商动态](vendor-watch/)

---

## 🐦 Twitter 热点

最近热点：

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) as "笔记",
  file.mtime as "更新时间"
FROM "claw_notes/x-insights"
SORT file.mtime DESC
LIMIT 10
```

📁 [查看全部 Twitter 热点](x-insights/)

---

## 🤖 机器人日志

```dataview
TABLE WITHOUT ID
  link(file.link, file.name) as "日志",
  file.mtime as "更新时间"
FROM "claw_notes/bot-logs"
SORT file.mtime DESC
LIMIT 10
```

📁 [查看全部日志](bot-logs/)

---

## 🔍 快速搜索

使用 `Ctrl+P` 打开命令面板，输入关键词搜索笔记。

---

## 📝 使用说明

1. **需要安装 Dataview 插件**：设置 → 第三方插件 → 搜索 "Dataview" → 安装启用
2. **启用 JavaScript 查询**：Dataview 设置 → 启用 "Enable JavaScript Queries"
3. 点击各分类标题可展开/折叠
4. 表格中的链接可点击跳转到具体笔记