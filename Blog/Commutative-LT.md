---
tags:
  - 数学
  - 小品
  - undone
  - todo
date: 2025-11-01
title: 可交换的线性变换
aliases: [可交换的线性变换]
---

# 可交换的线性变换
这篇文章讨论可交换的线性变换, 即对于线性变换 $A$, $B$, 有 $AB = BA$.

## 引理
> $f(A)$ 与 $B$ 可交换的充要条件是 $A$, $B$ 可交换.

## 充要条件
复数域上线性变换 $A$, $B$ 可交换的充要条件是:
> $A$ 的每个广义特征空间 $E_{\lambda}$ 都是 $B$ 的不变子空间.

其中*广义特征空间* $E_{\lambda} = \{\mathbf{v} ~ | ~ (A - \lambda I)^m \; \mathbf{v} = \mathbf{0}, m \in \mathbb{N}_+\}$.
线性空间 $V$ 总是可以分解为其上某一线性变换的广义特征空间的直和.

**证明**: \
**充分性**:
任取 $A$ 在重数 $m$ 的广义特征空间 $E_{\lambda}$, $\forall \mathbf{v} \in E_{\lambda}; B \mathbf{v} \in E_{\lambda}$.
于是 $B (A - \lambda I)^m \mathbf{v} = B \; \mathbf{0} = \mathbf{0}$, $(A - \lambda I)^m B \mathbf{v} = (A - \lambda I)^m (B \mathbf{v}) = \mathbf{0}$.
注意到 $(A - \lambda I)^m$ 是关于 $A$ 的多项式, 由此可得 $E_{\lambda}$ 上 $A$ 与 $B$ 可交换.

将复数域上向量空间 $V$ 分解为广义特征空间的直和 $V = E_{\lambda_1} \oplus E_{\lambda_2} \oplus \dots \oplus E_{\lambda_r}$,
其中 $E_{\lambda_i}$ 是对应于特征值 $\lambda_i$ 的广义特征空间.
任取 $\mathbf{u} \in V$, $\mathbf{u} = \sum_i k_i \mathbf{v}_i$, 其中 $\mathbf{v}_i \in E_{\lambda_i}$.
对于任意 $\mathbf{v}_i$ 都有 $A$, $B$ 可交换, 故对于其线性组合 $\mathbf{u}$ 也可交换.

综上, $A$, $B$ 在 $V$ 上可交换.

**必要性**:
若 $A$, $B$ 可交换, 则对任意 $\mathbf{v} \in E_{\lambda}$, 都有
$(A - \lambda I)^m (B \mathbf{v}) = B ((A - \lambda I)^m \mathbf{v}) = B \; \mathbf{0} = \mathbf{0}$.
故 $B \mathbf{v} \in E_{\lambda}$.
即 $E_{\lambda}$ 是 $B$ 的不变子空间.
