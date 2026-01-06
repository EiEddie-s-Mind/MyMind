---
tags:
  - 数学
  - julia
date: 2025-03-05
title: 三维空间中刚体运动的描述
aliases: [三维空间中刚体运动的描述]
---

# 三维空间中刚体运动的描述

刚体运动由旋转与平移组成, 与旋转类似, 可以用矩阵来表示:
$$
T =
\begin{pmatrix}
R & \mathbf{\rho} \\
  & 1
\end{pmatrix}
$$
其中 $R$ 是旋转矩阵, $\mathbf{v}$ 是表征平移的向量.
刚体运动矩阵作用于三维向量的齐次坐标上.

同样与旋转类似, 所有刚体运动矩阵构成一个群, 称为 *特殊欧氏群* $SE(3)$.

$SE(3)$ 也是一个 *李群*, 它的 *李代数* $\mathfrak{se} (3)$ 中的元素为如下形式:
$$\begin{pmatrix}
\theta [\hat{\mathbf{\omega}}]_\times & \mathbf{v} \\
                                      & 0
\end{pmatrix}$$
这里 $[\hat{\mathbf{\omega}}]_\times$ 表示单位向量的外积矩阵.

本篇文章的工作是推导 $SE(3)$, $\mathfrak{se}(3)$ 与 $\mathbb{R}^6$ 中元素的互相转换.
$\mathbb{R}^6$ 中的元素也被称为 *运动旋量*.

## 引理

$$\boxed{
\begin{pmatrix}
\theta [\hat{\mathbf{\omega}}]_\times & \mathbf{v} \\
                                      & 0
\end{pmatrix}^n =
\begin{pmatrix}
\theta^n [\hat{\mathbf{\omega}}]_\times^n &
\theta^{n-1} [\hat{\mathbf{\omega}}]_\times^{n-1} \mathbf{v} \\
                                          & 0
\end{pmatrix}
}$$

直接计算便可得到.

---

> 对于多项式 $f(x)$ 与矩阵 $A$, $f(A)$ 可逆当且仅当 $A$ 的所有特征值都不是 $f(x)$ 的根,
> 且此时 $f(A)^{-1}$ 也是关于 $A$ 的多项式.

若 $\forall \lambda; f(\lambda) \neq 0$, 此时 $f(x)$ 与 $g(x)$ 互质, 其中 $g(\lambda) := \det{(\lambda I - A)}$ 是 $A$ 的特征多项式.
于是有 $f(x) ~ u(x) + g(x) ~ v(x) = 1$. 不定元用 $A$ 代入,
可知 $f(A) ~ u(A) + g(A) ~ v(A) = I$.
由 [凯莱-哈密顿定理](https://zh.wikipedia.org/wiki/凱萊–哈密頓定理),
$g(A) = 0$. 进而 $f(A) ~ u(A) = I$.
因此 $f(A)$ 可逆, 且它的逆是 $A$ 的多项式形式.

---

<!-- 反对称矩阵的特征值为纯虚数或0 -->

## 正文

$$\boxed{\begin{align}
\wedge: \mathbb{R}^6 &\rightarrow \mathfrak{se}(3) \\
        \mathbf{\xi} &\mapsto     \mathbf{\xi}^\wedge
\end{align}}$$

对于 $\mathbf{\xi} = (\theta \hat{\mathbf{\omega}}, \mathbf{v})^T$,
直接可以得到
$$
\mathbf{\xi}^\wedge =
\begin{pmatrix}
\theta [\hat{\mathbf{\omega}}]_\times & \mathbf{v} \\
                                      & 0
\end{pmatrix}
$$
式中 $[\cdot]_\times$ 记号与 [旋转](Rigid-Rotation.md#正文) 一文一致.

---

$$\boxed{\begin{align*}
\mathrm{exp}: \mathfrak{se}(3)    &\rightarrow  SE(3) \\
              \mathbf{\xi}^\wedge &\mapsto      T
\end{align*}}$$

按 $\mathrm{exp}$ 的级数定义:

$$\begin{align*}
\exp{\mathbf{\xi}^\wedge} &= \sum_{i=0} \frac{1}{i!} (\mathbf{\xi}^\wedge)^i \\
&= I + \sum_{i=1} \frac{1}{i!} \begin{pmatrix}
	\theta^i [\hat{\mathbf{\omega}}]_\times^i &
	\theta^{i-1} [\hat{\mathbf{\omega}}]_\times^{i-1} \mathbf{v} \\
	                                          & 0
	\end{pmatrix} \\
&= I + \begin{pmatrix}
	\sum_{i=1} \frac{\theta^i}{i!} [\hat{\mathbf{\omega}}]_\times^i &
	(\sum_{i=1} \frac{\theta^{i-1}}{i!} [\hat{\mathbf{\omega}}]_\times^{i-1}) \mathbf{v} \\
	& 0
	\end{pmatrix} \\
&= \begin{pmatrix}
	\sum_{i=0} \frac{\theta^i}{i!} [\hat{\mathbf{\omega}}]_\times^i &
	(\sum_{i=0} \frac{\theta^i}{(i+1)!} [\hat{\mathbf{\omega}}]_\times^i) \mathbf{v} \\
	& 1
	\end{pmatrix} \\
&= \begin{pmatrix}
	\exp{\theta [\hat{\mathbf{\omega}}]_\times} & J \mathbf{v} \\
	& 1
	\end{pmatrix}
\end{align*}$$

其中

$$\begin{align*}
J &= \sum_{i=0} \frac{\theta^i}{(i+1)!} [\hat{\mathbf{\omega}}]_\times^i \\
&= \frac{1}{\theta} \sum_{i=1} \frac{\theta^i}{i!} [\hat{\mathbf{\omega}}]_\times^{i-1} \\
&= \frac{1}{\theta} (\theta I
	+ \frac{\theta^2}{2!} [\hat{\mathbf{\omega}}]_\times
	+ \frac{\theta^3}{3!} [\hat{\mathbf{\omega}}]_\times^2
	+ \cdots) \\
&= \frac{1}{\theta} (\theta I
	+ (\frac{\theta^2}{2!} - \frac{\theta^4}{4!} + \cdots) [\hat{\mathbf{\omega}}]_\times
	- (\frac{\theta^3}{3!} - \frac{\theta^5}{5!} + \cdots) [\hat{\mathbf{\omega}}]_\times^2) \\
&= I + \theta^{-1} (1-\cos{\theta}) [\hat{\mathbf{\omega}}]_\times
	+ (1-\theta^{-1} \sin{\theta}) [\hat{\mathbf{\omega}}]_\times^2
\end{align*}$$

关于如何从反对称矩阵直接获取 $\theta$, 可以参考 [旋转](Rigid-Rotation.md#正文) 中 $\mathrm{exp}$ 一节.

---

$$\boxed{\begin{align*}
\mathrm{log}: SE(3) &\rightarrow  \mathfrak{se}(3) \\
              T     &\mapsto      \mathbf{\xi}^\wedge
\end{align*}}$$

因为有

$$\begin{align*}
\mathrm{exp} \begin{pmatrix}
\theta [\hat{\mathbf{\omega}}]_\times & \mathbf{v} \\
& 0
\end{pmatrix}
&= \begin{pmatrix}
	\exp{\theta [\hat{\mathbf{\omega}}]_\times} & J \mathbf{v} \\
	& 1
	\end{pmatrix} \\
&= \begin{pmatrix}
	R & \mathbf{\rho} \\
	& 1
	\end{pmatrix}
\end{align*}$$

直接得到

$$
\mathrm{log} \begin{pmatrix}
	R & \mathbf{\rho} \\
	& 1
	\end{pmatrix} =
\begin{pmatrix}
\mathrm{log} ~ R & J^{-1} \mathbf{\rho} \\
& 0
\end{pmatrix}
$$

其中 $\mathrm{log} ~ R$ 我们已经得到, 它是李群 $SO(3)$ 到李代数 $\mathfrak{so}(3)$ 的对数映射, 在 [这里](Rigid-Rotation.md#正文) 可以找到.

接下来的工作是寻找矩阵 $J$ 的逆. 容易发现 $J$ 恰是 $[\hat{\mathbf{\omega}}]_\times$ 的多项式, 不妨令 $J = f([\hat{\mathbf{\omega}}]_\times)$.

令 $[\hat{\mathbf{\omega}}]_\times$ 的特征值为 $0$ 与 $\lambda_i \mathrm{i}$, 显然 $f(0) = 1$;
因为 $\mathrm{Im} ~ f(\lambda_i \mathrm{i}) = \theta^{-1} (1-\cos{\theta}) \lambda_i \neq 0$, 所以 $f(\lambda_i \mathrm{i}) \neq 0$.
于是 $J$ 可逆, 且 $J^{-1}$ 是 $[\hat{\mathbf{\omega}}]_\times$ 的多项式.

注意到 $[\hat{\mathbf{\omega}}]_\times^3 = -[\hat{\mathbf{\omega}}]_\times$, 这提示我们 $[\hat{\mathbf{\omega}}]_\times$ 的高次幂可以用 $1$ 到 $2$ 次幂来表示.
不妨使用待定系数法, 令 $J^{-1} = a ~ I + b ~ [\hat{\mathbf{\omega}}]_\times + c ~ [\hat{\mathbf{\omega}}]_\times^2$, 由 $J^{-1} J = I$ 求出系数 $a$, $b$ 与 $c$.

不难求出, $a = 1$, $b = -\frac{1}{2} \theta$, $c = 1 - \frac{\theta}{2} \cot{\frac{\theta}{2}}$. 于是
$$J^{-1} = I - \frac
{1}{2} \theta [\hat{\mathbf{\omega}}]_\times + (1 - \frac{\theta}{2} \cot{\frac{\theta}{2}}) [\hat{\mathbf{\omega}}]_\times^2$$

---

## 资源
根据本文编写的代码可以在[此处](../Work/julia/movement.jl "local")找到 [[Web](https://github.com/EiEddie-s-Mind/julia/blob/master/movement.jl)].
