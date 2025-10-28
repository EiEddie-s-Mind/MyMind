---
tags:
  - 数学
  - 物理
  - 计算机图形学
  - undone
datetime: 2025-10-26
---

# 密度流体的动态模拟
我们将不可压缩流体的模拟分为两类, 一类聚焦于流体本身, 另一类则聚焦依托于流场的标量场.
前者称为**体积流体**, 如水与空气二相的模拟, 我们更关心流体本身的运动;
后者称为**密度流体**, 如充斥于密闭容器中的浊液的模拟, 我们关注的是溶质的物质的量密度这一标量.
需要注意的是这两个词仅为本篇文章的约定, 而非正式的学术用语.

本文讲述了不可压缩密度流体的运动学模拟.
纵览符合这一条件的流场, 如附加温度场, 容质的密度场等, 其标量场都耦合于流体的速度场.
这是指标量会被流体输运, 例如温度的对流;
标量场同时可以反过来影响速度场, 例如渗透压导致的流体运动, 但我们一般不认为它会破坏流体的不可压缩性, 否则这将导致被求解方程的形式变得极端复杂.

写出不可压缩流体的*纳维-斯托克斯方程*:
$$\nabla \cdot \mathbf{u} = 0$$
$$\frac{\mathrm{D} \mathbf{u}}{\mathrm{D} t} = -\nabla \frac{p}{\rho} + \nu \nabla^2 \mathbf{u} + \mathbf{a}$$
前者是质量守恒定律对应的连续性方程在不可压缩, 即 $\rho \equiv \mathrm{const}$ 时的推论;
后者是牛顿第二定律.
其中 $\nu$ 是*运动粘度*, $\nu := \mu/\rho$, $\mu$ 是*动力粘度*.
流体力学中, 我们一般用 $\mathbf{u}$ 代表速度.

后式中出现的*随质导数*, 或称*物质导数* $\frac{\mathrm{D}}{\mathrm{D} t} := \frac{\partial}{\partial t} + (\mathbf{u} \cdot \nabla)$.
这一式中前者表示欧拉导数; 后者表示拉格朗日导数, 即由于流体的运动带来的变化, 这个效应称为移流.
将其拆开可以写为
$$\frac{\partial \mathbf{u}}{\partial t} = -\nabla \frac{p}{\rho} - (\mathbf{u} \cdot \nabla) \mathbf{u} + \nu \nabla^2 \mathbf{u} + \mathbf{a}$$

接下来, 我们将首先讨论速度场的模拟, 这一过程中积累的经验可以被移用到标量场的模拟内.
必须注意: **本文将聚焦于视觉效果而非真实的物理过程**.
本文主要参考 Stam 发表的论文[^1].

## 速度场
为了在计算机中模拟, 需要对空间进行离散化.
最显而易见的方式是网格法.
这一方法将空间划分为许多细密的网格, 每一格点都保存有这一位置的模拟量, 在这里是速度 $\mathbf{u}$.
当网格划分地足够细时, 我们认为系统的演化收敛于连续情况, 这是显然的.

值得注意的是, 为了方便施予边界条件, 我们将网格靠外再扩充一层.
这一层并不属于网格的范围, 也不参与计算, 它被称为**幽灵层**;
而紧贴幽灵层的, 属于网格范围的最外层被称为**边界**.
对于我们希望观察的密闭容器, 微分方程的边界条件可以被简单地设置为:
幽灵层是边界的相反数.
这样便可保证边界的动能被幽灵层全部消耗, 不会有速度逸散出去.
在下面的每一步后, 都必须重新设置幽灵层的值, 以保证边界条件始终满足.

### 算子分裂
速度场的模拟将被分为几个步骤顺序进行, 这是由于时间离散化导致的妥协, 但我们仍可以认为当时间步取得足够小时, 最终的效果与理想的连续时间演化相差甚微.

首先进行的是将源, 即外加的力或加速度添加到速度场中;
其次是**扩散** (**diffuse**), 这使流体表现出粘性;
接着是**平流** (**advect**), 这使速度随流体运动而运输, 形成速度流.
每一步都必须在设定的边界条件下进行; 并且都要进行**投影** (**project**), 以保证流体不可压缩.

我们之所以这样做, 是因为以下两点. \
第一, 方程中 $-\nabla \frac{p}{\rho}$ 项的作用是保证流体的不可压缩性, 即 $\nabla \cdot \mathbf{u} = 0$. <!-- TODO: 需要数学证明 --> \
第二, 方程可以被拆分为以下形式:
$$\mathbf{u}^*(t+\mathrm{d}t) = \mathbf{u}(t) + \mathbf{a} \; \mathrm{d}t + \nu \nabla^2 \mathbf{u} \; \mathrm{d}t - (\mathbf{u} \cdot \nabla) \mathbf{u} \; \mathrm{d}t$$
上式中 $\mathbf{u}(t)$ 是 $t$ 时刻的速度;
$\mathbf{u}^*(t+\mathrm{d}t)$ 是 $t + \mathrm{d}t$ 时刻的速度, $(\cdot)^*$ 代表此时的速度因为方程中缺少 $-\nabla \frac{p}{\rho}$ 一项而导致散度不为 $0$, 即不可压缩性被破坏.
$\mathbf{u}$ 代表在 $t \sim t+\mathrm{d}t$ 内某个时间的速度, 在式中出现多次时每次对应的时间都不同.
由拉格朗日中值定理, 这一时间必然存在以使上式成立.

定义 $\mathbf{u}^{\mathrm{f}*} := \mathbf{u}(t) + \mathbf{a} \; \mathrm{d}t$ 为加入源后的速度场, 注意此时仍然不满足不可压缩性; \
$\mathbf{u}^{\mathrm{d}*} := \mathbf{u}^{\mathrm{f}*} + \nu \nabla^2 \mathbf{u} \; \mathrm{d}t$ 为扩散后的速度场; \
$\mathbf{u}^* = \mathbf{u}^{\mathrm{v}*} := \mathbf{u}^{\mathrm{d}*} - (\mathbf{u} \cdot \nabla) \mathbf{u} \; \mathrm{d}t$ 为平流后的速度场. \
此时便可以明显看出顺序进行几个步骤.
为了保证物理实际, 对每个得到的中间步骤 (除加入源后的) 进行投影, 最后得到的场 $\mathbf{u}$ 便是推进了时间 $\mathrm{d}t$ 的不可压缩的速度. 用图表示为
$$\mathbf{u}(t) \rightarrow \mathbf{u}^{\mathrm{f}*} \rightarrow \mathbf{u}^{\mathrm{d}*} \rightarrow \mathbf{u}^{\mathrm{d}} \rightarrow (\mathbf{u}^{*} = \mathbf{u}^{\mathrm{v}*}) \rightarrow \mathbf{u}(t+\mathrm{d}t)$$

一个被回避的问题是我们只说明了每一个步骤中使用的 $\mathbf{u}$ 的存在性, 而没有给出其具体取值.
Stam 的指导是**使用前一步计算出的速度**.
这一指导的动机在于始终避免用具有散度的不正常速度进行计算, 同时保证速度的实时性.
下面的章节将展示具体的计算过程.

上面的方法被称为**算子分裂**.
它将耦合的复杂方程拆分为几个简单便于求解的方程, 降低了处理难度.
值得注意的是扩散与对流的顺序似乎是任意的, 但只要考虑到扩散过程会将速度平滑化, 有助于避免出现尖锐的速度区, 就会知道将其放置于更靠前的位置可以改善后续步骤的数值稳定性与精度, 因此这一顺序更加合理.

### 扩散
扩散对应的方程为
$$\frac{\partial \mathbf{u}}{\partial t} = \nu \nabla^2 \mathbf{u}$$
将其写为离散时间形式
$$\mathbf{u}^{\mathrm{d}*}(t+\Delta t) = \mathbf{u}(t) + (\nu \nabla^2 \mathbf{u}(t)) \Delta t$$

较为困难的是将 Laplace 算子 $\nabla^2$ 进行空间的离散化.
在平面直角坐标系中, 有 $\nabla^2 = \partial_x^2 + \partial_y^2$;
并且
$$\frac{\partial \mathbf{u}(\mathbf{r})}{\partial x} = \frac{\mathbf{u}(\mathbf{r}+\mathrm{d}\mathbf{x}) - \mathbf{u}(\mathbf{r})}{\mathrm{d}x}$$
$$\frac{\partial^2 \mathbf{u}(\mathbf{r})}{\partial x^2}
  = \frac{(\mathbf{u}(\mathbf{r}+\mathrm{d}\mathbf{x}) - \mathbf{u}(\mathbf{r})) - (\mathbf{u}(\mathbf{r}) - \mathbf{u}(\mathbf{r}-\mathrm{d}\mathbf{x}))}
  {\mathrm{d}x^2}$$
对 $y$ 求偏导同理.
整理并离散化可得
$$\begin{align}
\nabla^2 \mathbf{u}(\mathbf{r})
  = & \frac{\mathbf{u}(\mathbf{r}+\Delta \mathbf{x}) + \mathbf{u}(\mathbf{r}-\Delta \mathbf{x}) - 2 \mathbf{u}(\mathbf{r})}{\Delta x^2} \\
  & + \frac{\mathbf{u}(\mathbf{r}+\Delta \mathbf{y}) + \mathbf{u}(\mathbf{r}-\Delta \mathbf{y}) - 2 \mathbf{u}(\mathbf{r})}{\Delta y^2}
\end{align}$$
为了计算方便, 我们要求**每个格子都是正方形**.
设其边长为 $l$, 则
$$\begin{align}
\nabla^2 \mathbf{u}
  = & \frac{\mathbf{u}(x+\Delta x) + \mathbf{u}(x-\Delta x) - 2 \mathbf{u}}{l^2} \\
  & + \frac{\mathbf{u}(y+\Delta y) + \mathbf{u}(y-\Delta y) - 2 \mathbf{u}}{l^2} \\
  = & \frac{\mathbf{u}(x+\Delta x) + \mathbf{u}(x-\Delta x) + \mathbf{u}(y+\Delta y) + \mathbf{u}(y-\Delta y) - 4 \mathbf{u}}{l^2}
\end{align}$$
这样一来, $\nabla^2$ 只与当前位置格子, 以及与这一格子直接相邻的 4 格的速度, 他们整体呈十字形分布.
如果要求更高精度, 可以将四个角点也纳入考虑, 但对于我们需要的流体模拟来说上述 5 个点已经足够.
我们将四个邻点之和记作 $\sum_\mathrm{nbr} \mathbf{u} := \mathbf{u}(x+\Delta x) + \mathbf{u}(x-\Delta x) + \mathbf{u}(y+\Delta y) + \mathbf{u}(y-\Delta y)$.

将我们上面求得的 Laplace 算子代入方程, 得到
$$\mathbf{u}^{\mathrm{d}*}(t+\Delta t) - \mathbf{u}(t) = \nu \Delta t \; \nabla^2 \mathrm{u}(\tau)$$
其中 $\tau \in [t, t+\Delta t]$.
选择更靠后的时间更有利于保证系统保持最新, 若选择 $\tau = t+\Delta t$ 则有
$$\mathbf{u}^{\mathrm{d}*} - \mathbf{u} = \nu \Delta t \; \nabla^2 \mathbf{u}^{\mathrm{d}*}$$
将上面计算得到的离散 Laplace 算子代入, 得
$$\begin{align}
\mathbf{u}^{\mathrm{d}*} - \mathbf{u} &= \frac{\nu \Delta t}{l^2} \; (\sum_{\mathrm{nbr}} \mathbf{u}^{\mathrm{d}*} - 4 \mathbf{u}^{\mathrm{d}*}) \\
\Leftrightarrow (1 + 4k) \mathbf{u}^{\mathrm{d}*} &= \mathbf{u} + k \sum_{\mathrm{nbr}} \mathbf{u}^{\mathrm{d}*} \\
\Leftrightarrow \mathbf{u}^{\mathrm{d}*} &= \frac{\mathbf{u} + k \sum_{\mathrm{nbr}} \mathbf{u}^{\mathrm{d}*}}{1 + 4k}
\end{align}$$
其中 $k = \frac{\nu \Delta t}{l^2}$.

上式给出了一种使用逐格遍历网格来求解扩散方程的方法, 称为 **Gauss–Seidel 迭代法**.
为了提高精度, 通常要按上式迭代数次.
注意, 左侧为迭代结果, 右侧为对原始网格与结果缓冲区的操作.
这一迭代法需要逐格计算, 每次对单个格点的计算依赖于前几步计算, 这一点可以从右侧的求和看出.
这一特性保证了计算时始终能够使用最新的信息, 提高了收敛速度; 但也导致了算法不易并行化.

扩散前, 需要设置合适的边界条件;
扩散过程结束后, 需要对 $\mathbf{u}^{\mathrm{d}*}$ 进行投影得到 $\mathbf{u}^{\mathrm{d}}$, 以消除速度场的散度, 保证流体不可压.

### 平流
平流对应的方程为
$$\frac{\partial \mathbf{u}}{\partial t} = - (\mathbf{u} \cdot \nabla) \mathbf{u}$$

求解这一方程可以使用朴素的欧拉法, 即计算每个微小时间段内的演进, 但是这一方法在速度较大或时间步长过长时数值不稳定.
为了解决这一问题, 我们使用 **半 Lagrangian 法** 来求解方程.

半 Lagrangian 法基于这样一个事实: \
对于依赖位置与时间的连续函数 $\phi(\mathbf{r}, t)$, 当 $\frac{\partial \phi}{\partial t} = (\mathbf{v} \cdot \nabla) \phi$, 则始终有 $\phi(\mathbf{r} + \mathrm{d}\mathbf{r}, t) = \phi(\mathbf{r}, t + \mathrm{d}t)$, 其中 $\mathrm{d}\mathbf{r} = \mathbf{v} \mathrm{d}t$. \
下面我们证明这一定理. \
$$\phi(\mathbf{r}, t + \mathrm{d}t) = \phi(\mathbf{r}, t) + \frac{\partial}{\partial t} \phi \; \mathrm{d}t$$
$$\begin{align}
\phi(\mathbf{r} + \mathrm{d}\mathbf{r}, t) &= \phi(\mathbf{r}, t) + \frac{\partial}{\partial \mathbf{r}} \phi \cdot \mathrm{d}\mathbf{r} \\
  &=  \phi(\mathbf{r}, t) + \frac{\partial}{\partial \mathbf{r}} \phi \cdot \mathbf{v} \mathrm{d}t \\
  &=  \phi(\mathbf{r}, t) + \mathbf{v} \cdot \frac{\partial}{\partial \mathbf{r}} \phi \; \mathrm{d}t \\
  &=  \phi(\mathbf{r}, t) + (\mathbf{v} \cdot \nabla) \phi \; \mathrm{d}t
\end{align}$$
于是 $\phi(\mathbf{r} + \mathrm{d}\mathbf{r}, t) = \phi(\mathbf{r}, t + \mathrm{d}t)$.

将这一定理应用到 $\mathbf{u}$ 的两个分量上, 并令 $\mathbf{v} := -\mathbf{u}$, 可以得到
$$\mathbf{u}^{\mathrm{v}*} = \mathbf{u}(\mathbf{r}, t + \mathrm{d}t) = \mathbf{u}(\mathbf{r} - \mathbf{u} \mathrm{d}t, t)$$
于是求 $\mathrm{d}t$ 时间之后的速度场等价于将每个点向后平移 $\mathbf{u}\mathrm{d}t$ 得到的速度场.
这样取得的结果面对较长时间步长时仍然具有较好的数值稳定性.

需要注意的是, 格点 $\mathbf{r}$ 总是处于有序的整数位置, 因此总是可以准确获知其对应的速度, 因为速度被存在相应位置的变量中.
但对格点 $\mathbf{r}$ 计算 $\mathbf{r}' := \mathbf{r} - \mathbf{u} \mathrm{d}t$ 得到的值却总是不会出现在整数位置处, 因此如何获取其速度是我们面对的挑战.
一个简单的方法是对包围 $\mathbf{r}'$ 的四点所对应的速度进行插值, 以此结果作为该点的速度.
所使用的插值方法可以是*双线性插值*或其他.
这一方法的重大弊端是取得的速度并非精确值, 它总是具有较大的误差, 这是由于插值而引入的.
当我们将平流方法应用在要求严格守恒 (物质的量守恒或质量守恒) 的组分上时, 这一组分的守恒要求便被破坏, 只能通过其他方法来弥补.

同上,
平流前需要设置合适的边界条件;
平流后需要对 $\mathbf{u}^{*} = \mathbf{u}^{\mathrm{v}*}$ 进行投影得到 $\mathbf{u}$, 以消除速度场的散度, 保证流体不可压.

### 投影

## 标量场


[^1]: J. Stam, "Real-Time Fluid Dynamics for Games", *Proceedings of the Game Developers Conference*, Mar 2003
