---
tags:
  - 数学
  - 物理
  - 控制
  - undone
  - todo
date: 2026-02-17
lastmod: 2026-02-18
title: Delta 机器人的动力学建模
aliases: [Delta 机器人的动力学建模]
---

# Delta 机器人的动力学建模
[Delta 机器人](https://zh.wikipedia.org/wiki/Delta%E6%A9%9F%E5%99%A8%E4%BA%BA) 是一种三自由度的常用并联型机器人.
由于其特殊设计, 能够保证其顶板始终平行于底板, 只有三个平动自由度而无转动.
这一点很容易证明, 此处不再赘述.
因此我们将按下面的模型讨论

![机器人模型](figs/Delta-Robotics/model.png)

机器人有三个可以独立活动的支部, 编号为 $1$, $2$, $3$, 按右手顺序排列, 彼此相隔 $\frac{2\pi}{3}$.
我们之后的讨论将更多只限于同一个支部, 在不引起误会的情况下, 将省略下标以求简洁.
此时我们讨论的将是适用于三支的通用关系.

约定粗体 $\mathbf{L}$ 代表向量, 非粗体的相同字母代表其模长 $L := \|\mathbf{L}\|$.
在模型中, $L_i$, $i = 1,2,3$ 都是等长的, 因此都记为 $L$; $g$ 与 $l$ 同理.
单位坐标轴方向为 $\hat{\mathbf{i}}$, $\hat{\mathbf{j}}$, $\hat{\mathbf{k}}$; $\hat{\cdot}$ 表示归一化.
$P$ 为关心的末端位置.

## 正向运动学
正向运动学解决的问题是如何通过已知的广义坐标 $\theta_i$, $i = 1,2,3$ 来得到 $P$ 的位置.
我们将从底部开始, 逐步地依次求解 $B$, $M$ 直到 $P$ 的位置.

### 中途向量
$\mathbf{g}$ 与 $B$ 的求解是极为简单的.
记方位角 $\phi$ 为三支在水平面上的偏角, 有 $\phi_1 = 0$, $\phi_2 = \frac{2\pi}{3}$, $\phi_3 = \frac{4\pi}{3}$.
于是
$$\mathbf{g} = g ~ (\hat{\mathbf{i}} \cos{\phi} + \hat{\mathbf{j}} \sin{\phi})$$

因为 $M$ 始终在 $\hat{\mathbf{k}}$ 与 $\mathbf{g}$ 张成的平面上, 使用这两个向量作为基底来表示, 注意归一化.
$$\mathbf{L} = L ~ (\hat{\mathbf{g}} \cos{\theta} + \hat{\mathbf{k}} \sin{\theta})$$

现在我们已经可以求出 $M_i$ 的位置了.
为了进一步求出 $\mathbf{l}_i$ 以得到 $P$ 的位置, 注意到 $l_i$ 都相等, 因此 $\mathbf{l}_i$ 为圆锥 $P-\odot{M_1 M_2 M_3}$ 的母线;
$P$ 为顶点.
圆锥的高 $PR$ 垂直于底面; $R$ 为三角形 $M_1 M_2 M_3$ 的外心.
我们将要利用这一几何关系, 首先求出 $R$ 的位置, 而后计算向量 $\overrightarrow{RP}$, 进而得到所求点 $P$.
![机器人的上部机构](figs/Delta-Robotics/model-top.png)

### 三角形外心
首先来解决求已知三角形外心位置的问题.

顶点信息包含在向量 $\mathbf{u}$ 与 $\mathbf{v}$ 中, 并且保证 $\mathbf{u}$, $\mathbf{v}$, $\mathbf{n}$ 是按右手排列的, 即 $\mathbf{n} = \mathbf{u} \times \mathbf{v}$, $\mathbf{n}$ 为圆锥的高所在的方向.
可以找到 $\{\mathbf{u}, \mathbf{v}\}$ 的一组对偶向量 $\{\mathbf{u}_\perp, \mathbf{v}_\perp\}$ 满足 $\mathbf{u} \cdot \mathbf{u}_\perp = \mathbf{u}^T \mathbf{u}_\perp = 0$, $\mathbf{v} \cdot \mathbf{v}_\perp = 0$, 只需令 $\mathbf{u}_\perp = \mathbf{u} \times \hat{\mathbf{n}}$, $\mathbf{v}_\perp = \mathbf{v} \times \hat{\mathbf{n}}$.

此时 $\{\mathbf{u}, \mathbf{u}_\perp\}$ 与 $\{\mathbf{v}, \mathbf{v}_\perp\}$ 分别构成平面的基, 可以将外心坐标 $\mathbf{r}$ 写为 $\mathbf{r} = \frac{1}{2} \mathbf{u} + \lambda \mathbf{u}_\perp = \frac{1}{2} \mathbf{v} + \mu \mathbf{v}_\perp$, 移项得 $\frac{1}{2} (\mathbf{u} - \mathbf{v}) = \mu \mathbf{v}_\perp - \lambda \mathbf{u}_\perp = (\mathbf{u}_\perp, \mathbf{v}_\perp) (-\lambda, \mu)^T$.
令 $A := (\mathbf{u}_\perp, \mathbf{v}_\perp)$, 有方程
$$A \begin{pmatrix}
-\lambda \\
\mu \\
\end{pmatrix} = \frac{1}{2} (\mathbf{u} - \mathbf{v})$$
因为 $\mathbf{u}$ 与 $\mathbf{v}$ 都是三维矢量, 这个方程是超定的, 但是我们可以转换为最小二乘问题
$$A^T A \begin{pmatrix}
  -\lambda \\
  \mu \\
\end{pmatrix} = \frac{1}{2} A^T (\mathbf{u} - \mathbf{v})$$
这就变成了适定方程, 可以求解.

注意到 $\|\mathbf{u}_\perp\| = \|\mathbf{u}\|$, 因为 $\mathbf{u}$ 与 $\hat{\mathbf{n}}$ 是正交的; $\mathbf{u}^T A = (\mathbf{u}^T \mathbf{u}_\perp, \mathbf{u}^T \mathbf{v}_\perp) = (0, \mathbf{u} \cdot (\mathbf{v} \times \hat{\mathbf{n}})) = (0, n)$; $\mathbf{v}^T A = (-n, 0)$, 可得
$$\begin{align}
A^T (\mathbf{u} - \mathbf{v}) &= ((\mathbf{u} - \mathbf{v})^T A)^T \\
  &= (\mathbf{u}^T A - \mathbf{v}^T A)^T \\
  &= (n, n)^T \\
  &= n ~ \mathbf{1}
\end{align}$$

$$\begin{align}
A^T A &= \begin{pmatrix}
  \mathbf{u}^T_\perp \\
  \mathbf{v}^T_\perp \\
\end{pmatrix} (\mathbf{u}_\perp, \mathbf{v}_\perp) \\
  &= \begin{pmatrix}
    u^2 & \mathbf{u} \cdot \mathbf{v} \\
    \mathbf{u} \cdot \mathbf{v} & v^2 \\
  \end{pmatrix}
\end{align}$$

方程改写为
$$\begin{pmatrix}
  u^2 & \mathbf{u} \cdot \mathbf{v} \\
  \mathbf{u} \cdot \mathbf{v} & v^2 \\
\end{pmatrix} \begin{pmatrix}
-\lambda \\
\mu
\end{pmatrix} = \frac{1}{2} n \; \mathbf{1} = S \; \mathbf{1}$$
其中 $S$ 为三角形面积 $S := \frac{1}{2} \|\mathbf{u} \times \mathbf{v}\| = \frac{1}{2} n$.

使用*克莱姆法则*求解 $\lambda$, 有
$$\begin{align}
-\lambda &= \begin{vmatrix}
  S & \mathbf{u} \cdot \mathbf{v} \\
  S & v^2 \\
\end{vmatrix} \Big/ \begin{vmatrix}
  u^2 & \mathbf{u} \cdot \mathbf{v} \\
  \mathbf{u} \cdot \mathbf{v} & v^2 \\
\end{vmatrix} \\
  &= \frac{S ~ (v^2 - \mathbf{u} \cdot \mathbf{v})}{u^2 v^2 - (\mathbf{u} \cdot \mathbf{v})^2} \\
  &= \frac{S ~ (v^2 - \mathbf{u} \cdot \mathbf{v})}{\|\mathbf{u} \times \mathbf{v}\|^2} \\
  &= \frac{S ~ (v^2 - \mathbf{u} \cdot \mathbf{v})}{4 S^2}
\end{align}$$
即
$$ \lambda = \frac{\mathbf{u} \cdot \mathbf{v} - v^2}{4 S}$$

将这一结果代入 $\mathbf{r}$ 的表达式中, 可得
$$\begin{align}
\mathbf{r} = \frac{1}{2} \mathbf{u} + \lambda \mathbf{u}_\perp &= \frac{1}{2} \mathbf{u} + \frac{\mathbf{u} \cdot \mathbf{v} - v^2}{4 S} \; (\mathbf{u} \times \frac{\mathbf{u} \times \mathbf{v}}{n}) \\
  &= \frac{1}{2} \mathbf{u} + \frac{\mathbf{u} \cdot \mathbf{v} - v^2}{4 S} \; \frac{1}{2S} \; ((\mathbf{u} \cdot \mathbf{v}) \, \mathbf{u} - u^2 \mathbf{v}) \\
  &= \frac{1}{2} \mathbf{u} + \frac{1}{8S^2} \; (\mathbf{u} \cdot \mathbf{v} - v^2) \; ((\mathbf{u} \cdot \mathbf{v}) \, \mathbf{u} - u^2 \mathbf{v}) \\
  &= \frac{1}{2} \mathbf{u} + \frac{1}{8S^2} \, ((\mathbf{u} \cdot \mathbf{v})^2 \mathbf{u} - (\mathbf{u} \cdot \mathbf{v}) \, v^2 \mathbf{u} - (\mathbf{u} \cdot \mathbf{v}) \, u^2 \mathbf{v} + u^2 v^2 \mathbf{v}) \\
  &= \frac{1}{8S^2} \, (4S^2 \mathbf{u} + (\mathbf{u} \cdot \mathbf{v})^2 \mathbf{u} - (\mathbf{u} \cdot \mathbf{v})(v^2 \mathbf{u} + u^2 \mathbf{v}) + u^2 v^2 \mathbf{v}) \\
  &= \frac{1}{8S^2} \, (u^2 v^2 (\mathbf{u} + \mathbf{v}) - (\mathbf{u} \cdot \mathbf{v})(v^2 \mathbf{u} + u^2 \mathbf{v}))
\end{align}$$

### 圆锥顶点
$R$ 点的坐标利用上面的公式可以写为
$$R = M_1 + \mathbf{r}(M_2 - M_1, M_3 - M_1)$$
其中 $\mathbf{r}(\mathbf{u}, \mathbf{v}) = \mathbf{r}$.

此时 $RP$ 的长 $h$ 也容易求出, $h = \sqrt{l^2 - r^2}$, 则 $\overrightarrow{RP} = h \, \hat{\mathbf{n}}$.

至此已完成正向运动学建模.

### 代码
```python
import numpy as np
from numpy.linalg import norm


gg = 1.
LL = 1.
ll = 2.

def g_(phi):
    """从原点 O 到底盘上关节固定点 B 的向量: g"""
    i = np.array([1.,0,0])
    j = np.array([0,1.,0])
    return gg*(i*np.cos(phi) + j*np.sin(phi))

def L_(g: np.ndarray, theta):
    """从 B 到传动机构中途点 M 的向量: L"""
    k = np.array([0,0,1.])
    return LL*((g/norm(g))*np.cos(theta) + k*np.sin(theta))

def l_(u: np.ndarray, v: np.ndarray):
    """从 M 到目标点 P 的向量: l"""
    uu2 = norm(u)**2
    vv2 = norm(v)**2
    n   = np.cross(u, v)
    SS  = norm(n) / 2
    r   = (uu2*vv2*(u+v) - (u@v)*(vv2*u+uu2*v)) / (8*SS**2)
    rr2 = norm(r)**2
    nn  = np.sqrt(ll**2 - rr2)
    n   = (n / norm(n)) * nn
    return r + n


def fk(thetas: np.ndarray):
	"""正运动学

	根据广义坐标: 极角 theta_i 求解终端位置 P,
	theta 按右手顺序排列."""
    phis = 2*np.pi/3*np.array([0.,1.,2.])
    O = np.zeros(3)
    M_s = np.zeros((3,3))
    for i, (phi, theta) in enumerate(zip(phis, thetas)):
        g = g_(phi)
        B = O + g
        L = L_(g, theta)
        M = B + L
        M_s[i] = M
    l = l_(M_s[1]-M_s[0], M_s[2]-M_s[0])
    P = M_s[0] + l
    return P
```