---
tags:
  - paper
  - rs
---
## Overview

该论文发表于ACM2017， 对当前基于深度学习的推荐系统方法做了总结和分类，并给出自己的看法。论文见: [Deep Learning based Recommender System： A Survey and New Perspectives](https://arxiv.org/pdf/1707.07435.pdf)



产生推荐列表的数据来源一般有如下几种:
- user preferences
- item features
- user-item past interactions
- some other features (temporal, spatial)


推荐模型主要分为三个大类:
- collaborative filtering
- content-based recommender system
- hybrid recommender system

根据完成的任务可以分为
- rating
- ranking
- classification


## Models

### Traditional Models
- matrix factorization (MF)
- factorization machines (FM)
- BPR
- Collaborative Metric Learning (CML)
- funkSVD





### Deep Models:
![deep models](http://imageocean.longfeihao.eu.org/21_14_22_49_rs_fig1.png)




其中autoencodes包含如下几种：
- denoising autoencoder
- marginalized denoising autoencoder
- sparse autoencoder
- contractive autoencoder
- variational autoencoder (VAE)


- MLP
  - Nerual Network Matrix Factorization (NNMF)
  - Nerual Collaborative Filtering (NCF)
  - Deep Factorization Machine (DeepFM)
  - Wide & deep Model
  - Deep Structured Semantic Model (DSSM)
  - Deep Semantic Similarity  based Personalized Recommendation (DSPR)
  - Multi-View Deep Neural Network ( MV-DNN)
- Autoencoder (AE)
  - AutoRec
  - CNF
  - Collaborative Denoising Auto-Encoder (CDAE)
  - Stacked denoising autoencoder (SDAE)
  - Collaborative Deep Learning (CDL)
  - Relational stacked denoising autoencoders (RSDAE)
  - Collaborative variational autoencoder (CVAE)
  - Collaborative Deep Ranking (CDR)
  - AutoSVD++
  - HDCR
- CNN
  - Point-of-Interest (POI) recommendation
  - VPOI
  - VBPR
  - DeepCoNN
  - ConvMF
  - ConvNCF
- RNN
  - Session-based Recommendation without User identifier
    - GRU4Rec
  - Sequential Recommendation with User Identifier
    - Recurrent Recommender Network (RRN)
- RBM
  - RMB-CF
- Neural Autoregressive Distribution Estimation (NADE)
  - CF-NADE
- Adversarial Networks (AＮ)
  - IRGAN
- Attentional Models (AM)
- Deep Reinforcement Learning (DRL)
  - DEERS
  - DeepPage
  - DRN
- Hybrid Models
  - CNN + AE
    - Collaborative Knowledge Based Embedding (CKE)
  - CNN + RNN
  - RNN + AE
    - CRAE
  - RNN + DRL


## Future research directions

- Join representation learning user and item content information
- explainable recommendation with deep learning
- going deeper for recommendation
- machine reasoning for recommendation
- cross domain recommendation with dnn
- deep multi-task learning
- scalability of dnn
- better, more unified and harder evaluation


## Top Conference
论文中提到Recommender Systems方向的定会大致有以下这些:
- NIPS
- ICML
- ICLR
- KDD
- WWW
- SIGIR
- WSDM
- RecSys