---
tags:
  - 数学
  - julia
date: 2025-03-01
title: 三维空间中旋转的描述
aliases: [三维空间中旋转的描述]
---

# 三维空间中旋转的描述

三维空间中所有正交且行列式为 $1$ 的矩阵组成一个群, 称为 *特殊正交群* $SO(3)$,
其中的每个元素都代表一种三维空间中的旋转.

另外, $SO(3)$ 也是一个 *李群*, 它的 *李代数* $\mathfrak{so}(3)$ 中的元素是轴角向量的外积矩阵.

本篇文章的工作是推导 $SO(3)$, $\mathfrak{so}(3)$ 与 $\mathbb{R}^3$ 中元素的互相转换.

## 引理

$$\boxed{
[\mathbf{\omega}]_\times^2 = \mathbf{\omega} \mathbf{\omega}^T - \|\mathbf{\omega}\|^2 I
}$$

$$\begin{align*}
([\mathbf{\omega}]_\times^2)_{ij} &= \varepsilon_{imk} \omega_m ~ \varepsilon_{knj} \omega_n \\
                                  &= \varepsilon_{kim} \varepsilon_{knj} ~ \omega_m \omega_n \\
                                  &= (\delta_{in} \delta_{mj} - \delta_{ij} \delta_{mn}) \omega_m \omega_n \\
                                  &= \omega_i \omega_j - \delta_{ij} \omega_m \omega_m \\
                                  &= (\mathbf{\omega} \mathbf{\omega}^T - \|\mathbf{\omega}\|^2 I)_{ij}
\end{align*}$$

---

$$\boxed{
[\mathbf{\omega}]_\times^3 = - \|\mathbf{\omega}\|^2 [\mathbf{\omega}]_\times
}$$

$$\begin{align*}
[\mathbf{\omega}]_\times^3 &= (\mathbf{\omega} \mathbf{\omega}^T - \|\mathbf{\omega}\|^2 I) [\mathbf{\omega}]_\times \\
                           &= \mathbf{\omega} \mathbf{\omega}^T [\mathbf{\omega}]_\times - \|\mathbf{\omega}\|^2 [\mathbf{\omega}]_\times \\
                           &= \mathbf{\omega} ([\mathbf{\omega}]_\times \mathbf{\omega})^T - \|\mathbf{\omega}\|^2 [\mathbf{\omega}]_\times \\
                           &= \mathbf{\omega} (\mathbf{\omega} \times \mathbf{\omega})^T - \|\mathbf{\omega}\|^2 [\mathbf{\omega}]_\times \\
                           &= - \|\mathbf{\omega}\|^2 [\mathbf{\omega}]_\times
\end{align*}$$

---

$$\boxed{
\mathrm{rank} [\mathbf{\omega}]_\times = 2
}$$
其中 $\mathbf{\omega} \in \mathbb{R}^3 \backslash \{0\}$.

$$\begin{align*}
\mathrm{rank} ~ [\mathbf{\omega}]_\times = 2 & \Leftrightarrow \mathrm{dim} ~ \mathrm{Ker} ~ [\mathbf{\omega}]_\times = 1 \\
& \Leftrightarrow [\mathbf{\omega}]_\times \mathbf{x} = 0 ~ \text{解集的维数为} ~ 1
\end{align*}$$
考察上述方程:
$$\begin{align*}
[\mathbf{\omega}]_\times \mathbf{x} = 0 & \Leftrightarrow \mathbf{\omega} \times \mathbf{x} = 0 \\
& \Leftrightarrow \| \mathbf{\omega} \times \mathbf{x} \| = 0 \\
& \Leftrightarrow \| \mathbf{\omega} \| \| \mathbf{x} \| \sin{\theta} = 0 \\
& \Leftrightarrow \sin{\theta} = 0 \\
& \Leftrightarrow \theta \in \pi \mathbb{Z} \\
& \Leftrightarrow \mathbf{x} \parallel \mathbf{\omega} \\
& \Leftrightarrow \mathbf{x} \in \left< \mathbf{\omega} \right>
\end{align*}$$
显然 $\mathrm{dim} \left< \mathbf{\omega} \right> = 1$, 原式得证.

---

## 正文

$$\boxed{\begin{align*}
\wedge: \mathbb{R}^3    &\rightarrow \mathfrak{so}(3)         \\
        \mathbf{\omega} &\mapsto     [\mathbf{\omega}]_\times
\end{align*}}$$

$\wedge$ 将向量映射为反对称矩阵, 并且要求:
$$\forall \mathbf{v} \in \mathbb{R}^3, \mathbf{\omega} \times \mathbf{v} = \mathbf{\omega}^\wedge \mathbf{v}$$
这也是记号 $[\cdot]_\times$ 的用处.

我们知道 $(\mathbf{\omega} \times \mathbf{v})_i = \varepsilon_{ijk} \omega_j v_k$,
进而 $(\mathbf{\omega}^\wedge \mathbf{v})_i = (\varepsilon_{ijk} \omega_j) v_k$.
于是 $(\mathbf{\omega}^\wedge)_{ik} = \varepsilon_{ijk} \omega_j$, 即
$$(\mathbf{\omega}^\wedge)_{ij} = \varepsilon_{ikj} \omega_k$$

---

$$\boxed{\begin{align*}
\mathrm{exp}: \mathfrak{so}(3)                      &\rightarrow  SO(3) \\
              \theta [\hat{\mathbf{\omega}}]_\times &\mapsto      R
\end{align*}}$$

$\mathrm{exp}$ 将李代数中的元素映射为对应李群中的元素.
$R = \exp{\theta [\hat{\mathbf{\omega}}]_\times} = \mathrm{e}^{\theta [\hat{\mathbf{\omega}}]_\times}$,
且仍按 $\mathrm{exp}$ 的级数定义.
于是有
$$\begin{align*}
R &= \mathrm{e}^{\theta [\hat{\mathbf{\omega}}]_\times} \\
  &= I + \theta [\hat{\mathbf{\omega}}]_\times + \frac{1}{2!} \theta^2 [\hat{\mathbf{\omega}}]_\times^2
       + \frac{1}{3!} \theta^3 [\hat{\mathbf{\omega}}]_\times^3 + \cdots \\
  &= I + (\theta - \frac{1}{3!} \theta^3 + \cdots) [\hat{\mathbf{\omega}}]_\times
       + (\frac{1}{2!} \theta^2 - \frac{1}{4!} \theta^4 + \cdots) [\hat{\mathbf{\omega}}]_\times^2 \\
  &= I + \sin{\theta} [\mathbf{\omega}]_\times + (1-\cos{\theta}) [\hat{\mathbf{\omega}}]_\times^2 \\
  &= \cos{\theta} I + (1-\cos{\theta}) \hat{\mathbf{\omega}} \hat{\mathbf{\omega}}^T + \sin{\theta} [\hat{\mathbf{\omega}}]_\times
\end{align*}$$

另外, 对于 $[\mathbf{\omega}]_\times = \theta [\hat{\mathbf{\omega}}]_\times$, 其中 $\hat{\mathbf{\omega}}$ 为单位向量,
我们有办法直接从 $[\mathbf{\omega}]_\times$ 提取 $\theta$.

注意到 $[\mathbf{\omega}]_\times^2 = \mathbf{\omega} \mathbf{\omega}^T - \|\mathbf{\omega}\|^2 I$, 两边取迹, 有
$$\begin{align*}
\mathrm{tr} [\mathbf{\omega}]_\times^2 &= \mathrm{tr} (\mathbf{\omega} \mathbf{\omega}^T - \|\mathbf{\omega}\|^2 I) \\
&= \mathrm{tr} \mathbf{\omega}^T \mathbf{\omega} - \|\mathbf{\omega}\|^2 \mathrm{tr} I \\
&= \|\mathbf{\omega}\|^2 - 3 \|\mathbf{\omega}\|^2 \\
&= -2 \|\mathbf{\omega}\|^2
\end{align*}$$

如此, $\|\mathbf{\omega}\| = \sqrt{-\frac{1}{2} \mathrm{tr} [\mathbf{\omega}]_\times^2}$.

---

$$\boxed{\begin{align*}
\mathrm{log}: SO(3) &\rightarrow  \mathfrak{so}(3) \\
              R     &\mapsto      \theta [\hat{\mathbf{\omega}}]_\times
\end{align*}}$$

首先, 确定转角 $\theta$. 注意到对
$R = \cos{\theta} I + (1-\cos{\theta}) \hat{\mathbf{\omega}} \hat{\mathbf{\omega}}^T + \sin{\theta} [\hat{\mathbf{\omega}}]_\times$
两端取迹, 可得
$$\begin{align*}
\mathrm{tr} R &= \mathrm{tr} (\cos{\theta} I)
                 + \mathrm{tr} ((1-\cos{\theta}) \hat{\mathbf{\omega}} \hat{\mathbf{\omega}}^T)
                 + \mathrm{tr} (\sin{\theta} [\hat{\mathbf{\omega}}]_\times) \\
              &= 3\cos{\theta} + (1-\cos{\theta}) \mathrm{tr} (\hat{\mathbf{\omega}}^T \hat{\mathbf{\omega}}) + 0 \\
              &= 3\cos{\theta} + (1-\cos{\theta}) \mathrm{tr} \| \hat{\mathbf{\omega}} \|^2 \\
              &= 2\cos{\theta} + 1
\end{align*}$$
因此 $\cos{\theta} = \frac{\mathrm{tr} R - 1}{2}$.

容易发现,
$R^T = R^{-1}
= \cos{(-\theta)} I + (1-\cos{(-\theta)}) \hat{\mathbf{\omega}} \hat{\mathbf{\omega}}^T + \sin{(-\theta)} [\hat{\mathbf{\omega}}]_\times
= \cos{\theta} I + (1-\cos{\theta}) \hat{\mathbf{\omega}} \hat{\mathbf{\omega}}^T - \sin{\theta} [\hat{\mathbf{\omega}}]_\times$.
与 $R$ 作差, 得 $R-R^T = 2\sin{\theta} [\hat{\mathbf{\omega}}]_\times$.
于是 $[\hat{\mathbf{\omega}}]_\times = \frac{1}{2\sin{\theta}} (R-R^T)$.

这里指出, $\mathrm{arccos}$ 的值域为 $[0,\pi]$, 貌似会不能覆盖全部 $[0, 2\pi)$ 范围.
事实上, 角度有 $\theta$ 与 $2\pi-\theta$ (或 $-\theta$) 两种可能, 后者不能从 $\mathrm{arccos}$ 得到.
但当实际角度为后者时, $[\hat{\mathbf{\omega}}]_\times$ 也多出一个负号.
因此最终角度为 $(-\theta) (-[\hat{\mathbf{\omega}}]_\times) = \theta [\hat{\mathbf{\omega}}]_\times$, 与实际一致.

特殊地, 当 $\theta = \pi$ 时, 分母为 $0$, 出现奇异解.
此时发现
$R = I + \sin{\pi} [\hat{\mathbf{\omega}}]_\times + (1-\cos{\pi}) [\hat{\mathbf{\omega}}]_\times^2
= I + 2 [\hat{\mathbf{\omega}}]_\times^2$,
所以 $[\hat{\mathbf{\omega}}]_\times^2 = \frac{1}{2} (R - I)$.

注意到
$[\mathbf{\omega}]_\times^2 \mathbf{\omega}
= [\mathbf{\omega}]_\times (\mathbf{\omega} \times \mathbf{\omega})
= 0$,
因此 $\mathbf{\omega} \in \mathrm{Ker} [\mathbf{\omega}]_\times^2$.
又有
$\mathrm{rank} [\mathbf{\omega}]_\times^2
= \mathrm{rank} ([\mathbf{\omega}]_\times^T)^T [\mathbf{\omega}]_\times
= \mathrm{rank} [\mathbf{\omega}]_\times^T [\mathbf{\omega}]_\times
= \mathrm{rank} [\mathbf{\omega}]_\times
= 2$,
可以得出 $\mathrm{dim} ~ \mathrm{Ker} [\mathbf{\omega}]_\times^2 = 3 - \mathrm{rank} [\mathbf{\omega}]_\times^2 = 1$.

所以对于 $\theta = \pi$, $\hat{\mathbf{\omega}} \in \mathrm{Ker} (R - I)$.
不必担心出现多解.

---

## 杂七杂八

$$\boxed{
R [\mathbf{\omega}]_\times R^T = [R \mathbf{\omega}]_\times
}$$

首先, 不加证明地直接给出:
对于三维空间中按右手排列的一组规范正交基 $\mathbf{e}_i$, $i = 1,2,3$,
有 $\mathbf{e}_i \times \mathbf{e}_j = \varepsilon_{ijk} ~  \mathbf{e}_k$.

$$\begin{align*}
(R [\mathbf{\omega}]_\times R^T)_{ij} &= R_{im} ~ \varepsilon_{mkn} \omega_k ~ R_{jn} \\
&= \varepsilon_{mkn} ~ (R_i)_m ~ \omega_k ~ (R_j)_n \\
&= \mathbf{R}_i \cdot (\mathbf{\omega} \times \mathbf{R}_j) \\
&= - \mathbf{\omega} \cdot (\mathbf{R}_i \times \mathbf{R}_j) \\
&= - \mathbf{\omega} \cdot \varepsilon_{ijk} \mathbf{R}_k \\
&= \varepsilon_{ikj} \mathbf{R}_k \cdot \mathbf{\omega} \\
&= \varepsilon_{ikj} ~ R_{kn} \omega_n \\
&= \varepsilon_{ikj} ~ (R \mathbf{\omega})_k \\
&= ([R \mathbf{\omega}]_\times)_{ij}
\end{align*}$$

其中 $\mathbf{R_i}$ 表示 $R$ 的第 $i$ 个列向量.
需要指出, 对于 $R \in SO(3)$, 因为 $\mathrm{det} R = 1$,
所以列向量 $\mathbf{R_i}$, $i = 1,2,3$ 是以右手坐标排列的.
这也是使用引理的必要条件.

---

## 资源
根据本文编写的代码可以在[此处](../Work/julia/rotation.jl "local")找到 [[Web](https://github.com/EiEddie-s-Mind/julia/blob/master/rotation.jl)].
