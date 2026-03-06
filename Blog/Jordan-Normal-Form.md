---
tags:
  - 数学
  - undone
  - todo
date: 2025-12-05
lastmod: 2026-03-06
marked: true
title: 若尔当标准型
aliases: [若尔当标准型]
---

# 若尔当标准型
我们对若尔当标准型的讨论始于两个最基本与最常见的问题:
- 如何将线性空间 $V$ 分解为线性变换 $A$ 的不变子空间 $V_i$ 的直和?
- 如何使线性变换 $A$ 在 $V$ 的一组基上具有最简洁的矩阵形式?

对于问题一, 一个合理的附加条件是 $A$ 在这些不变子空间 $V_i$ 上具有良好的性质, 这样要研究 $A$, 只需在每个更小的空间上研究, 并且充分利用那些性质, 最后汇总为 $V$ 即可.
问题二则是为了方便计算, 我们可以利用这种简洁矩阵的性质, 提供远比普通矩阵乘法等更优的算法.

对于这两个问题, 我们首先想到的应该是线性变化的对角化.
对于可对角化的线性变换, 充要条件之一便是线性空间 $V$ 可以被分解为特征子空间的直和 $V = E(\lambda_1) \oplus E(\lambda_2) \oplus \cdots \oplus E(\lambda_n)$;
并且我们知道这一变换在其特征向量组成的基下是对角矩阵,
这样两个问题就都得到解决.
遗憾的是, 并非每一个矩阵都可以对角化. 我们要讨论的便是一种类似对角化的, 可以对每个变换进行的分解.

## 广义特征空间
我们的讨论将限于复线性空间中, 即 $\mathbb{C}$ 上的线性空间 $V$.

某些线性变换没有足够的特征向量, 无法张成整个空间, 为了解决这个问题, 我们将要引入**广义特征向量**的概念.

> [!note]
> 对于线性变换 $A$ 的特征值 $\lambda$, 满足 $\mathbf{v} \ne 0$ 且存在 $j \in \mathbb{N}_+$ 使 $(A - \lambda I)^j \, \mathbf{v} = 0$, 则称 $\mathbf{v}$ 是相应于 $\lambda$ 的**广义特征向量**.
> 
> 由相应于 $\lambda$ 的广义特征向量集张成的空间称**广义特征空间** $G(\lambda)$, 又称**根子空间**.

显然, $E(\lambda) \subseteq G(\lambda)$, 因为任何特征向量都是广义特征向量.

为了形式化地描述广义特征空间, 我们需要以下引理:

> $$\{0\} = \ker A^0 \subseteq \ker A^1 \subseteq \ker A^2 \subseteq \cdots$$
> \
> *证明*:
> 对于任意 $\mathbf{v} \in \ker A^k$, 有 $A^k \, \mathbf{v} = 0$.
> 因此 $A^{k+1} \, \mathbf{v} = A (A^k \, \mathbf{v}) = 0$, 于是 $\ker A^k \subseteq \ker A^{k+1}$.
> *证毕*.

> 若存在 $m$ 使 $\ker A^m = \ker A^{m+1}$, 则
> $$\ker A^m = \ker A^{m+1} = \ker A^{m+2} = \cdots$$
> \
> *证明*:
> 我们已知 $\ker A^{m+k} \subseteq \ker A^{m+k+1}$, 只需证 $\ker A^{m+k+1} \subseteq \ker A^{m+k}$.
> 
> 对于任意 $\mathbf{v} \in \ker A^{m+k+1}$, 有 $A^{m+k+1} \, \mathbf{v} = A^{m+1} (A^k \, \mathbf{v}) = 0$,
> 因此 $A^k \, \mathbf{v} \in \ker A^{m+1} = \ker A^m$,
> 所以 $A^m (A^k \, \mathbf{v}) = A^{m+k} \, \mathbf{v} = 0$,
> $\mathbf{v} \in \ker A^{m+k}$.
> 于是我们得到 $\ker A^{m+k+1} \subseteq \ker A^{m+k}$.
> *证毕*.

由这一引理可知, 存在一个最小的 $m$, 使幂次小于 $m$ 时都为真子集, 而大于等于 $m$ 时都相等, 即 $\ker A^0 \subsetneq \ker A^1 \subsetneq \cdots \subsetneq \ker A^m = \ker A^{m+1} = \cdots$.
可以证明, $m \le \dim V$.
因此 $\ker A^{\dim V}$ 是任意 $\ker A^k$ 的超集.

依据以上引理, 我们可以这样刻画广义特征空间:

> [!note]
> $$G(\lambda) = \ker (A - \lambda I)^{\dim V}$$
> \
> *证明*:
> 由定义可知任意 $\mathbf{v} \in \ker (A - \lambda I)^{\dim V}$ 都有 $\mathbf{v} \in G(\lambda)$, 所以 $\ker (A - \lambda I)^{\dim V} \subset G(\lambda)$;
> 反过来, 对于任何 $\mathbf{v} \in G(\lambda)$, $\mathbf{v} \in \ker (A - \lambda I)^j \subset \ker (A - \lambda I)^{\dim V}$.
> 综上得证.
> *证毕*.

这一空间是 $A$- 不变的, 这使它很有价值.
为了证明这一点, 需要下面的引理:

> 对于多项式 $f$, $\ker f(A)$ 是 $A$ 的不变子空间.
> 
> \
> *证明*:
> 对任意 $\mathbf{v} \in \ker f(A)$, $f(A) \, \mathbf{v} = 0$,
> 所以 $f(A) (A \mathbf{v}) = A (f(A) \, \mathbf{v}) = 0$,
> 所以 $A \mathbf{v} \in \ker f(A)$,
> 即 $\ker f(A)$ 是 $A$- 不变的.
> *证毕*.

于是我们得到结论:

> [!note]
> $G(\lambda)$ 是 $A$ 的不变子空间.
> 
> \
> *证明*:
> 令 $f(x) = (x - \lambda)^{\dim V}$, 由引理显然成立.
> *证毕*.

接下来我们将得到第一个有价值的成果, 在此之前, 请看这样一个引理:

> $$V = \ker A^{\dim V} \oplus \text{im} \, A^{\dim V}$$

<!--在不引起混淆的情况下, 我将使用符号 $G$ 代表广义特征空间 $G(\lambda)$.-->