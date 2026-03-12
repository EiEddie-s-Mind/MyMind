---
tags:
  - 数学
  - undone
  - todo
date: 2025-12-05
lastmod: 2026-03-10
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
> $\blacksquare$

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
> $\blacksquare$

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
> $\blacksquare$

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
> $\blacksquare$

于是我们得到结论:

> [!note]
> $G(\lambda)$ 是 $A$ 的不变子空间.
> 
> \
> *证明*:
> 令 $f(x) = (x - \lambda)^{\dim V}$, 由引理显然成立.
> $\blacksquare$

接下来我们将得到第一个有价值的成果, 在此之前, 请看这样一个引理:

> $$V = \ker A^{\dim V} \oplus \text{im} \, A^{\dim V}$$
> \
> *证明*:
> 令 $n = \dim V$.
> 
> 先证 $(\ker A^n) \cap (\text{im} \, A^n) = \{0\}$.
> 设 $\mathbf{v} \in (\ker A^n) \cap (\text{im} \, A^n)$,
> 则 $A^n \, \mathbf{v} = 0$, 且存在 $\mathbf{u} \in V$ 使 $\mathbf{v} = A^n \, \mathbf{u}$.
> 于是有 $A^n \, \mathbf{v} = A^{2n} \, \mathbf{u} = 0$,
> 所以 $\mathbf{u} \in \ker A^{2n} = \ker A^n$,
> $\mathbf{v} = A^n \, \mathbf{u} = 0$.
> 
> 现在我们知道 $\ker A^n + \text{im} \, A^n$ 是一个直和,
> 此外 $\dim \, (\ker A^n \oplus \text{im} \, A^n) = \dim \ker A^n + \dim \text{im} \, A^n = \dim V$.
> 由此可知 $V = \ker A^{\dim V} \oplus \text{im} \, A^{\dim V}$.
> $\blacksquare$

现在可以证明:

> [!note]
> \[**准素分解**\]:
> $$V = G(\lambda_1) \oplus G(\lambda_2) \oplus \cdots \oplus G(\lambda_n)$$
> \
> *证明*:
> 考虑使用归纳法.
> 
> 显然当 $\dim V = 1$ 时成立.
> 
> 假设结论对于维数小于 $\dim V$ 的空间成立, 来证明结论对于 $V$ 也成立.
> 对于复线性空间 $V$, $A$ 必有一个特征值, 记为 $\lambda_1$.
> 将引理应用到 $A - \lambda_1 I$ 上, 可知
> $$ V = G(\lambda_1) \oplus U$$
> 其中 $U = \text{im} \, (A - \lambda_1 I)^{\dim V}$,
> 它是 $A$ 的一个不变子空间.
> 
> 由于 $\dim U < \dim V$, 可以将结论应用在 $U$ 上.
> 这时广义特征空间对应的线性变换应当是 $A|_U$, 为了区分, 将其记作 $G'(\lambda_i)$.
> 重复上述步骤, 我们可以将 $U$ 拆分为 $G'$ 的直和
> $$U = G'(\lambda_2) \oplus G'(\lambda_3) \oplus \cdots \oplus G'(\lambda_n)$$
> 
> 现在来完成证明最后一步, 证明 $G'(\lambda_i) = G(\lambda_i)$, $i = 2, 3, ..., n$.
> 显然 $G'(\lambda_i) \subseteq G(\lambda_i)$,
> 因为 $G'(\lambda_i) = \ker (A|_U - \lambda_i I)^{\dim V} = \ker (A - \lambda_i I)^{\dim V}|_U = (\ker (A - \lambda_i I)) \cap U = G(\lambda_i) \cap U$.
> 要证明 $G(\lambda_i) \subseteq G'(\lambda_i)$, 即证对于任意 $\mathbf{v} \in G(\lambda_i)$, $\mathbf{v} \in G'(\lambda_i) = G(\lambda_i) \cap U$, 即证 $\mathbf{v} \in U$.
> 我们知道 $\mathbf{v} \in V$, 因此 $\mathbf{v} = \mathbf{v}_1 + \mathbf{u}$, $\mathbf{u} \in U$;
> $\mathbf{u} = \mathbf{v}_2 + \mathbf{v}_3 + \cdots + \mathbf{v}_n$.
> 每个 $\mathbf{v}_j$, $j = 2, 3, ..., n$ 都在 $G'(\lambda_j)$ 中.
> 因为相应于不同特征值的广义特征向量线性无关, 因此除 $j = i$ 之外每个 $\mathbf{v}_j$ 都为 $0$.
> 特别地, $\mathbf{v}_1 = 0$, 所以 $\mathbf{v} = \mathbf{u} \in U$.
> $\blacksquare$

这样一来, 我们就将 $V$ 拆分为了广义特征空间 $G(\lambda)$ 的直和, 这些空间 $G(\lambda)$ 的个数为特征值的数量 $n$, 这是显然的.
*请注意, $n$ 并非指 $\dim V$*.
$G(\lambda)$ 的维度定义为 $\lambda$ 的 (代数) **重数**,
显然, 所有特征值的重数之和等于 $\dim V$.

## 循环子空间
我们希望知道 $G(\lambda)$ 是否还可以继续拆分.
为了探究这个问题, 先研究线性变换 $A$ 在空间上的性质.

> [!note]
> $(A - \lambda I)|_{G(\lambda)}$ 是幂零变换.
> 
> \
> *证明*:
> 由 $G(\lambda) = \ker (A - \lambda I)^{\dim V}$ 显然成立.
> $\blacksquare$

在不引起混淆的情况下, 我将使用符号 $G$ 代表广义特征空间 $G(\lambda)$;
$N := A - \lambda I$.
需要注意 $N$ 在 $V$ 上不总是幂零的, 只有在 $G$ 及其子空间中才是.
这一定理告诉我们,
**在 $G$ 中线性变换 $A$ 总是等于单位变换 $\lambda I$ 与一个幂零变换 $N$ 之和**.
现在我们知道, 要继续分解 $G$, 则需研究 $N$ 的性质.

> 对于任意 $\mathbf{v}$, 若 $N^{m-1} \, \mathbf{v} \ne 0$ 且 $N^m \, \mathbf{v} = 0$,
> 则 $\{\mathbf{v}, N \mathbf{v}, ..., N^{m-1} \, \mathbf{v}\}$ 线性无关.
> 
> \
> *证明*:
> 设 $k_0 \mathbf{v} + k_1 N \mathbf{v} + \cdots + k_{m-1} N^{m-1} \, \mathbf{v} = 0$,
> 考虑等式两边在 $N^{m-1}$ 下的像, 有
> $$\begin{align}
> 0 &= N^{m-1} (k_0 \mathbf{v} + k_1 N \mathbf{v} + \cdots + k_{m-1} N^{m-1} \, \mathbf{v}) \\
>   &= k_0 \, N^{m-1} \, \mathbf{v} + 0 + \cdots + 0 \\
>   &= k_0 \, N^{m-1} \, \mathbf{v}
> \end{align}$$
> 于是得 $k_0 = 0$.
> 类似考虑两边在 $N^{m-2}$ 下的像, 可以得到 $k_1 = 0$.
> 依次下去, 可得 $k_0 = k_1 = \cdots = k_{m-1} = 0$,
> 这样就证明了向量组线性无关.
> $\blacksquare$

考虑由上述向量组张成的空间 $C = \langle \mathbf{v}, N \mathbf{v}, ..., N^{m-1} \, \mathbf{v} \rangle$, 显然它是 $N$ 的不变子空间.
$C$ 被称为 $N$ 的**循环子空间**.

下面我们将逐渐证明, 任意 $G$ 都能分解为一系列循环子空间 $C$ 的直和.

> 若 $V = U \oplus W$, 则商映射 $\pi: V \rightarrow V/U$ 在 $W$ 上的限制 $\pi|_W: W \rightarrow V/U$ 是双射.
> 
> \
> *证明*:
> 先来证它是单射.
> 任意 $\mathbf{v} \in V$ 满足 $\pi(\mathbf{v}) = (\mathbf{v} + U) = 0$ 当且仅当 $\mathbf{v} \in U$,
> 所以 $\ker \pi|_W = (\ker \pi) \cap W = U \cap W = \{0\}$.
> 
> 再证它是满射.
> 对于任意 $\mathbf{v} \in V$ 有 $\mathbf{v} = \mathbf{u} + \mathbf{w}$, 其中 $\mathbf{u} \in U$, $\mathbf{w} \in W$.
> $\pi(\mathbf{v}) = \pi(\mathbf{u}) + \pi(\mathbf{w}) = 0 + \pi(\mathbf{w})$.
> 所以 $\forall ~ [\mathbf{v}] \in V/U$, $[\mathbf{v}] = \pi(\mathbf{v}) = \pi(\mathbf{w})$.
> $\blacksquare$

<!-- 定理与证明有误 -->
<!--
> 在 $G$ 中 $C$ 有一个补空间 $C'$ 也是 $N$ 的不变子空间.
> 
> \
> *证明*:
> 考虑对 $G$ 的维度使用归纳法.
> 
> 显然当 $\dim G = 1$ 时结论成立.
> 
> 假设当维度小于 $\dim G$ 时结论成立.
> 考虑商空间 $G/C$, 因为 $\dim G/C = \dim G - \dim C < \dim G$, 我们可以对它应用结论.
> 令 $\overline{N}$ 为 $N$ 诱导的 $G/C$ 上的幂零算子.
> 从 $G/C$ 开始, 按下面的步骤进行:
> - 任取 $[\mathbf{u}] \in G/C$;
> - $\{\overline{U}\} = \{[\mathbf{u}], \overline{N} [\mathbf{u}], ..., \overline{N}^r \, [\mathbf{u}]\}$ 线性无关, 它张成的子空间 $\overline{U}$ 是 $\overline{N}$- 不变子空间;
> - 依据归纳假设, 有一个补空间 $\overline{U}'$ 是不变子空间, 满足
>   $$G/C = \overline{U} \oplus \overline{U}'$$
> - 对 $\overline{U}'$ 应用上述步骤, 直到 $\overline{U}' = \{0\}$.
> 
> 如此一来, 我们将 $G/C$ 分解为了一系列 $\overline{N}$- 不变子空间的直和
> $$G/C = \overline{U}_2 \oplus \overline{U}_3 \oplus \cdots \oplus \overline{U}_s$$
> 
> 设 $G = C \oplus C'$, 我们知道存在一个双射 $\pi: C' \rightarrow V/U$, 因此 $C'$ 与 $G/C$ 同构.
> 所以 $C'$ 可以分解为一系列 $N$- 不变子空间的直和
> $$C' = U_2 \oplus U_3 \oplus \cdots \oplus U_s$$
> 如此命题得证.
> $\blacksquare$
-->

从证明过程中, 我们可以知道:

> [!note]
> $G$ 可以分解为循环子空间的直和
> $$G = C_1 \oplus C_2 \oplus \cdots \oplus C_s$$

接下来计算分解出的循环子空间的数量, 以及每个空间的维度.

---

## 参考
1. S. Axler. "复向量空间上的算子." 于 *线性代数应该这样学*, pp. 183-206. 人民邮电出版社, 2016.
2. 丘维生. *高等代数 (下册)*. 清华大学出版社, 2010.
3. \@纯粹. "[Jordan标准型：根子空间+准素分解，幂零变换+循环分解，Weyr特征，A与A^T相似](https://zhuanlan.zhihu.com/p/75745789)". 知乎, 2020.