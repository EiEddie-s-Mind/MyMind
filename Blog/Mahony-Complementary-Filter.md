---
tags:
  - 数学
  - 控制
date: 2025-06-30
title: Mahony 非线性互补滤波器
aliases: [Mahony 非线性互补滤波器]
---

# Mahony 非线性互补滤波器

Mahony 互补滤波算法是一种成熟的姿态估计算法, 旨在融合多种传感器的数据来估计最优姿态. 本篇文章将介绍这一滤波器的数学推导与应用.

在第一章中, 我们先约定文章中使用的符号, 并对不同传感器的数据进行建模;
第二章, 从刚体的运动学入手, 使用李群与李代数作为分析工具;
第三章介绍优化姿态的方法, 并引出两个滤波器: **直接互补滤波器** (**Direct Complementary Filter**) 与**被动互补滤波器** (**Passive Complementary Filter**);
第四章在被动互补滤波器的基础上讨论更方便的向量版本, 称为**显式互补滤波器** (**Explicit Complementary Filter**);
在第五章中, 我们进一步讨论显式互补滤波器的四元数版本.
本文将不涉及系统的 Lyapunov 稳定性分析.

本文主要编译自 Mahony 等人发表在 *IEEE Transactions on Automatic Control* 上的论文[^1].

## 符号约定与传感器数据建模
文章中 $[\cdot]_\times$ 表示向量的外积矩阵, 它是一个反对称矩阵.
使用 $\dot{R} := \partial R := \frac{\mathrm{d} R}{\mathrm{d} t}$ 表示求导.
线性函数 $\mathrm{vex}(\cdot)$ 表示将李代数, 即反对称矩阵转为向量;
类似地, 我们有 $\mathrm{wedge}(\cdot)$ 将向量转为李代数.
另外, 约定线性函数 $\mathbb{P}_a(A) := \frac{1}{2} (A - A^T)$ 将矩阵映射为一个反对称矩阵.

自然地约定两个参考坐标系, $\{A\}$ 表示世界全局坐标系, $\{B\}$ 表示固连于刚体上的局部左标系;
另外, 我们还约定 $\{E\}$ 为估计后的局部坐标系, 它被表示为与 $\{B\}$ 固定于同一点, 但是姿态稍有变化.

矩阵 $\sideset{_A^B}{}R$ 表示从 $\{A\}$ 向 $\{B\}$ 的坐标变换, 同时也是 $\{B\}$ 在 $\{A\}$ 中的姿态.
我们也为其中的几个代表另取简洁且富有深意的代号:
原始位姿 $R_y := \sideset{_B^A}{}R$; 估计后的位姿 $\hat{R} := \sideset{_E^A}{}R$ 以及描述 $\{B\}$ 与 $\{E\}$ 的误差 $\tilde{R} := \sideset{_B^E}{}R = \hat{R}^T R_y$.
因为三个参考坐标系都是归一化正交右手坐标系, 因此上述矩阵皆为正交矩阵, 且行列式为正.

### 陀螺仪
陀螺仪测量的是在 $\{B\}$ 中的, 刚体绕过测量中心的一轴的角速度 $\mathbf{\Omega}^y$, 带有偏置 $\mathbf{b}$ 与噪声 $\mathbf{\mu}$.
测量值与真实值 $\mathbf{\Omega} \in \{B\}$ 的关系可以表示为
$$\mathbf{\Omega}^y = \mathbf{\Omega} + \mathbf{b} + \mathbf{\mu}$$

### 加速度计
加速度计测量加速度方向, 同样带有偏置 $\mathbf{b}_a$ 和噪声 $\mathbf{\mu}_a$. 因为受重力的缘故, 加速度计测量的始终是比力 (Specific Force), 即刚体的绝对加速度与重力加速度之和.
于是测量得到的 $\{B\}$ 中的加速度 $\mathbf{a}$ 可以表示为
$$\mathbf{a} = R_y^T (\sideset{^A}{}{\dot{\mathbf{v}}} - \mathbf{g}_0) + \mathbf{b}_a + \mathbf{\mu}_a$$

### 磁力计
同样地, 有偏置 $\mathbf{B}_m$ 与噪声 $\mathbf{\mu}_b$,
测量值 $\mathbf{m} \in \{B\}$ 与真实值 $\sideset{^A}{}{\mathbf{m}}$ 的关系为
$$\mathbf{m} = R_y^T \sideset{^A}{}{\mathbf{m}} + \mathbf{B}_m + \mathbf{\mu}_b$$

## 刚体运动学
我们知道刚体旋转有 $R = \mathrm{e}^{[\Omega]_\times t}$,
于是 $\dot{R} = \partial \mathrm{e}^{[\Omega]_\times t} = \mathrm{e}^{[\Omega]_\times t} [\Omega]_\times = R [\Omega]_\times$.

进一步地, 因为 $[R \Omega]_\times = R [\Omega]_\times R^T$, 有
$$\dot{R} = [R \Omega]_\times R$$

## 姿态估计
文章的中心问题, 也就是姿态估计的中心任务, 是如何求出估计后姿态 $\hat{R}$ 的微分, 以便通过积分来实时确定姿态, 同时确保误差 $\tilde{R}$ 最小.

通过上面的运动学分析, 可以得出 $\dot{\hat{R}} = [R_y \Omega]_\times \hat{R}$, 这其中作用于 $\Omega$ 的矩阵为 $R_y$ 而非 $\hat{R}$, 是因为 $\Omega$ 所在的参考系为 $\{B\}$, 这给了我们设计滤波器方面的一些灵活性.

可以证明, 此时误差 $\tilde{R}$ 恒定
$$\begin{align}
\dot{\tilde{R}} &= \partial (\hat{R}^T R_y) \\
  &= \dot{\hat{R}}^T R_y + \hat{R}^T \dot{R_y} \\
  &= ([R_y \Omega]_\times \hat{R})^T R_y + \hat{R}^T [R_y \Omega]_\times R_y \\
  &= \hat{R}^T [R_y \Omega]_\times^T R_y + \hat{R}^T [R_y \Omega]_\times R_y \\
  &= 0
\end{align}$$

为了消除误差, 我们通过添加一项关于误差的函数 $\omega := \omega(\tilde{R})$ 来引入负反馈
$$\dot{\hat{R}} = [R_y \Omega + k_P \omega]_\times \hat{R}$$

滤波器设计的核心在于函数 $\omega(\tilde{R})$ 的选取. Mahony 等人提出的方案是
$$\begin{align}
\sideset{^E}{}\omega &= \mathrm{vex} ~ \mathbb{P}_a(\tilde{R}) \\
\sideset{^A}{}\omega &= \hat{R} ~ \sideset{^E}{}\omega
\end{align}$$

如此一来我们有
$$\begin{align}
& [R_y \Omega + k_P \hat{R} ~ \mathrm{vex} ~ \mathbb{P}_a(\tilde{R})]_\times \\
  =& ~ [R_y \Omega]_\times + k_P [\hat{R} ~ \mathrm{vex} ~ \mathbb{P}_a(\tilde{R})]_\times \\
  =& ~ [R_y \Omega]_\times + k_P \hat{R} [\mathrm{vex} ~ \mathbb{P}_a(\tilde{R})]_\times \hat{R}^T \\
  =& ~ [R_y \Omega]_\times + k_P \hat{R} \mathbb{P}_a(\tilde{R}) \hat{R}^T \\
  =& ~ [R_y \Omega]_\times + k_P \mathbb{P}_a(R_y \hat{R}^T)
\end{align}$$
$$\dot{\hat{R}} = ([R_y \Omega]_\times + k_P \mathbb{P}_a(R_y \hat{R}^T)) \hat{R}$$

可以证明, 引入的负反馈的确使得误差 $\tilde{R}$ 收敛于 $I$.
为了证明这一点, 引入优化变量
$E := \frac{1}{2} \|I - \tilde{R}\|_F^2 = \mathrm{tr}(I - \tilde{R})$,
对其求导得 $\partial E = \partial ~ \mathrm{tr}(I - \tilde{R}) = -\mathrm{tr} ~ \partial \tilde{R}$. $\tilde{R}$ 的导数如下求得
$$\begin{align}
\dot{\tilde{R}} &= \partial (\hat{R}^T R_y) \\
  &= \dot{\hat{R}}^T R_y + \hat{R}^T [R_y \Omega]_\times R_y \\
  &= \hat{R}^T ([R_y \Omega]_\times + k_P \mathbb{P}_a(R_y \hat{R}^T))^T R_y + \hat{R}^T [R_y \Omega]_\times R_y \\
  &= - k_P \hat{R}^T \mathbb{P}_a(R_y \hat{R}^T) R_y \\
  &= \frac{1}{2} k_P (I - \tilde{R}^2)
\end{align}$$
于是有
$$\begin{align}
\partial E &= - \mathrm{tr} ~ \dot{\tilde{R}} \\
  &= - \frac{1}{2} \mathrm{tr} ~ k_P (I - \tilde{R}^2) \\
  &= - \frac{1}{2} k_P ~ \mathrm{tr} (\cos{\theta} - 1) [\hat{n}]_\times^2 \\
  &= - \frac{1}{2} k_P (\cos{\theta} - 1) (-2 \|\hat{n}\|^2) \\
  &= - k_P (1 - \cos{\theta}) \\
  & \leq 0
\end{align}$$
上面证明中用到的旋转矩阵计算公式可以在 [这里](Rigid-Rotation.md) 中找到.
当且仅当 $\tilde{R}^2$ 的转角 $\theta = 0, 2\pi$ 时取等号,
即 $\tilde{R}$ 转角为 $0$ 或 $\pi$ 时.
对于转角为 $\pi$ 的特殊情况在论文中做了详细讨论.
我们可以认为, 在 $\tilde{R} \neq I$ 时 $E$ 单调递减, 且有下界 $0$,
于是其必收敛于 $0$, 这样就证明了 $\tilde{R}$ 将收敛于 $I$.

附加上关于陀螺仪偏置 $\mathbf{b}$ 的估计, 我们可以引出**直接互补滤波器**:
$$\boxed{\begin{align}
\dot{\hat{R}} &= ([R_y (\Omega^y - \hat{b})]_\times + k_P \mathbb{P}_a(R_y \hat{R}^T)) \hat{R} \\
\dot{\hat{b}} &= - k_I \mathrm{vex} ~ \mathbb{P}_a(\tilde{R})
\end{align}}$$

其中 $R_y$ 作为系统输入, 来自一个优化问题:
$$R_y = \arg \underset{R \in SO(3)}{\min} (\lambda_1 \| \mathbf{e}_3 - R \mathbf{v}_a \|^2 + \lambda_2 \| \mathbf{v}_m^* - R \mathbf{v}_m \|^2)$$
考虑到求解此问题的复杂性, 直接互补滤波器并不便于使用.

我们做近似 $\hat{R} \sim R_y$, 这是基于 $\{B\}$ 与 $\{E\}$ 通常十分接近的假设. 这样有
$$\begin{align}
\dot{\hat{R}} &= [\hat{R} \Omega + k_P \omega]_\times \hat{R} \\
  &= ([\hat{R} \Omega]_\times + k_P \mathbb{P}_a(R_y \hat{R}^T)) \hat{R} \\
  &= \hat{R} ([\Omega]_\times + k_P \mathbb{P}_a (\tilde{R}))
\end{align}$$

接下来我们确认近似的正确性, 通过计算上式是否收敛来检验:
$$\begin{align}
\dot{\tilde{R}} &= \dot{\hat{R}}^T R_y + \hat{R}^T \dot{R_y} \\
  &= (\hat{R} ([\Omega]_\times + k_P \mathbb{P}_a (\tilde{R})))^T R_y \
    + \hat{R}^T R_y [\Omega]_\times \\
  &= ([\Omega]_\times + k_P \mathbb{P}_a (\tilde{R}))^T \hat{R}^T R_y \
    + \hat{R}^T R_y [\Omega]_\times \\
  &= - [\Omega]_\times \tilde{R} + k_P \mathbb{P}_a (\tilde{R}^T) \tilde{R} + \tilde{R} [\Omega]_\times \\
  &= - [\Omega]_\times \tilde{R} + \tilde{R} [\Omega]_\times + \frac{k_P}{2} (I - \tilde{R}^2)
\end{align}$$
$\partial E = - \mathrm{tr} ~ \dot{\tilde{R}} = - \frac{1}{2} \mathrm{tr} ~ k_P (I - \tilde{R}^2)$, 与上面直接互补滤波器的结果一致, 于是收敛性也得到保证.

这一结果被称为**被动互补滤波器**:
$$\boxed{\begin{align}
\dot{\hat{R}} &= \hat{R} ([\Omega^y - \hat{b}]_\times + k_P \mathbb{P}_a (\tilde{R})) \\
\dot{\hat{b}} &= - k_I \mathrm{vex} ~ \mathbb{P}_a(\tilde{R})
\end{align}}$$

因为滤波器内含有 $\tilde{R}$, 包含对 $R_y$ 的依赖, 于是使用同样受到限制.

## 显式互补滤波器
在被动互补滤波器的基础上, 我们消除对 $R_y$ 的显式依赖, 通过直接使用方向向量来构筑滤波器.
这被称为*显式互补滤波器*.

假如我们有 $n$ 组可以确定的方向, 它们可以来自重力方向以及磁场方向等,
记为 $\mathbf{v}_{0i} \in \{A\}$, 另外要求它们是归一化的.
于是我们可以得到在 $\{B\}$ 中的方向 $\mathbf{v}_i = R^T \mathbf{v}_{0i}$,
以及 $\{E\}$ 中的方向 $\hat{\mathbf{v}}_i = \hat{R}^T \mathbf{v}_{0i}$.
我们不妨令第 $i$ 个估计方向与实际方向的误差为 $E_i = 1 - \mathbf{v}_i^T \hat{\mathbf{v}}_i$.
另外, 引入权重 $k_i$ 表征特定参考方向的不确定性, 若其置信度较低, 则 $k_i$ 值应该较小, 以此减小此方向引入的误差.
综上, 令此时的总误差为
$$\begin{align}
E' &= \sum_i k_i E_i \\
  &= \sum_i k_i (1 - \mathbf{v}_i^T \hat{\mathbf{v}}_i) \\
  &= \sum_i k_i - \sum_i k_i \mathbf{v}_i^T \hat{\mathbf{v}}_i
\end{align}$$
其中
$$\begin{align}
\sum_i k_i \mathbf{v}_i^T \hat{\mathbf{v}}_i &= \
  \mathrm{tr} \sum_i k_i \mathbf{v}_i^T \hat{\mathbf{v}}_i \\
  &= \mathrm{tr} \sum_i k_i \hat{\mathbf{v}}_i \mathbf{v}_i^T \\
  &= \mathrm{tr} \sum_i k_i (\hat{R}^T \mathbf{v}_{0i}) (R^T \mathbf{v}_{0i})^T \\
  &= \mathrm{tr} \sum_i k_i \hat{R}^T \mathbf{v}_{0i} \mathbf{v}_{0i}^T R \\
  &= \mathrm{tr} ~ \hat{R}^T R \sum_i k_i R^T \mathbf{v}_{0i} \mathbf{v}_{0i}^T R \\
  &= \mathrm{tr} ~ \tilde{R} M, ~~ M = R^T (\sum_i k_i \mathbf{v}_{0i} \mathbf{v}_{0i}^T) R
\end{align}$$

从上面也可以看出 $\tilde{R} M = \sum_i k_i \hat{\mathbf{v}}_i \mathbf{v}_i^T$.

此时 $E' = \sum_i k_i - \mathrm{tr} ~ \tilde{R} M$ 的形态已经与上述
$E = \mathrm{tr} (I - \tilde{R}) = 3 - \mathrm{tr} ~ \tilde{R}$
极为相似.
仿照 $\sideset{^E}{}\omega(\tilde{R}) = \mathrm{vex} ~ \mathbb{P}_a(\tilde{R})$, 我们令
$$\begin{align}
\omega &= \mathrm{vex} ~ \mathbb{P}_a (\tilde{R} M) \\
  &= \frac{1}{2} \mathrm{vex} (\tilde{R} M - M^T \tilde{R}^T) \\
  &= \frac{1}{2} \mathrm{vex} \sum_i k_i (\hat{\mathbf{v}}_i \mathbf{v}_i^T - \mathbf{v}_i \hat{\mathbf{v}}_i^T) \\
  &= \frac{1}{2} \mathrm{vex} \sum_i k_i [\mathbf{v}_i \times \hat{\mathbf{v}}_i]_\times \\
  &= \frac{1}{2} \sum_i k_i ~ \mathbf{v}_i \times \hat{\mathbf{v}}_i
\end{align}$$
用到的引理
$\mathbf{a} \mathbf{b}^T - \mathbf{b} \mathbf{a}^T = [\mathbf{b} \times \mathbf{a}]_\times$
我们不再证明.

将其代入被动互补滤波器, 就得到了**显式互补滤波器**:
$$\boxed{\begin{align}
\dot{\hat{R}} &= \hat{R} ([\Omega^y - \hat{b}]_\times + k_P [\omega]_\times) \\
\dot{\hat{b}} &= - k_I \omega \\
\text{where} \\
\omega &= \sum_i \frac{k_i}{2} ~ \mathbf{v}_i \times \hat{\mathbf{v}}_i \\
\hat{\mathbf{v}}_i &= \hat{R}^T ~ \mathbf{v}_{0i}
\end{align}}$$

## 四元数滤波运动学
单位四元数可用于描述旋转, 它们构成群 $S^3$,
并且与 $SO(3)$ 之间存在一个自然的群同态.
其中的元素表示为 $q = [\cos{\frac{\Omega}{2}}, \sin{\frac{\Omega}{2}} ~ \hat{\mathbf{n}}] \in S^3$,
它表示了绕单位轴 $\hat{\mathbf{n}}$ 旋转 $\Omega$.

将旋转作用在向量上这一动作用四元数表示为 $q \mathbf{v} q^*$,
其中 $q^*$ 表示 $q$ 的共轭.
特殊地, 旋转矩阵的转置对应于四元数的共轭, 它们都是因为这一操作在各自的约束下与取逆等价.
注意, 这里的向量 $\mathbf{\Omega}$ 都是纯虚四元数
$\mathbf{\Omega} = \Omega_x \mathrm{i} + \Omega_y \mathrm{j} + \Omega_z \mathrm{k}$, 下同.

另外, 可以得到 $S^3$ 中元素的李代数指数表示 $q = \exp{\frac{\Omega}{2} \hat{\mathbf{n}} t} = \exp{\mathbf{\Omega} t/2}$.
于是运动学方程为
$$\dot{q} = q \frac{\mathbf{\Omega}}{2}$$

注意到显式互补滤波器
$\dot{\hat{R}} = \hat{R} ~ [\Omega^y - \hat{b} + k_P \omega]_\times$
与矩阵运动学
$\dot{R} = R ~ [\Omega]_\times$
之间的联系, **基于四元数运动学的显式互补滤波器**可以被自然地导出:
$$\boxed{\begin{align}
\dot{\hat{q}} &= \frac{1}{2} \hat{q} ~ (\Omega^y - \hat{b} + k_P \omega) \\
\dot{\hat{b}} &= - k_I \omega \\
\text{where} \\
\omega &= \sum_i \frac{k_i}{2} ~ \mathbf{v}_i \times \hat{\mathbf{v}}_i \\
\hat{\mathbf{v}}_i &= \hat{q}^* ~ \mathbf{v}_{0i} ~ \hat{q}
\end{align}}$$

定义四元数乘法使用的 Graßmann 积也摘录在此:
对于四元数 $q_1 = [u_1, \mathbf{v}_1]$, $q_2 = [u_2, \mathbf{v}_2]$,
$$q_1 q_2 = [u_1 u_2 - \mathbf{v}_1 \cdot \mathbf{v}_2, ~ u_2 \mathbf{v}_1 + u_1 \mathbf{v}_2 + \mathbf{v}_1 \times \mathbf{v}_2]$$

## 后记
就本文所介绍的三种滤波器以及一种变种来说, 通常而言使用最广泛的是显式互补滤波器及其四元数版本, 通称 Mahony 互补滤波器也是指这两者.

在实际使用中, 对于传感器的数据进行预处理是十分有必要的, 例如剔除加速度计的高频分量来获得稳定的重力方向.
此外, 在估计过程中动态调整不同传感器方向的权重也是规避误差的有效方法.

当已知方向数量在 $2$ 个及以上时, 滤波器在理论上是稳定的.
当参考方向只有 $1$ 个, 例如只有重力方向时, 在正交方向会产生漂移, 此时这一方向上的估计全部依赖于角速度输入.
当没有参考方向时, 滤波器完全退化为对角速度积分.

滤波器给出的输出为估计姿态与偏置的导数, 通过积分可以得到姿态与偏置.
在实际应用中, 离散化的积分因为步长精度原因, 不可避免地会引入截断误差.
此时需要对位姿进行优化来满足约束.
对于矩阵运动学, 优化过程归结为求解*最近旋转矩阵*问题, 也就是将稍有偏差的矩阵映射为严格的 $SO(3)$ 中的元素.
对于四元数运动学, 因为四元数只有 $4$ 个自由度, 冗余的自由度不足以优化旋转所需的 $3$ 个自由度, 我们只能选取一个参量来进行优化.
通常而言选择约束转角, 可以证明, 这等价于对四元数进行归一化.


[^1]: R. Mahony, T. Hamel, and J.-M. Pflimlin, "Nonlinear Complementary Filters on the Special Orthogonal Group", *IEEE Transactions on Automatic Control*, vol. 53, no. 5, pp. 1203–1217, May 2008, doi: [10.1109/TAC.2008.923738](https://doi.org/10.1109/TAC.2008.923738).
