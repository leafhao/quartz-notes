---
tags:
  - paper
  - kt
---

## Introduction

这篇论文对现有知识追踪的方法做了一个系统性的总结。



**知识追踪**，根据学生的历史可观测学习数据（练习试题，知识点，答案，其他数据如反馈时间、选项个数、教研介入等因素）来建模学生的学习情况。

> Given the sequence of students’ learning interactions in online learning systems, knowledge tracing aims to monitor students’ changing knowledge states during the learning process and accurately predict their performance on future exercises; this information can be further applied to individualize students’ learning schemes in order to maximize their learning efficiency.  


![](http://imageocean.longfeihao.eu.org/21_14_32_36_kt_fig1.png)


本文将知识追踪的方法分为三种类型，分别进行阐述，然后介绍了一些基本模型的变体。之后介绍了一些知识追踪的经典应用以及未来的研究方向。

![](http://imageocean.longfeihao.eu.org/21_14_33_6_kt_fig2.png)


## Basic KT Models

![](http://imageocean.longfeihao.eu.org/21_14_33_27_kt_tab1.png)


### Probabilistic Models

**Bayesian Knowledge Tracing** ,是特殊的HMM模型。因此，包含transition probabilities和emission probabilities。


![](http://imageocean.longfeihao.eu.org/21_14_33_46_kt_fig3.png)

transition probabilities：

- $ P(T) $, the probability of transition from the unlearned state to the learned state  

- $P(F)$, the probability of forgetting a previously known KC 

  

emission probabilities

- $P(G)$, the probability that a student will guess correctly in spite of non-mastery
- $P(S)$, the probability a student will make a mistake in spite of mastery  

$P(L_0)$ represents the initial probability of mastery  

试题答对的概率为
$$
\begin{align}
P(L_n) = P(L_n|Answer) + (1-P(L_n|Answer))P(T), \\
P(C_{n+1}) = P(L_n)(1-P(S)) + (1-P(L_n))P(G)
\end{align}
$$


后验概率$P(L_n|Answer)$由贝叶斯推理策略估计
$$
\begin{align}
P(L_n|correct)=\frac{P(L_{n-1})(1-P(S))}{P(L_{n-1})(1-P(S))+(1-P(L_{n-1}))P(G))}, \\
P(L_n|incorrect)=\frac{P(L_{n-1})P(S)}{P(L_{n-1})P(S)+(1-P(L_{n-1}))(1-P(G))}
\end{align}
$$


**Dynamic Bayesian Knowledge Tracing**,可以在一个模型中同时估计多个知识点

![](http://imageocean.longfeihao.eu.org/21_14_35_51_kt_fig4.png)


优化该模型，通过maximize the likelihood of the joint probability $p(a_m,h_m|\theta)$
$$
L(w) = \sum_m ln(\sum_{h_m}\exp(w^T\Phi(a_m,h_m)-ln(Z)))
$$
$\Phi: A\times H$是一个从观测变量$A$和隐变量$H$到$F$为的特征向量，$Z$是正规化常量，$w$是模型权重



### Logistic Models

#### Learning Factor Analysis  (LFA)

$$
\begin{align}
\theta = \sum_{i\in N}\alpha_iS_i + \sum_{j\in KCs}(\beta_j + \gamma_jT_j)Kj, \\
p(\theta) = \frac{1}{1+e^{-\theta}}
\end{align}
$$



$\alpha$: estimates the initial knowledge state of each student  

$\beta$: captures the easiness of different KCs  

$\gamma$: denotes the learning rate of KCs  

$S_i$ is the covariates for the student $i$,   

$T_j$ represents the covariate for the number of practice opportunities on KC j  

$K_j$ is the covariate for KC j  

$\theta$ is the estimation of the probability of student and KC parameters 

 $p(\theta)$ is the estimation of the probability of a correct answer  



#### Performance Factor Analysis  (PFA)

$$
\theta = \sum_{j \in KCs}(\beta_j \mu_j s_{ij} + v_jf_{ij}),
$$

$$
p(\theta) = \frac{1}{1+e^{-\theta}}
$$

$f$: the prior failures for the KC of the student  

$s$: represents the prior successes for the KC of the student  

$\beta$: the easiness of different KCs  

$\mu$ and $v$ are the coefficients for $s$ and $f$, which denote the learning rates for successes and failures  



#### Knowledge Tracing Machines  (KTM)

利用FM的思想，建模知识点掌握程度
$$
\theta = \mu + \sum_{i=1}^L w_il_i + \sum_{1\leq i<j\leq L} l_i l_j<v_i, v_j>,
$$

$$
p(\theta) = \frac{1}{1+e^{-\theta}}
$$

where $\mu$ is the global bias, and the feature $i$ is modeled by
a bias $w_i \in R$ and an embedding $v_i \in R^d$; here, $d$ is the dimension. Note that only features with $l_i > 0$ will have
impacts on the predictions  



### Deep Learning-based Models  

#### Deep Knowledge Tracing

利用RNN模型，建模学生的知识点掌握状态。

![fig6](http://imageocean.longfeihao.eu.org//21_14_34_15_kt_fig6.png)



#### Memory-aware Knowledge Tracing  

为了增强KT模型的交互性，memory-based model引入memory存储知识点和更新学生掌握能力。比较经典是Dynamic Key-Value Memory Networks (DKVMN)，为了更好的建模长时依赖，Sequential Key-Value Memory Network (SKVMN)  被提出

![fig7](http://imageocean.longfeihao.eu.org//21_14_34_36_kt_fig7.png)


#### Exercise-aware Knowledge Tracing  

EKT模型是作者实验室自己提出的，基于试题本身的建模然后进行知识点掌握能力建模。

![fig8](http://imageocean.longfeihao.eu.org//21_14_34_53_kt_fig8.png)


#### Attentive Knowledge Tracing  

该类模型，是基于Transformer的一类模型。主要代表有：

self-attentive model for knowledge tracing (SAKT)  

self-attentive neural knowledge tracing (SAINT)  

SAINT+ model  

contextaware attentive knowledge tracing (AKT)

relation-aware self-attention model for knowledge tracing (RKT)  



#### Graph-based Knowledge Tracing  

利用图可以建模数据之间复杂的联系。目前主要有两个工作。

the graph-based knowledge tracing (GKT)  

structure-based knowledge tracing (SKT)  

![fig9](http://imageocean.longfeihao.eu.org//21_14_35_10_kt_fig9.png)




## Variants of KT Models

变体主要分为四类：

- modeling individualization before learning
-  incorporating engagement
- utilizing side information during learning
- considering forgetting after learning 



最后，论文对目前的一些论文用的方法做了更细致的分类。

![tab2](http://imageocean.longfeihao.eu.org/21_14_35_25_kt_tab2.png)




## Applications

- Learning Resources Recommendation  
- Adaptive Learning  
- Educational Gaming  
