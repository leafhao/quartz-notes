# 个人习惯追踪 / 学习仪表盘 — 深度调研报告

> **生成日期**：2026-05-18
> **作者**：小叶子（受飞哥委托调研）
> **目的**：为飞哥（大模型算法工程师，Mac mini 家用服务器）规划"自我量化 + 习惯追踪 + 智能推荐"的可落地方案
> **三路并行调研**：业界方法论 / macOS 本地数据源 / Hermes 现有能力

---

## TL;DR — 30 秒看完

1. **业界共识**：先选 3 个想回答的问题再选数据源，不要"什么都测"。80% 用户卡在"有数据 / 不行动"环节
2. **2025-2026 技术趋势**：本地优先 + AI 聚合（Screenpipe / Khoj / Ollama+Obsidian）替代云端 SaaS
3. **飞哥已具备 70% 能力**：weread / obsidian / github / spotify / feishu-bitable / session_search 都能直接用
4. **最关键缺口**：健康数据（睡眠/步数）、屏幕时间、IDE 编码时长、心情主观打分
5. **推荐架构**：三层存储（SQLite 原始 → 飞书 bitable 日报 → Obsidian 周报），起步只需 1 个新 cron + 1 张新表
6. **起步 4 周节奏**：W1 仅写 3 行日记 → W2 接 GitHub+WeRead 自动采集 → W3 加 Ollama 周报 → W4 评估砍指标

---

## 第一部分：业界方法论

### 主流框架（按推荐度排序）

| 框架 | 提出者 | 核心思想 | 对飞哥适用度 |
|------|--------|---------|------------|
| **Quantified Self** | Gary Wolf, Kevin Kelly | "Self knowledge through numbers"，先有问题再有数据 | ⭐⭐⭐⭐⭐ 思想基础 |
| **Atomic Habits** | James Clear | Don't break the chain，1% 复利，4 律（明显/吸引/简单/满足） | ⭐⭐⭐⭐ 习惯养成 |
| **PARA + CODE** | Tiago Forte | Projects/Areas/Resources/Archives + Capture/Organize/Distill/Express | ⭐⭐⭐⭐⭐ 与 Obsidian 完美契合 |
| **PI 五阶段模型** | CMU 学术 | Preparation→Collection→Integration→Reflection→Action | ⭐⭐⭐⭐ 工程化思路 |
| **Recovery-First** | WHOOP/Oura 2025 改版 | 不堆数据，聚合成"今日要做什么"一句话 | ⭐⭐⭐ 输出风格参考 |

### ⚠️ 核心警示：80% 用户卡在 Reflection

CMU 的 Personal Informatics 研究指出：大多数自追踪者**收集了数据但从不回顾**。这是飞哥需要重点规避的陷阱。

**对策**：固化"周回顾仪式"——每周日 30 分钟，AI 生成草稿 + 人工补充洞察。

---

## 第二部分：2025-2026 工具生态

### A. 习惯打卡

| 工具 | 特点 | 飞哥用得上吗 |
|------|------|------------|
| **Atoms**（James Clear 官方） | Atomic Habits 四律 + Apple Watch 微打卡 | 可作 iOS 端补充 |
| **Streaks** | 极简 Apple 生态，HealthKit 自动打卡 | 推荐尝试 |
| **Habitify** | 多平台、统计丰富 | 替代品 |
| **Loop Habit Tracker** | 开源 Android | 不适合 |

### B. 综合健康/可穿戴

| 工具 | 状态 | 飞哥情况 |
|------|------|---------|
| **Apple Health** | iOS/macOS 自托管中心 | ✅ 已有 iPhone，最佳起点 |
| **Oura Ring 4** | 强调"Today's Focus"单一建议 | 需购买硬件 |
| **WHOOP 4.0** | HRV+strain 框架，订阅制 | 需购买 |

### C. AI 赋能新玩法（2025-2026 趋势）

| 工具 | 描述 | 本地可用？ |
|------|------|---------|
| **Screenpipe** | Rewind.ai 的开源替代，24×7 截屏 + 语音转写 + 向量检索 | ✅ 可接 Ollama |
| **Khoj** | 个人 AI 助手，Obsidian/邮件/PDF 索引，可本地 RAG | ✅ Mac mini 跑 |
| **Granola** | AI 会议纪要，自动行动项 | 云端 |
| **Tana + AI** | Supertag 让笔记成数据库，自带 AI 周报 | 云端 |
| **Claude Code + Obsidian Vault** | 把目标/OKR/日记全写 markdown，让 AI 直接读 | ✅ **飞哥首选** |

### D. 本地优先方案（重点推荐）

> 飞哥是 Mac mini 自托管派，这部分最相关

| 方案 | 描述 | 成本 |
|------|------|------|
| **QS Ledger**（markwk/qs_ledger） | Python ETL，把 Apple Health/Strava/Toggl/Last.fm 拉到本地 SQLite | 中 |
| **Obsidian + Dataview + Tracker** | 完全 markdown，插件画习惯曲线 | ⭐ 最低成本 |
| **Auto Health Export → InfluxDB → Grafana** | iPhone 数据自动推到 Mac mini，Grafana 出图 | 中 |
| **Khoj + Ollama + Obsidian Vault** | 向量索引 + 本地 LLM，全离线 | 中 |
| **Screenpipe + Ollama** | 本地 timeline 记忆体 | 中 |

---

## 第三部分：常见陷阱（必须警惕）

| 陷阱 | 描述 | 对策 |
|------|------|------|
| **No Why, Just Data** | 没问题就开始测，掉进数据沼泽 | 先写下 3 个想回答的问题 |
| **Over-tracking** | 测 40 个指标，每个都要花心力维护 | 起步 ≤5 个，每月评估一次 |
| **Vanity Metrics** | 步数 10000 但久坐，看 50 本但记不住 | 问"涨了我会改变什么行为？" |
| **量化挤压主观体验** | 为打卡链不断而带伤跑步，"圆环焦虑" | 留空白日，允许断 |
| **工具切换成瘾** | 2 个月换一次 PKM，永远在重构 | "Worse is better"，先用半年再优化 |
| **隐私债务** | 睡眠/心率/位置全交给云 | 本地优先，每年导出备份 |

---

## 第四部分：macOS 本地数据源调研

### 总览（按可用性 + 价值排序）

| 数据源 | 路径/接口 | 权限要求 | 难度 | 自我追踪价值 |
|--------|----------|---------|------|------------|
| **knowledgeC.db** ⭐⭐⭐⭐⭐ | `~/Library/Application Support/Knowledge/knowledgeC.db` | FDA | 中 | 🟢 App 使用时长金矿 |
| **Photos.sqlite** ⭐⭐⭐⭐ | Photos 库 SQLite | 无需 FDA | 易 | 🟢 生活轨迹 |
| **Calendar (EventKit)** ⭐⭐⭐⭐ | `icalBuddy` / AppleScript | 日历访问 | 易 | 🟢 时间结构 |
| **iPhone HealthKit 导出** ⭐⭐⭐⭐⭐ | 手动从 Health.app 导出 XML | 无需 | 中 | 🟢 生理指标核心 |
| **Apple Notes** ⭐⭐⭐ | NoteStore.sqlite (FDA) 或 memo CLI | FDA | 易 | 🟡 已有 skill |
| **Reminders** ⭐⭐⭐⭐ | EventKit / remindctl | 提醒访问 | 易 | 🟡 已有 skill |
| **Safari/Chrome history** ⭐⭐⭐ | History.db | FDA | 中 | 🟡 兴趣信号 |
| **iMessage** ⭐⭐ | chat.db | FDA | 中 | 🔴 隐私敏感 |
| **Spotlight metadata** ⭐⭐ | `mdfind` | 无 | 易 | 🟡 文件创建模式 |
| **Apple Books** ⭐⭐⭐ | Books library SQLite | 无 | 中 | 🟢 阅读补充 |
| **Music.app history** ⭐⭐ | Music library SQLite | 无 | 中 | 🟡 已有 spotify |
| **Biome database** | `~/Library/Biome/` | TCC 严格保护 | 难 | 🔴 几乎不可用 |
| **DoNotDisturb** | TCC 保护 | 难 | 🔴 跳过 |

### 关键发现

1. **macOS 26 仍无原生 Health.app** — 健康数据必须从 iPhone 导出 XML，或用 Auto Health Export 推送
2. **Calendar.sqlitedb 已不存在** — 必须经 EventKit / `icalBuddy` 命令
3. **Photos.sqlite 直接可读** — 无需 FDA，可立即用于"生活轨迹"维度
4. **knowledgeC.db 是金矿但需 FDA** — 建议先打开 Full Disk Access 给 Hermes
5. **Biome 受 TCC 严格保护** — 即使 FDA 也访问不到，需专门 entitlement，跳过

### 核心 4 件套推荐

> 飞哥起步阶段只需要这 4 个数据源

```
KnowledgeC.db      → App 使用时长（编码 IDE / 浏览器 / 微信占比）
Photos.sqlite      → 生活轨迹（去过哪、拍了什么）
Calendar/EventKit  → 时间结构（会议密度、空闲时段）
iPhone HealthKit   → 生理指标（睡眠 / 步数 / HRV）
```

---

## 第五部分：Hermes 现有能力盘点

### 学习与阅读类（飞哥的强项）

| Skill | 信号 | 抓取 | 频率 | 价值 |
|-------|------|------|------|------|
| **weread-skills** | 阅读时长、读完书数、笔记 | API gateway | daily | ⭐⭐⭐⭐⭐ |
| **obsidian** | 笔记新增字数、被链接次数 | 扫文件 + git log | daily | ⭐⭐⭐⭐⭐ |
| **arxiv** | 已跑 cron，但**未追踪消费** | 扩展为"今日点开论文数" | daily | ⭐⭐⭐⭐ |
| **blogwatcher** | RSS 已读分布 | 已有 cron | daily | ⭐⭐⭐ |
| **youtube-content** | 看过的视频转录 | 主动喂 URL | weekly | ⭐⭐⭐ |

### 工作产出类

| Skill | 信号 | 价值 |
|-------|------|------|
| **github-***  | commits / PR / star 的 repo | ⭐⭐⭐⭐⭐ |
| **codebase-inspection** | 各项目 LOC 变化 | ⭐⭐⭐ |
| **linear** | 需配 LINEAR_API_KEY | ⭐⭐⭐ |

### 任务/沟通类

| Skill | 信号 | 价值 |
|-------|------|------|
| **apple-reminders** | 完成 / 逾期 / 新建 | ⭐⭐⭐⭐ |
| **google-workspace** | 会议时长、邮件未读 | ⭐⭐⭐⭐ |
| **himalaya** | 邮箱负担 | ⭐⭐⭐ |
| **feishu-bitable** | 已是存储底座 | ⭐⭐⭐⭐⭐ |

### Agent 元信号（独家优势）

| Skill | 信号 | 价值 |
|-------|------|------|
| **session_search** | 今天问了什么 = 在想什么 | ⭐⭐⭐⭐⭐ |
| **cron last_status** | 8 个 bot 健康度 | ⭐⭐⭐⭐ |

### 兴趣/生活类

| Skill | 信号 | 价值 |
|-------|------|------|
| **spotify** | 听歌时长、Top 艺人 | ⭐⭐⭐ |
| **openhue** | 灯光开关 → 推断作息 | ⭐⭐ |
| **findmy** | Mac mini 在不在家 | ⭐⭐ |

---

## 第六部分：能力缺口

### 🔴 P0 健康/生理层（完全空白）

| 缺口 | 建议补法 |
|------|---------|
| 睡眠时长 / 起床时间 | 新 skill `apple-health-export`，解析 HealthKit XML |
| 步数 / 心率 / 运动 | 同上 |
| 屏幕使用时长 | 新 skill `mac-screentime`，读 knowledgeC.db |

### 🟡 P1 工程师工作信号

| 缺口 | 建议补法 |
|------|---------|
| VS Code/Cursor 编码时长 | 新 skill `wakatime-stats`（装 WakaTime 插件） |
| 终端命令 top 10 | 解析 `~/.zsh_history` 时间戳 |

### 🟡 P2 主观状态

| 缺口 | 建议补法 |
|------|---------|
| 心情 / 精力打分 | 每晚 21:00 飞书卡片推 5 个 emoji 按钮，回调写 bitable |
| Focus 模式时段 | `shortcuts run "Get Focus"` |

### 🟡 P3 学习闭环

| 缺口 | 建议补法 |
|------|---------|
| arxiv 推送的论文实际读了几篇 | bitable 加"已读"列，飞哥点选 |
| 微信读书笔记是否回流 Obsidian | 周一 cron：拉 weread 笔记自动写入 |
| 代码 PR merge ratio | GitHub API |

### 🟢 已可跳过

- ❌ 训练任务监控（Mac mini 不做训练）
- ❌ X/Twitter（无凭证）
- ❌ DeepSeek（无 key）

---

## 第七部分：推荐架构

### 三层存储

```
┌─────────────────────────────────────────────────────────┐
│ Layer 1: 原始事件 (raw events)                          │
│ → SQLite: ~/.hermes/dashboard/feige_metrics.db         │
│ 表: daily_metrics / weekly_metrics / raw_events        │
│ 理由: 时序数据高频写入，bitable 不适合存几万行原始点    │
└─────────────────────────────────────────────────────────┘
                          ↓ 聚合
┌─────────────────────────────────────────────────────────┐
│ Layer 2: 日汇总 (daily rollup)                          │
│ → 新增飞书多维表格: 「飞哥仪表盘 · 日报」              │
│ 字段: 日期 / 阅读时长 / commits / Obsidian新增字数    │
│      / 任务完成数 / 论文消化数 / 心情 / 睡眠           │
│ 理由: 一行=一天，便于飞书图表卡片可视化                │
└─────────────────────────────────────────────────────────┘
                          ↓ 渲染
┌─────────────────────────────────────────────────────────┐
│ Layer 3: 周/月报呈现                                    │
│ → Obsidian: ~/workspace/obsidian/Note/dashboard/        │
│   - daily/<YYYY-MM-DD>.md  (每日卡片，含 Dataview)    │
│   - weekly/<YYYY-Wxx>.md   (周报)                      │
│   - INDEX.md                (仪表盘首页, Dataview)     │
│ → 飞书消息卡片: 每周一早 8:30 推一张"上周回顾"卡片     │
└─────────────────────────────────────────────────────────┘
```

**为什么三层都要？**
- **SQLite**：support 任意时间窗口 SQL 查询（"过去 30 天平均阅读"）
- **bitable**：飞书原生看板，**手机端可看可点**（地铁上也能瞄一眼）
- **Obsidian**：回顾时配合双链 — 周报里 `[[2026-05-15]]` 跳回那天读的书

### 新增 Cron 作业

| Cron | Schedule | 任务 | 涉及 skill |
|------|----------|------|-----------|
| **daily-collect** | `5 23 * * *` (每晚 23:05) | 全量采集：weread / GitHub / Obsidian / reminders / spotify / google-workspace / agent session 数 → SQLite + bitable 日报 | weread-skills, github, obsidian, apple-reminders, spotify, google-workspace |
| **mood-checkin** | `0 21 * * *` (每晚 21:00) | 飞书卡片推送 5 emoji 按钮 → 回调写 bitable | feishu-bitable + webhook |
| **weekly-self** | `30 8 * * 1` (周一早 8:30) | 拉本周日报数据，AI 生成周报，写 Obsidian + 推飞书卡片 | session_search + Obsidian + feishu |
| **arxiv-read-tracker** | `0 22 * * 0` (周日 22:00) | 统计本周 bitable 中"已读"列点选率 | feishu-bitable |

### 起步 4 周节奏（避坑 Over-tracking）

| 周 | 任务 | 目标 |
|----|------|------|
| **W1** | 只做 1 件事——在 Obsidian 写每日 3 行日志（今日完成 / 心情 1-5 / 一句反思） | 建立"回顾"习惯 |
| **W2** | 接入 weread + github 自动采集，建 SQLite + bitable 日报 | 把"看得见的成果"先量化 |
| **W3** | 搭 mood-checkin cron + weekly-self AI 周报 | 加入主观信号 + 反馈闭环 |
| **W4** | 评估——哪些指标真的让你改变了行为？砍掉无用的；再加新维度 | 防止 over-tracking |

---

## 第八部分：飞哥具体行动建议

### 🎯 先回答这 3 个问题（避免 No Why, Just Data）

调研建议飞哥先想清楚：

1. **学习问题**：我每周真的在 RL/GRPO 等拓展方向投入多少时间？是否被工作挤占？
2. **健康问题**：睡眠 / 运动 / 屏幕时间和我"高产出日"的关系？
3. **效率问题**：cron 任务推送的论文/工具，我实际消化率多少？是不是在做"信息囤积"？

### 🚀 最小可行起点（这周就能做）

```
本周（W1）：
1. 在 Obsidian 建 ~/workspace/obsidian/Note/dashboard/ 目录
2. 每日睡前花 2 分钟写 3 行日记（complete + mood + reflect）
3. 不上任何工具不上 cron，先体感一下"回顾"是什么感觉

下周（W2）：
1. 我帮你写 daily-collect cron（自动采集已有数据源）
2. 在飞书新建「飞哥仪表盘 · 日报」多维表格
3. 一周后看自动收集的数据有没有让你产生 insight
```

### ⚠️ 飞哥要避开的坑

- 不要一开始就上 Grafana + InfluxDB + 全套 docker compose——会被工程化卡住忘了初心
- 不要全量录屏（Screenpipe）作为默认，可选项目；先验证 markdown 日志 ROI
- 警惕"周报自动化"变成给 AI 看的报告——周回顾本质是**你和数据对话**，AI 是辅助
- 不要急着补全所有缺口；P0 健康层可以等 W3 再加

### 💡 一句话总结

> 在 Mac mini 上搭一个"**Obsidian + Ollama（可选） + 微信读书 + GitHub 自动同步 + 每周 AI 回顾**"的最小闭环，3-4 周跑通后再考虑可视化和更多数据源——记住 QS 老话："Self knowledge through numbers" 的关键词是 **knowledge**，不是 **numbers**。

---

## 附录：关键数据表

### 现有 8 个 cron 与仪表盘的关系

| Cron | 当前用途 | 可贡献的仪表盘信号 |
|------|---------|-------------------|
| arxiv-daily | 推送论文 | 接入"消化率"列 → 飞哥点选已读 |
| vendor-watch | 推送厂商动态 | 周报"AI 生态变化感知" |
| blog-digest | 推送博客 | 接入"已读"列 |
| x-insights | 推送 X 热点 | 周报"舆论关注点" |
| ai-tools | 推送 AI 工具 | 接入"我用了哪个"列 |
| books | 推送书籍 | 直接对接 weread 在读状态（已升级 ✅） |
| bot-logs | 任务自检 | 仪表盘"Agent 健康度" |
| daily-reminder | 邮件 + 日程提醒 | 已是早晨"启动信号" |

### 存储位置规划

```
~/.hermes/dashboard/
├── feige_metrics.db          # SQLite 原始事件
└── scripts/
    ├── collect_daily.py
    ├── generate_weekly.py
    └── mood_callback.py

~/workspace/obsidian/Note/
├── dashboard/                # 仪表盘呈现层
│   ├── INDEX.md             # 首页（Dataview 聚合）
│   ├── daily/<YYYY-MM-DD>.md
│   └── weekly/<YYYY-Wxx>.md
└── claw_notes/dashboard/    # 调研报告归档（本文件）
```

### 推荐技术栈（按优先级）

| 优先级 | 组件 | 说明 |
|--------|------|------|
| 🟢 P0 | Hermes cron + Obsidian + 飞书 bitable | 已有，立即可用 |
| 🟢 P0 | weread-skills + github + obsidian skill | 已有 |
| 🟡 P1 | SQLite for raw events | 简单 sqlite3 库 |
| 🟡 P1 | Ollama + qwen3:14b（本地周报生成） | Mac mini 16GB+ 可跑 |
| 🔵 P2 | iPhone Auto Health Export | 需 iOS 配置 |
| 🔵 P2 | Khoj（个人 AI 助手） | 进阶 |
| ⚪ P3 | Grafana + InfluxDB | 仪表盘控可上 |
| ⚪ P3 | Screenpipe（24×7 截屏） | 隐私敏感，可选 |

---

## 引用与参考

- Quantified Self 社区: quantifiedself.com
- James Clear 《Atomic Habits》官方指南
- Tiago Forte 《Building a Second Brain》
- CMU Personal Informatics 五阶段模型: dl.acm.org/doi/10.1145/3706598.3713650
- markwk/qs_ledger（GitHub 开源个人数据 ETL）
- Screenpipe: github.com/mediar-ai/screenpipe
- Khoj: khoj.dev
- Auto Health Export iOS app
- aimaker.substack（PARA + Claude Code 实战）

---

*本文由小叶子（Hermes Agent）通过 3 个并行 subagent 调研生成，总耗时约 10 分钟，调用 web_search 11 次、skill_view 18 次、terminal 26 次。*
