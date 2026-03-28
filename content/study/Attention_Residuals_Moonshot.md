# Attention Residuals: 用注意力替代残差连接

> **论文来源**: Moonshot AI (月之暗面/Kimi)  
> **发布时间**: 2026年3月15日  
> **GitHub**: https://github.com/MoonshotAI/Attention-Residuals  
> **标签**: #Transformer架构 #残差连接 #注意力机制 #模型优化

---

## 一、核心问题：传统残差连接的局限

### 1.1 标准残差连接

```
output = x + Layer(x)
```

每一层把**输入 x** 和**变换后的结果**直接相加，所有层的贡献被**平等对待**。

### 1.2 PreNorm 的 Magnitude 膨胀问题

```
Layer 0:  h₀ = x₀
Layer 1:  h₁ = h₀ + f₁(h₀)     = x₀ + f₁
Layer 2:  h₂ = h₁ + f₂(h₁)     = x₀ + f₁ + f₂
...
Layer L:  h_L = h_{L-1} + f_L   = x₀ + f₁ + f₂ + ... + f_L
```

**问题**：
- 隐藏状态的**范数**会不断增长
- 早期层的贡献被"淹没"在累积的大范数中
- 模型难以区分哪些信息来自哪一层
- 深层网络中，早期信息被"稀释"

### 1.3 PostNorm vs PreNorm

| 方法 | LayerNorm 位置 | 问题 |
|------|---------------|------|
| **PostNorm** | 残差相加后 | 每层归一化，范数可控，但训练不稳定 |
| **PreNorm** | 变换前 | 训练稳定，但范数累积膨胀 |

---

## 二、核心创新：Attention Residuals (AttnRes)

### 2.1 基本思想

**用注意力机制替代固定残差连接**：

```
传统残差:  h_L = h_{L-1} + f_L              ← 固定 1:1 累加
AttnRes:   h_L = Σ α_i · h_i (i=0..L-1)    ← 学习的权重，选择性聚合
```

模型通过注意力机制**学习**：
- 哪些层的信息更重要
- 不同输入应该关注不同层
- 动态调整各层的贡献权重

### 2.2 两种实现变体

| 变体 | 特点 | 内存开销 |
|------|------|----------|
| **Full AttnRes** | 每层关注所有历史层输出 | O(Ld) |
| **Block AttnRes** | 层分组，块内聚合 | O(Nd)，N=块数 |

**Block AttnRes 是实用化版本**：
- 大幅降低内存和通信开销
- 仍然保持 1.25x 计算效率优势
- 推理延迟增加 < 2%

### 2.3 Pseudo-Query 机制

每一层配备一个**可学习的 pseudo-query 向量**：
- 用来计算对该层之前所有输出的注意力权重
- 是 **layer-specific**（每层有自己的 query）
- 但 **不是 input-dependent**（默认设计不依赖输入）

这比每次都从输入计算 query 更高效。

### 2.4 Time-Depth Duality（时间-深度对偶）

论文的理论贡献：
- **时间维度**：标准 attention 让模型选择重要的 token
- **深度维度**：AttnRes 让模型选择重要的层

两者是"对偶"关系，论文从数学上建立了这种联系。

---

## 三、实验效果

### 3.1 下游任务基准测试（Kimi Linear 48B）

| Benchmark | Baseline | + AttnRes | 提升 |
|-----------|----------|-----------|------|
| **MMLU** | 73.5 | 74.6 | +1.1 |
| **GPQA-Diamond** | 36.9 | 44.4 | **+7.5** |
| **BBH** | 76.3 | 78.0 | +1.7 |
| **Math** | 53.5 | 57.1 | +3.6 |
| **HumanEval** | 59.1 | 62.2 | +3.1 |
| **MBPP** | 72.0 | 73.9 | +1.9 |
| **CMMLU** | 82.0 | 82.9 | +0.9 |
| **C-Eval** | 79.6 | 82.5 | +2.9 |

**亮点**：GPQA-Diamond（科学推理）提升最显著 (+7.5)

### 3.2 Scaling Law 验证

```
Baseline:      L = 1.891 × C^(-0.057)
Block AttnRes: L = 1.870 × C^(-0.058)
Full AttnRes:  L = 1.865 × C^(-0.057)
```

**关键结论**：
- AttnRes 在所有计算预算下都优于 baseline
- **Block AttnRes 达到相同 loss，只需 baseline 的 1/1.25 计算量**

### 3.3 训练动态改善

**Gradient Distribution**：
- 梯度更均匀地分布到各层
- 解决了 PreNorm 的"早期层梯度小"问题

**Magnitude Stability**：
- 输出范数保持有界
- 不再随深度无限膨胀

### 3.4 效率指标

| 指标 | 数值 |
|------|------|
| 计算效率 | **1.25x** 优势 |
| 推理延迟开销 | **< 2%** |
| 额外参数 | 可忽略 |
| 内存（Block版） | O(Nd) vs O(Ld) |

---

## 四、直观比喻

想象一个接力跑：

**传统残差** = 每个选手跑完后，把接力棒**直接堆在一起**
- 棒越来越多，最后一大捆
- 分不清哪根是谁的
- 早期的棒被压在下面

**Attention Residuals** = 每个选手跑完后，教练**选择性地**取走部分棒
- 只保留有用的
- 可以追溯来源
- 不会堆积过多

---

## 五、总结

| 方面 | 效果 |
|------|------|
| 性能 | 全面提升，推理任务增益最大 |
| 效率 | 同等效果省 25% 计算量 |
| 实用性 | 可直接替换现有残差，开销极小 |
| 可扩展 | 已在 48B MoE 模型验证可用 |

**一句话总结**：用注意力替代残差连接，让模型学习如何选择性地组合各层信息，而不是盲目累加。

---

## 相关链接

- [GitHub - MoonshotAI/Attention-Residuals](https://github.com/MoonshotAI/Attention-Residuals)
- [MarkTechPost 报道](https://www.marktechpost.com/2026/03/15/moonshot-ai-releases-attention-residuals/)

---

*笔记创建于 2026-03-17*