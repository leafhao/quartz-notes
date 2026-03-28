---
tags:
  - paper
  - nlp
---
本文对NLP预训练模型做了一个全面的总结 [Pre-trained Models for Natural Language Processing: A Survey](https://arxiv.org/abs/2003.08271)



解决NLP问题的深度学习网络一般有: convolutional neural networks (CNNs), recurrent neural networks (RNNs), graph-based neural networks (GNNs), attention mechanism.

## Pre-trained Models for NLP (PTMs) 总览


![](http://imageocean.longfeihao.eu.org//21_14_16_53_ptm_fig3.png)






###  PTMs的优势

1. 从大语料库中学到通用的representations，用以帮助下游任务
2. PTMs提供了更好的模型初始参数
3. 可以看做一个正则化，防止在小数据集上overfitting



### PTMs的发展

第一代 PTMs:

-  [Skip-Gram](https://arxiv.org/abs/1310.4546)
-  Word2Vec
- [GloVe ](https://nlp.stanford.edu/projects/glove/)

这些模型context-free而且不能捕捉文本的高层表示, 如 polysemous disambiguation, syntactic structures, semantic roles, anaphora



第二代PTMs:

- [CoVe ](https://arxiv.org/abs/1708.00107)
- [ELMo ](https://arxiv.org/abs/1802.05365)
- [ULMFiT](https://arxiv.org/abs/1801.06146)
- [OpenAI GPT](https://s3-us-west-2.amazonaws.com/openai-assets/research-covers/language-unsupervised/language_understanding_paper.pdf)
- [BERT ](https://arxiv.org/abs/1810.04805)



### PTMs分类

**Representation type**

- non-contextual models
- contextual models

![Representation](http://imageocean.longfeihao.eu.org//21_14_18_5_ptm_tab2.png)



**Architectures**

- LSTM
- Transformer Encoder
- Transformer Decoder
- full Transofrmer

**Pre-Training Task Types**

**Extensions**

- Knowledge-enriched PTMs
  - linguistic
  - semantic
  - commomsense
  - factual
  - domain-specific knowledge
- Multiligual and language-specific PTMs
  - Multilingual PTMs
    - cross-lingual language understanding
    - cross-lingual language generation
  - Language-specific PTMs
- Multi-Modal PTMs
  - Video-Text PTMs [CBT](https://arxiv.org/abs/1906.05743), [VideoBERT](https://arxiv.org/abs/1904.01766), [ViLM](https://arxiv.org/abs/2002.06353)
  - Image-Text PTMs [ViLBERT, LXMERT, VisualBERT, B2Ts, VLBERT, Unicoder-VL, UNITER]
  - Audio-Text PTMs [SpeechBERT]
- Compressed PTMs
  - model prruning: 去除不重要的参数
  - weight quantization: 用比特表示参数
  - parameter sharing: 类似结构共享参数
  - knowledge distillation: 训练一个学会更小的学生模型学习原始模型
    - distillation from soft target probabilities [DistillBERT]
    - distillation from other knowledge [TinyBERT, MobileBERT, MimiLM]
    - distillation fto other stuctures
  - model replacing: 用更紧凑的模型取代原模型
- ...

![tab3](http://imageocean.longfeihao.eu.org//21_14_18_20_ptm_tab3.png)





### PTMs任务

机器学习可以分为Supervised Learning (SL)，Unsupervised Learning (UL)，Self-Supervised Learing (SSL)

- Language Modeling (LM)

- Masked Language Modeling (MLM) 

- Seq2Seq MLM  *[used in [MASS](https://arxiv.org/abs/1905.02450), [T5](https://arxiv.org/abs/1910.10683) and benefit the Seq2Seq downstream tasks]*
- Enhanced MLM (E-MLM) *[[RoBERTa](https://arxiv.org/abs/1907.11692) <- BERT, UniLM, [XLM](https://arxiv.org/abs/1901.07291v1) <- MLM, [Span-BERT](https://arxiv.org/abs/1907.10529) <- MLM, [StructBERT](https://arxiv.org/abs/1908.04577v1)]* 
- Permuted Language Modeling (PLM) [XLNet](https://github.com/zihangdai/xlnet)
- Denoising Autoencoder (DAE) [BART](https://arxiv.org/abs/1910.13461)
- Contrastrive Learning ([CTL](https://arxiv.org/abs/1902.09229))
- Deep InfoMax ([DIM](https://arxiv.org/abs/1910.08350v2))
- Replaced Token Detection (RTD) [CBOW-NS](https://arxiv.org/abs/1310.4546), [ELECTERA](https://arxiv.org/abs/2003.10555), [WKLM](https://arxiv.org/abs/1912.09637?context=cs)
- Next Sentence Prediction (NSP)
- Sentence Order Prediction (SOP)  [ALBERT](https://arxiv.org/abs/1909.11942?context=cs), [StructBERT](https://arxiv.org/abs/1908.04577v1), [BERTje](https://arxiv.org/abs/1912.09582)
- Others
  - incorporate factual knowledge
  - imporve cross-lingual tasks
  - multi-model applicates
  - ...

![Loss Function](http://imageocean.longfeihao.eu.org//21_14_18_1_ptm_tab1.png)





### Adapting PTMs to Downstream Tasks

预训练好模型后，还有一个重要的问题是，如何使用PTMs。这涉及到Transfer Learning.

![transfer learning](http://imageocean.longfeihao.eu.org//21_14_17_30_ptm_fig4.png)

- 如何迁移?
  - 选择合适的预训练任务，模型和语料库
  - 选择合适的层（低层倾向于语法等基本信息，高层有利于用语义等任务）
  - 是否需要微调(To tune or not to tune)
    - feature extraction (the pre-trained parameters are frozen)
    - fine-tuning (the pre-trained parameters are unfrozen and fine-tuned)

- 微调策略
  - Two-stage fine-tuning
    1. 通过中间层/语料库进行微调
    2. 在目标任务上微调
  - Multi-task fine-tuning
  - Fine-tuning with extra adapation modules
    - 原始参数固定，引入额外的可微调模块
  - Others
    - self-ensamble and self-distillation
    - gradual unfreezing and sequential unfreezing





### PTM的应用

- General Evaluation Eenchmark (GLUE, SuperGLUE)
- Question Answering
- Sentiment Analysis
- Named Entity Recognition
- Machine Translation
- Summarization
- Adversarial Attacks and Defenses



### 发展方向

- Upper Bound of PTMs
  - 当前预训练模型还没有达到它的上届，需要更深的网络，更大的语料库，更富有挑战的预训练任务，更高效的损失函数。目前一个比较实际的方式是在现有的软硬件基础上，设计一个有效率的模型，自监督预训练任务，优化器和训练技巧，如ELECTRA
- Architecture of PTMs
  - transformer以被证实是一个比较有效的预训练结构。但是由于模型比较复杂，需要设计更加轻量的模型,如Transformer-XL。模型的设计非常困难，neural architecture search (NAS)或许是一个比较好的方式。
- Task-oriented Pre-training and Model Compression
  - 不同下游任务需要PTM不同的能力。PTMs和下游任务通常有两个差异：模型结构和数据分布。
  - 通常更大的PTMs对下游更有利，但模型太大，无法在低容量、低延迟设备上使用。因此需要提取特定任务的预训练知识
  - 使用模型蒸馏技术，根据原PTMs构建一个更小的网络
- Knowledge Transfer Beyond Fine-tuning
  - 为特定任务引入可微调模块，使PTMs可以复用
  - 从PTMs中更加灵活的挖掘知识：feature extraction, knowledge distillation, data augmentation
- Interpretability and Reliability of PTMs
  - 可解释性：深度模型的解释性很差，目前大多利用atteion进行解释
  - 脆弱性：由于深度模型不可解释，很可能与人的认知不一致。这也导致了模型出现不和直觉的结果。使用对抗机制研究这个方向非常有前景。

