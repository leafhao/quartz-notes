---
tags:
  - DeepSeek
  - LLM
  - Architecture
  - PaperReading
  - 学习笔记
date: 2026-01-18
topic: Conditional Memory via Scalable Lookup (Engram)
---

# DeepSeek Engram 论文解读笔记

**论文标题**: Conditional Memory via Scalable Lookup: A New Axis of Sparsity for Large Language Models
**核心概念**: **Engram 模块** —— 一种通过可扩展查找实现的条件记忆（Conditional Memory）。

## 1. 核心痛点与动机

*   **现状**: 现代 LLM 主要依赖 **MoE (Mixture-of-Experts)** 进行“条件计算”。
*   **问题**: Transformer 缺乏原生的“查表”机制。模型被迫使用昂贵的计算资源（Attention/FFN）来模拟检索，去重构静态知识（例如记住 "Diana, Princess of Wales"）。这是一种对算力的浪费。
*   **灵感**: 语言由“动态逻辑”和“静态模式（公式化知识）”组成。后者适合用经典的 $N$-gram 思想来处理。

## 2. 解决方案：Engram 模块

Engram 是一个外挂式的、基于 $N$-gram 的静态键值对存储系统，旨在以 $O(1)$ 的复杂度提供巨量的记忆能力。

### 核心工作流

1.  **稀疏检索 (Sparse Retrieval) —— “查表”**
    *   **分词器压缩**: 将语义相同但格式不同（如 `Apple` vs ` apple`）的 Token 映射为同一个 **Canonical ID**。这使得词表缩小（约 23%），提高了语义密度。
    *   **多头哈希 (Multi-Head Hashing)**: 解决 $N$-gram 组合爆炸问题。不存储确定的 Key，而是通过 $K$ 个哈希头映射到巨大的 Embedding 表中。虽然引入了哈希冲突，但极大压缩了空间。

2.  **上下文感知融合 (Fusion) —— “去噪”**
    *   **机制**: 变体的 QKV Attention。
        *   **Query**: 主干网络的隐藏状态 $h_t$（含上下文）。
        *   **Key/Value**: 检索到的静态向量 $e_t$（含噪声）。
    *   **门控 (Gating)**: 计算相似度 $\alpha_t$。如果语境对齐，融合记忆；如果不对齐（噪声），$\alpha_t \to 0$，抑制噪声。

3.  **多分支集成**
    *   共享 Embedding 表和 Value 矩阵，但不同分支有独立的 Key 矩阵（独立的门控判断），高效且灵活。

## 3. 核心哲学：语义与格式的解耦

Engram 实际上是一个**“致力于提取纯粹语义的特殊分词器”**。

*   **路径 A（主干网络）**: 保留原始 Token ID，**保留格式信息**（如大小写、空格）。负责最终的生成和逻辑控制。
*   **路径 B（Engram）**: 进行归一化和 N-gram 组合，**提取纯粹语义**。负责提供“知识包”作为参考。
*   **融合**: 通过残差连接 ($H \leftarrow H + Y$)，Engram 的语义向量“增强”了主干网络的状态，而不是替换它。

## 4. 模型架构

![](http://imageocean.longfeihao.eu.org/arch.png)


## 5. 核心创新与优势

1.  **释放算力，提升推理 (Better Reasoning)**
    *   把“死记硬背”的任务外包给 Engram。
    *   主干网络从琐碎的模式匹配中解放出来，拥有更有效的深度去处理复杂逻辑、代码和数学（BBH +5.0）。

2.  **提升长文本能力 (Better Long Context)**
    *   Engram 解决了局部依赖（Local Dependency）。
    *   Attention 机制不再需要关注相邻词，可以全力关注全局上下文（NIAH 任务显著提升）。

3.  **系统级效率与存算分离 (Infrastructure Efficiency)**
    *   **确定性寻址**: 查表只依赖输入 Token，不依赖中间层计算。
    *   **预取 (Prefetching)**: 可将巨大的 Embedding 表（如 100B+）放在 **CPU 内存** 或 SSD。利用 GPU 计算的时间窗口，异步预取数据。
    *   **结果**: 极大扩展模型容量，几乎零推理延迟增加，突破 GPU 显存限制。

## 6. 总结

传统模型是“用脑子（计算）死记硬背”，Engram 模型是“给脑子配了一本字典（查表）”。遇到固定搭配先查字典，脑子只负责思考逻辑。
