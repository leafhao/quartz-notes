---
tags:
  - fairseq
  - nlp
---


fairseq基于pytorch，是一个比较完善的seq2seq库。

官方文档对它的介绍如下:

> Fairseq(-py) is a sequence modeling toolkit that allows researchers and developers to train custom models for translation, summarization, language modeling and other text generation tasks.

官方代码: [code](https://github.com/pytorch/fairseq)

tutorial: [tutorial](https://fairseq.readthedocs.io/en/latest/)

基本的使用，可直接参考tutorial。本文主要介绍fairseq的安装和自定义使用及工程使用时代码结构。

## 安装

环境：

- python建议使用3.6，且用虚拟环境
- pytorch>=1.5
- 本地安装

```python
git clone <https://github.com/pytorch/fairseq>
cd fairseq
pip install --editable ./  # 这种方式安装会代码运行会使用本目录的代码，因此不要轻易改动改目录代码
```

安装一些辅助包

```python
git clone <https://github.com/NVIDIA/apex>
cd apex
pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" \\
  --global-option="--deprecated_fused_adam" --global-option="--xentropy" \\
  --global-option="--fast_multihead_attn" ./
  
  
pip install pyarrow
```

## **fairseq框架结构理解**

fairseq出自Facebook。代码框架利用python的注册机制使得整个训练和评估流程各个解耦。方便用户使用且在原来的代码基础上修改也非常简单。

一个完成的训练模型的流程包括：数据预处理，数据加载，模型，训练流程，目标函数，推理等。

1. fairseq可利用fairseq-preprocess对数据进行预处理，如数据格式特殊，可自行修改；
2. 因为fairseq出自Facebook，自然基于pytorch。模型由pytorch构建；
3. 构建模型和模型的相关参数（如embed_size, hidden_size等）由注册模型模块完成（register_model）；
4. 注册模型之外还有一层注册修饰，设置模型的默认参数(register_model_architeture)；
5. 再高一层，就是加载本地数据，学习率，epoch等等一些训练模型所需参数。这些由注册task实现(register_task)；
6. 在之后是一些细节的修改：如需自定义loss，需要注册loss，实现相关函数。如需自定义数据输入，自定义data。更细的参数增加以使用模型灵活性，可按照需要，修改register_model和register_task两个部分中参数设置；
7. 训练结束，自定义参数加载代码，对额外的数据进行推理。

> 注：自定义模型，需要在__init__.py中导入，且在训练和评估中加入--user-dir参数

详细细节操作，需要仔细阅读官方tutorial。 但官方说明没有一个工程性的代码结构。因此本博客对tutorial的一个示例进行工程结构化，如需修改官方代码进行深度自定义，可根据简单的示例进行修改和扩充。

工程示例: [rnn_classifier](https://github.com/longfeihao/rnn_classifier)