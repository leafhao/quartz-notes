# DeepSeek-R1 论文深度分析与 GRPO 算法详解

**来源**: 论文《DeepSeek-R1: Incentivizing Reasoning Capability in LLMs via Reinforcement Learning》
**发布方**: DeepSeek-AI
**日期**: 2026-01-14 (归档日期)

---

## 第一部分：DeepSeek-R1 论文深度分析

### 1. 核心贡献与背景
论文的核心目标是探索如何通过**纯强化学习（RL）**来激发大语言模型（LLM）的推理能力，从而减少对大量人工标注数据的依赖。

*   **DeepSeek-R1-Zero**: 完全不使用监督微调（SFT），仅通过强化学习训练出的模型。它展示了强大的推理能力，并自然涌现出了“自我反思”和“验证”等行为。
*   **DeepSeek-R1**: 在 R1-Zero 的基础上，引入了少量的“冷启动”数据和多阶段训练流程，解决了 R1-Zero 存在的语言混杂、可读性差等问题，实现了与 OpenAI o1-1217 相当的推理性能。
*   **模型蒸馏 (Distillation)**: 证明了可以将 R1 的推理能力蒸馏给更小的模型（如 Qwen-1.5B 到 Llama-70B），使小模型也能具备卓越的推理能力。

### 2. 关键技术架构

#### 2.1 算法：GRPO (Group Relative Policy Optimization)
DeepSeek 摒弃了主流的 PPO 算法，采用更高效的 **GRPO**。
*   **去除 Value Model**: 不再需要一个与 Policy Model 等大的 Critic 模型，大幅降低显存和计算成本。
*   **优势**: 使得对超大规模模型（如 671B）进行强化学习成为可能。

#### 2.2 DeepSeek-R1-Zero：纯 RL 的探索
*   **训练方式**: 直接在 DeepSeek-V3-Base 上进行强化学习。
*   **奖励机制 (Reward)**: 完全基于规则（Rule-based），避免 Neural Reward Model 导致的 "Reward Hacking"。
    *   **准确性奖励**: 答案正确性（主要用于数学/代码）。
    *   **格式奖励**: 强制使用 `<think>` 标签包裹思考过程。
*   **涌现能力 (Emergent Capabilities)**:
    *   **Long Chain-of-Thought (CoT)**: 模型自然学会了延长思考时间。
    *   **Aha Moment (顿悟时刻)**: 模型学会了自我反思、重新评估和纠错。
*   **缺陷**: 输出可读性差，语言混杂（中英夹杂）。

#### 2.3 DeepSeek-R1：多阶段训练流水线 (The Pipeline)
为了解决 R1-Zero 的缺陷并提升综合能力，设计了四个阶段：
1.  **冷启动 (Cold Start)**: 使用少量高质量长思维链数据微调 Base 模型，规范输出格式。
2.  **阶段 1 RL**: 使用 GRPO 专注于提升推理能力（数学/代码）。
3.  **拒绝采样与 SFT**: 利用阶段 1 模型生成大量数据，通过筛选构建约 60 万条推理数据 + 20 万条通用能力数据进行监督微调。
4.  **阶段 2 RL**: 引入有用性（Helpfulness）和无害性（Harmlessness）奖励，进行全场景对齐。

### 3. 实验结果
*   **数学与代码**: 在 AIME 2024 (Pass@1: 79.8%) 和 Codeforces (96.3 Percentile) 上表现顶级，媲美 OpenAI o1。
*   **通用能力**: 在 MMLU 等榜单上也表现出 GPT-4o 级别的能力。
*   **蒸馏效果**: 小模型（如 1.5B, 7B）经过 R1 数据蒸馏后，推理能力大幅超越同尺寸 SFT 模型。

---

## 第二部分：GRPO 算法详解 (Group Relative Policy Optimization)

**GRPO** 是 DeepSeek-R1 成功的基石，它是一种通过“分组采样”和“组内归一化”来取代传统 PPO 中昂贵 Value Function 的强化学习算法。

### 1. 核心痛点：PPO 的昂贵代价
在标准 PPO (Actor-Critic) 中，需要同时训练：
*   **Actor Model**: 生成文本（即 LLM 本身）。
*   **Critic Model**: 价值模型，负责给每一步打分。
Critic 模型通常需要和 Actor 一样大，导致**显存占用翻倍**、**计算量翻倍**，对于 671B 参数的模型来说成本难以承受。

### 2. GRPO 的核心思想
**抛弃 Critic 模型，利用“群体智慧”作为基线 (Baseline)。**
GRPO 不依赖额外的模型打分，而是通过生成一组回答，比较它们之间的相对优劣来更新策略。

### 3. 算法流程详解

假设输入问题为 $q$，策略模型为 $\pi_{\theta_{old}}$：

1.  **分组采样 (Group Sampling)**:
    *   对同一个问题 $q$，采样生成 $G$ 个不同的输出 $\{o_1, o_2, ..., o_G\}$（例如 $G=64$）。
    *   相当于让模型“头脑风暴”出 64 种解法。

2.  **奖励计算 (Reward Calculation)**:
    *   利用规则（如答案是否正确）给这 $G$ 个输出打分，得到奖励 $\{r_1, r_2, ..., r_G\}$。

3.  **优势估计 (Advantage Estimation) —— 核心创新**:
    *   使用**组内平均值**作为基线，计算每个输出的优势 $A_i$：
    $$A_i = \frac{r_i - \text{mean}(\{r_1, ..., r_G\})}{\text{std}(\{r_1, ..., r_G\})}$$
    *   **直观理解**: 
        *   若题目难，大家分都低，略高的那个分优势就是正的。
        *   若题目简单，大家分都高，略低的那个分优势就是负的。
    *   这种方法自动消除了“题目难度”带来的方差。

4.  **策略优化 (Policy Optimization)**:
    *   最大化目标函数，鼓励优势 $A_i > 0$ 的回答，抑制 $A_i < 0$ 的回答。
    *   引入 **KL 散度 (KL Divergence)** 作为正则项，防止模型偏离参考模型（Reference Model）太远，保证训练稳定性。

### 4. GRPO vs PPO 优势总结
1.  **极大降低成本**: 无需训练 Critic 模型，显存和计算减半。
2.  **基线稳健**: 使用组内真实统计数据（均值）作为基线，比训练未收敛的 Critic 预测值更准。
3.  **适合推理**: 特别适合有明确对错（Ground Truth）的推理任务，能有效探索正确路径。
