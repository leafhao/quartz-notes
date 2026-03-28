---
tags:
  - paper
  - nlp
---

# 论文笔记-Addressing Some Limitations of Transformers with Feedback Mermory


这篇论文对Transformer的结构进行了反思，指出Transformer主要有两个缺点：
1. 对于Transformer的时序建模，虽然历史的高层信息已经被计算，但是这个信息并没有被充分利用；
2. 仅仅通过Attention和Feed forward模块，对时序信息建模的抽象程度不够。

基于这两个缺点，论文引入Feedback Memory模块。通过引入该模块，模型可以同时获得底层和高层的表示。该模型可以用更小更浅的模型取得sota效果。


## 模型
模型框架如图所示：
![model](http://imageocean.longfeihao.eu.org/21_14_27_25_feedbacktrans_model.png)


图1是模型的框架，创新点在于引入了memorty(橙色模块)。图2对比该模型与原始Transormer的区别。原始Transormer每个模块是通过Attn建模下层历史时刻和本是可的数据。可以看出模型通过引入了memory(橙色模块)，橙色模块对历史所有层的信息建模，每个模块可以通过memory同时获得高层和低层的信息。



**Transormer**
$$
X^l = (x_1^1,...,x_t^l) \\
z_t^l =Attn(x_t^l, \{x_{t-\tau}^l,...,x_{t-1}^l\}) \\
X^{l+1} = FF(Attn(X^l))
$$
$x_t$与$t-1$及之前的时刻输入数据进行$Attn$，然后经过$FF$层，得到下一层$X^{l+1}$



**Feedback Transformer**


$$
z_t^l = Attn(x_t^l, \{m_{t-\tau}, ...,m_{t-1}\}), \\
m_t = \sum_{l=0}^L \text{Softmax}(w^l)x_t^l,
$$
与原始Transformer相比，论文的方法是与历史时刻的$m$进行$Atnn$，其中$m_t$是时刻$t$的所有层$x$的$Attn$.



## 实验结果

模型改动比较小，这样改动之后。模型训练时就不能并行训练了。所以，除了实验结果，训练时间也是一个比较关注的问题。

![res1](http://imageocean.longfeihao.eu.org/21_14_27_52_feed_res1.png)


其中Fig3.和Tab1中的Copy，Reverse, Counting任务与长期记忆相关。对比可以发现，这篇论文的方法比原始Transormer有明显提升。并且在小模型下，提升更明显，且增大模型模型的结果依然很稳定。



Tab1中的Random Walk和Algorithmic任务测试模型的状态更新能力，可以发现改论文的方法依然优势很强。

![res2](http://imageocean.longfeihao.eu.org/21_14_28_9_feed_res2.png)



左图与Fig3的结论类似，模型在小模型下就可以有很好的效果。右图依然是在证明模型的状态更新能力。
![res3](http://imageocean.longfeihao.eu.org/21_14_28_32_feed_res3.png)


该论文与目前常见的时序模型进行对比（RNN，RNN+Attn，Transformer三种结构），可以发现该论文提出的模型框架比其他结构都有更好的实验效果。

Fig5可以看出，引入Memory实质是更改了Transformer的拓扑结构，改论文提升实验效果的原因是使用了更复杂的拓扑结构。
![res4](http://imageocean.longfeihao.eu.org/21_14_28_49_feed_res4.png)



该论文也使用了一些技巧来提升模型的速度。在常见的数据集上与Transformer进行了对比。发现模型可以用更小的参数量，在不降低实验效果的情况下比其他模型有更快的训练和推理速度。





## 结论

这篇论文相对比较简单，就是在原始模型上加了一个Memory模块。但是做了比较充分的实验，确实验证了实验效果还不错。
