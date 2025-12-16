---
tags:
  - 物理
datetime: 2025-12-15
---

# 量子力学中的角动量
在量子力学中, 除了我们能够想象的沿轨道运动和绕自转轴转动的公转角动量与自转角动量, 这两者分别称为轨道角动量与自旋角动量, 对于任意 $\mathbf{J}$, 只要其分量 $J_\alpha$ 满足
$$ [J_\alpha, J_\beta] = \mathrm{i} \hbar \, \varepsilon_{\alpha \beta \gamma} \, J_\gamma $$
则我们称它为一种角动量.
角动量都具有以下对易关系
$$[\mathbf{J}^2, J_\alpha] = 0$$
这说明角动量的值与某一个角动量分量可以被同时测得, 一般我们选择 $z$ 轴分量 $J_z$.

我们将角动量值 $\mathbf{J}^2$ 与 $z$ 轴角动量 $J_z$ 的共同本征态记作 $\ket{\lambda, m}$, 其中 $\mathbf{J}^2 \ket{\lambda, m} = \lambda \hbar^2 \ket{\lambda, m}$, $J_z \ket{\lambda, m} = m \hbar \ket{\lambda, m}$.

## 阶梯算符
定义两个重要的**阶梯算符** $J_\pm := J_x \pm \mathrm{i} J_y$.
这两个算符不是厄米算符, 因此它不能对应一种可观测的力学量.
我们可以发现它的对易关系
$$[J_+, J_-] = 2\hbar \, J_z$$
$$[J_z, J_\pm] = \pm \hbar \, J_\pm$$
$$[\mathbf{J}^2, J_\pm] = 0$$

$J_\pm$ 的物理意义与其本征态及其本征值可以通过下面的方法得到.
注意到
$$\begin{align}
J_z (J_\pm \ket{\lambda, m}) &= ([J_z, J_\pm] + J_\pm J_z) \ket{\lambda, m} \\
  &= (\pm \hbar J_\pm + J_\pm J_z) \ket{\lambda, m} \\
  &= \pm \hbar \, J_\pm \ket{\lambda, m} + m \hbar \, J_\pm \ket{\lambda, m} \\
  &= (m \pm 1) \hbar \, (J_\pm \ket{\lambda, m})
\end{align}$$
于是 $J_\pm \ket{\lambda, m}$ 仍然是 $J_z$ 的本征态, 但是被 $J_\pm$ 作用后本征值发生了改变, 即
$$J_\pm \ket{\lambda, m} = k_\pm \ket{\lambda, m \pm 1}$$
系数 $k_\pm$ 目前还不能确定.
就像在台阶上运动一样, 有上有下, 这就是为什么这两个算符得名阶梯算符.

容易证明, $J_\pm \ket{\lambda, m}$ 仍然是 $\mathbf{J}^2$ 的本征态, 于是这一态矢依然为 $J_z$ 与 $\mathbf{J}^2$ 的共同本征态.

现在我们尝试确定系数 $k_\pm$ 的值.
首先, 一个重要的等式如下
$$\begin{align}
J_\pm J_\mp &= (J_x \pm \mathrm{i} J_y) (J_x \mp \mathrm{i} J_y) \\
  &= J_x^2 + J_y^2 \mp \mathrm{i} [J_x, J_y] \\
  &= \mathbf{J}^2 - J_z^2 \pm \hbar J_z
\end{align}$$
或者是其另一种写法
$$\mathbf{J}^2 = J_\pm J_\mp + J_z^2 \mp \hbar J_z$$
这将角动量的值与升降算符和 $J_z$ 联系起来. 你也可以用这个等式证明上面给出的 $J_+$ 与 $J_-$ 的对易关系.
我们计算 $J_\pm \ket{\lambda, m}$ 的模
$$\begin{align}
||J_\pm \ket{\lambda, m}||^2 &= \bra{\lambda, m} J_\pm^\dagger J_\pm \ket{\lambda, m} \\
  &= \bra{\lambda, m} J_\mp J_\pm \ket{\lambda, m} \\
  &= \bra{\lambda, m} \mathbf{J}^2 - J_z^2 \mp \hbar J_z \ket{\lambda, m} \\
  &= (\lambda - m^2 \mp m) \hbar^2
\end{align}$$
同时还要保证 $\ket{\lambda, m \pm 1} = k_\pm^{-1} J_\pm \ket{\lambda, m}$ 仍然是归一化的, 正如我们对每个态矢都要求的那样, 从这一点得到
$$\begin{align}
||k_\pm||^2 &= ||J_\pm \ket{\lambda, m}||^2 \\
  &= (\lambda - m^2 \mp m) \hbar^2
\end{align}$$
此处有一个重要的问题: *是否能容忍 $k_\pm$ 中存在相因子?* 或者说, $k_\pm$ 是一个复数, 还是一个实数?
我们将会发现, 引入这一相因子不会有任何好处, 只会带来无穷的麻烦. <!-- TODO -->
于是我们希望 $k_\pm$ 是一个单纯的实数.
这样一来 $k_\pm = \sqrt{\lambda - m^2 \mp m} \hbar \ge 0$,
$$J_\pm \ket{\lambda, m} = \sqrt{\lambda - m (m \pm 1)} \, \hbar \, \ket{\lambda, m \pm 1}$$

## 共同本征态
现在我们确定 $\mathbf{J}^2$ 与 $J_z$ 的共同本征态 $\ket{\lambda, m}$ 中参数 $\lambda$ 与 $m$ 的取值与意义.

无论何时, 我们知道 $\mathbf{J}^2 \ge J_z^2$, 将其作用到态矢上得到
$$\lambda \ge m^2$$
这启示我们, $m$ 必须有界, 记其最大值为 $\overline{m}$, 最小值 $\underline{m}$; 目前没有证据表明 $m$ 必须为正, 事实上我们现在可以猜测到的约束仅有 $\overline{m} = -\underline{m} \ge 0$, 这一猜想将在后文被证明是正确的.
重申一下, 我们设的 $\overline{m}$ 是 $J_z$ 能够存在的最大本征值; $\underline{m}$ 则是最小本征值.
需要注意的是我们的确可以知道 $\lambda \ge 0$, 考虑到当 $\lambda = 0$ 时量子将不具有角动量 $\mathbf{J}^2 \ket{0, m} = 0$, 我们认为这是无意义的, 因此规定 $\lambda > 0$.

考虑一个 $m$ 处于最高的态 $\ket{\lambda, \overline{m}}$, 对其使用升算符 $J_+$ 将不能使 $m$ 再继续升高, 因为其已经在能到达的最大值.
我们假设 $J_+ \ket{\lambda, \overline{m}}$ 处于一个与众不同的态 $\ket{\psi} := J_+ \ket{\lambda, \overline{m}}$, 其有 $L_z \ket{\psi} = (\overline{m}+1) \ket{\psi}$, 这一等式的推导与上文完全相同. 可以发现这与我们要求的 $\overline{m}$ 为最大本征值矛盾, 因此只能有 $\ket{\psi} = 0$.
于是
$$\begin{align}
0 &= \bra{\lambda, \overline{m}} J_- J_+ \ket{\lambda, \overline{m}} \\
  &= \bra{\lambda, \overline{m}} \mathbf{J}^2 - J_z^2 - \hbar J_z \ket{\lambda, \overline{m}} \\
  &= (\lambda - \overline{m}^2 - \overline{m}) \hbar^2 \\
  &\Leftrightarrow \lambda = (\overline{m} + 1) \overline{m}
\end{align}$$
同理, 对 $\underline{m}$ 讨论, 可以得到类似的结论
$$\lambda = (\underline{m} - 1) \underline{m}$$
比较这两个式子, 可以得到
$$\underline{m} = -\overline{m}$$
与我们的猜测一致.

$m$ 的取值为 $\underline{m} \le m \le \overline{m}$, 从最低态 $\ket{\lambda, \underline{m}}$ 出发, 经过 $n$ 次升算符 $L_+$ 的作用, 态矢将来到最高态 $\ket{\lambda, \overline{m}}$.
这意味着 $\underline{m} + n = \overline{m}$, 即 $\overline{m} = \frac{n}{2}$, 其中 $n \in \mathbb{N}_+$, $\overline{m}$ 的取值可以是整数或半奇数.

我们采取一种新的量子数表征总角动量 $\mathbf{J}^2$ 的本征值 $l (l+1) = \lambda$, 此时本征态为 $\ket{l, m}$
$$\mathbf{J}^2 \ket{l, m} = l (l+1) \hbar^2 \ket{l, m}$$
其中 $l$ 的取值为 $l > 0$, 且 $l$ 可以是半奇数或整数.
对于给定的 $l$, 允许的 $m$ 值为 $-l, -l + 1, \cdots, l - 1, l$, 共 $2l + 1$ 个.

## 轨道角动量
我们所熟知的经典力学中的角动量 $\mathbf{L} = \mathbf{r} \times \mathbf{p}$ 也有相应的量子对应, 只需将动量 $\mathbf{p}$ 改写为算符形式
$$ \mathbf{L} = - \mathrm{i} \hbar \, \mathbf{r} \times \nabla$$
这被称之为轨道角动量.
按不怎么量子的说法, 这是粒子, 如电子在轨道上公转的角动量.
当然, 我们知道, 电子既没有确定的位置, 也并不像地球绕太阳那样公转.

### 球坐标系下的算符
对于角动量而言, 我们总是习惯于使用球坐标系进行讨论, 因为它天然具有良好的对称性.
在球坐标系下, 有
$$\nabla = \hat{\mathbf{r}} \, \partial_r + \frac{1}{r} \nabla_\Omega$$
其中 $\nabla_\Omega$ 是角向算子, 有
$$\nabla_\Omega = \hat{\mathbf{\theta}} \, \partial_\theta + \hat{\mathbf{\phi}} \, \frac{1}{\sin{\theta}} \partial_\phi$$

于是有
$$\begin{align}
\mathbf{L} &= - \mathrm{i} \hbar \, \mathbf{r} \times \nabla \\
  &= - \mathrm{i} \hbar \, r \hat{\mathbf{r}} \times (\hat{\mathbf{r}} \, \partial_r + \frac{1}{r} \nabla_\Omega) \\
  &= - \mathrm{i} \hbar \, \hat{\mathbf{r}} \times \nabla_\Omega \\
  &= - \mathrm{i} \hbar \, (\hat{\mathbf{\phi}} \, \partial_\theta - \hat{\mathbf{\theta}} \frac{1}{\sin{\theta}} \partial_\phi)
\end{align}$$
将 $\hat{\mathbf{\theta}}$ 与 $\hat{\mathbf{\phi}}$ 在平面直角坐标系下展开, 有 $\hat{\mathbf{\theta}} = \cos{\theta} \cos{\phi} \, \hat{\mathbf{i}} + \cos{\theta} \sin{\phi} \, \hat{\mathbf{j}} - \sin{\theta} \, \hat{\mathbf{k}}$, $\hat{\mathbf{\phi}} = -\sin{\phi} \, \hat{\mathbf{i}} + \cos{\phi} \, \hat{\mathbf{j}}$, 代入 $\mathbf{L}$, 将分量集中可以得到
$$L_x = - \mathrm{i} \hbar (-\sin{\phi} \, \partial_\theta - \cos{\phi} \cot{\theta} \, \partial_\phi)$$
$$L_y = - \mathrm{i} \hbar (\cos{\phi} \, \partial_\theta - \sin{\phi} \cot{\theta} \, \partial_\phi)$$
$$L_z = - \mathrm{i} \hbar \, \partial_\phi$$
这样我们还得到了阶梯算符 $L_\pm$
$$L_\pm = \pm \hbar \mathrm{e}^{\pm \mathrm{i} \phi} (\partial_\theta \pm \mathrm{i} \cot{\theta} \, \partial_\phi)$$

可以看到上述算符都不涉及径向分量 $r$, 于是我们选择转轴 $\hat{\mathbf{n}}$ 表象来讨论角动量态矢的具体表达式 $Y_{l m}(\theta, \phi)$, 即
$$\braket{\hat{\mathbf{n}} | l, m} = Y_{l m}(\theta, \phi)$$

### 最高权态
我们首先研究的是 $m$ 取最大值, 即 $m = l$ 时 $\braket{\hat{\mathbf{n}} | l, l}$ 的具体表达式, 这被称之为最高权态.

假设其具有分离变量形式 $\braket{\hat{\mathbf{n}} | l, l} = \Theta(\theta) \, \Phi(\phi)$,
考虑到算符 $L_z$ 与 $L_+$ 作用的结果, 我们有
$$\begin{align}
& L_z \braket{\hat{\mathbf{n}} | l, l} = l \hbar \braket{\hat{\mathbf{n}} | l, l} \\
\Rightarrow & - \mathrm{i} \hbar \, \partial_\phi \braket{\hat{\mathbf{n}} | l, l} = l \hbar \braket{\hat{\mathbf{n}} | l, l} \\
\Rightarrow & \, \frac{\mathrm{d} \Phi}{\mathrm{d} \phi} = \mathrm{i} l \Phi \\
\Rightarrow & \, \Phi(\phi) = \mathrm{e}^{\mathrm{i} l \phi}
\end{align}$$
进一步确定 $\Theta$ 的表达式
$$\begin{align}
& L_+ \braket{\hat{\mathbf{n}} | l, l} = 0 \\
\Rightarrow & - \mathrm{i} \hbar \, \mathrm{e}^{\mathrm{i} \phi} (\mathrm{i} \, \partial_\theta - \cot{\theta} \, \partial_\phi) \braket{\hat{\mathbf{n}} | l, l} = 0 \\
\Rightarrow & \, \mathrm{i} \Phi \frac{\mathrm{d} \Theta}{\mathrm{d} \theta} = \cot{\theta} \, \Theta \frac{\mathrm{d} \Phi}{\mathrm{d} \phi} = \cot{\theta} \, \Theta \, \mathrm{i} l \Phi \\
\Rightarrow & \, \frac{\mathrm{d} \Theta}{\mathrm{d} \theta} = l \cot{\theta} \, \Theta
\end{align}$$
分离变量得
$$\begin{align}
& \frac{\mathrm{d} \Theta}{\Theta} = l \cot{\theta} \, \mathrm{d} \theta \\
\Rightarrow & \, \ln{\Theta} + C' = l \ln{\sin{\theta}} \\
\Rightarrow & \, \Theta(\theta) = C \sin^l{\theta}
\end{align}$$

综上,
$$\braket{\hat{\mathbf{n}} | l, l} = C \mathrm{e}^{\mathrm{i} l \phi} \sin^l{\theta}$$

接下来确定归一化系数 $C$ 的值.
对 $||\braket{\hat{\mathbf{n}} | l, l} \, ||^2 = C^2 \sin^{2l}{\theta}$ 做积分
$$\begin{align}
\int_0^{2\pi} \mathrm{d} \phi \int_0^\pi \sin{\theta} \, \mathrm{d} \theta \; \sin^{2l}{\theta} &= 2 \pi \int_0^\pi \sin^{2l+1}{\theta} \, \mathrm{d} \theta \\
  &= 4 \pi \int_0^{\frac{\pi}{2}} \sin^{2l+1}{\theta} \, \mathrm{d} \theta \\
  &= 4 \pi \frac{(2l)!!}{(2l+1)!!} \\
  &= 4 \pi \frac{((2l)!!)^2}{(2l+1) (2l)!} \\
  &= 4 \pi \frac{(2^l \, l!)^2}{(2l+1) (2l)!}
\end{align}$$
过程使用了 $(2l)!! (2l+1)!! = (2l+1)!$, $(2l)!! = 2^l \, l!$, 这里我们不证.
为了使 $\braket{\hat{\mathbf{n}} | l, l}$ 归一化, 需要使 $C$ 取
$$C = \frac{(-1)^l}{2^l \, l!} \sqrt{\frac{(2l+1) (2l)!}{4 \pi}}$$

当然, 归一化条件确定不了相因子 $(-1)^l$, 加入这一项是为了从 $\braket{\hat{\mathbf{n}} | l, l}$ 连续使用 $L_-$ 下降到 $\braket{\hat{\mathbf{n}} | l, 0}$ 时, 得到的 $Y_{l 0}$ 有着与勒让德多项式相同的符号.

### 球谐函数
从最高权态出发, 连续使用降算符, 我们可以得到从 $m = l$ 到 $m = 0$ 的一系列态.
我们将使用这种方法得到一般情况下 $\braket{\hat{\mathbf{n}} | l, m}$ 的表达式.

降算符为 $L_- = \hbar \mathrm{e}^{- \mathrm{i} \phi} (-\partial_\theta + \mathrm{i} \cot{\theta} \, \partial_\phi)$, 为了使从 $\braket{\hat{\mathbf{n}} | l, m}$ 降低的态 $\braket{\hat{\mathbf{n}} | l, m-1}$ 保证仍是归一化的, 我们将要使用上文推导的 $k_-$ 系数, 将降算符改写为
$$\begin{align}
\braket{\hat{\mathbf{n}} | l, m-1} &= \frac{\bra{\hat{\mathbf{n}}} L_- \ket{l, m}}{k_-} \\
  &= \frac{\bra{\hat{\mathbf{n}}} L_- \ket{l, m}}{\sqrt{l (l + 1) - m (m - 1)} \, \hbar} \\
  &= \frac{\bra{\hat{\mathbf{n}}} L_- \ket{l, m}}{\sqrt{(l + m) (l - m + 1)} \, \hbar} \\
  &= \frac{1}{\sqrt{(l + m) (l - m + 1)}} \mathrm{e}^{- \mathrm{i} \phi} (-\partial_\theta + \mathrm{i} \cot{\theta} \, \partial_\phi) \braket{\hat{\mathbf{n}} | l, m}
\end{align}$$

我们将先略去系数, 只讨论函数形式的变化; 得到表达式后补上系数使其归一化.
现在我们将从 $\braket{\hat{\mathbf{n}} | l, l}$ 态降低 $n := l - m$ 次到达 $\braket{\hat{\mathbf{n}} | l, m}$, 即
$$\begin{align}
\braket{\hat{\mathbf{n}} | l, m} &\sim (\mathrm{e}^{- \mathrm{i} \phi} (-\partial_\theta + \mathrm{i} \cot{\theta} \, \partial_\phi))^n \braket{\hat{\mathbf{n}} | l, m} \\
  & \sim (\mathrm{e}^{- \mathrm{i} \phi} (-\partial_\theta + \mathrm{i} \cot{\theta} \, \partial_\phi))^n \, \mathrm{e}^{\mathrm{i} l \phi} \sin^l{\theta} \\
  &= (\mathrm{e}^{- \mathrm{i} \phi} (-\partial_\theta + \mathrm{i} \cot{\theta} \, \partial_\phi))^{n-1} ~ (\mathrm{e}^{- \mathrm{i} \phi} (-\partial_\theta + \mathrm{i} \cot{\theta} \, \partial_\phi)) ~ \mathrm{e}^{\mathrm{i} l \phi} \sin^l{\theta} \\
  &= (\mathrm{e}^{- \mathrm{i} \phi} (-\partial_\theta + \mathrm{i} \cot{\theta} \, \partial_\phi))^{n-1} ~ \mathrm{e}^{\mathrm{i} (l-1) \phi} ~ (-\partial_\theta - l \cot{\theta}) ~ \sin^l{\theta} \\
  &= \cdots \\
  &= \mathrm{e}^{\mathrm{i} (l-n) \phi} (-\partial_\theta - (m+1) \cot{\theta}) (-\partial_\theta - (m+2) \cot{\theta}) \cdots (-\partial_\theta - l \cot{\theta}) \sin^l{\theta} \\
  &= (-1)^n \mathrm{e}^{\mathrm{i} m \phi} (\partial_\theta + (m+1) \cot{\theta}) (\partial_\theta + (m+2) \cot{\theta}) \cdots (\partial_\theta + l \cot{\theta}) \sin^l{\theta}
\end{align}$$

为了求解后面的 $n$ 次求导, 关键的一点是注意到
$$\partial_\theta + r \cot{\theta} = \frac{1}{\sin^r{\theta}} \partial_\theta \sin^r{\theta}$$
需要注意 $\partial_\theta \sin^r{\theta}$ 仍然是算符, 需要与右侧待给出的表达式结合后计算.
证明这一等式是容易的
$$\begin{align}
\partial_\theta \sin^r{\theta} &= \frac{\mathrm{d}}{\mathrm{d} \theta} \sin^r{\theta} + \sin^r{\theta} \, \partial_\theta \\
  &= r \cos{\theta} \sin^{r-1}{\theta} + \sin^r{\theta} \, \partial_\theta \\
  &= \sin^r{\theta} \, (r \cot{\theta} + \, \partial_\theta)
\end{align}$$

接下来可以处理 $n$ 次求导了.
$$\begin{align}
& (\partial_\theta + (m+1) \cot{\theta}) \cdots (\partial_\theta + (l-1) \cot{\theta}) (\partial_\theta + l \cot{\theta}) \sin^l{\theta} \\
= & (\partial_\theta + (m+1) \cot{\theta}) \cdots (\partial_\theta + (l-1) \cot{\theta}) ~ \frac{1}{\sin^l{\theta}} \partial_\theta \sin^{2l}{\theta} \\
= & (\partial_\theta + (m+1) \cot{\theta}) \cdots \frac{1}{\sin^{l-1}{\theta}} \partial_\theta \sin^{l-1}{\theta} ~ \frac{1}{\sin^l{\theta}} \partial_\theta \sin^{2l}{\theta} \\
= & (\partial_\theta + (m+1) \cot{\theta}) \cdots \frac{1}{\sin^{l-1}{\theta}} \partial_\theta (\frac{1}{\sin{\theta}} \partial_\theta) \sin^{2l}{\theta} \\
= & \cdots \\
= & \frac{1}{\sin^{m+1}{\theta}} \partial_\theta \cdots (\frac{1}{\sin{\theta}} \partial_\theta) (\frac{1}{\sin{\theta}} \partial_\theta) \sin^{2l}{\theta} \\
= & \frac{1}{\sin^m{\theta}} (\frac{1}{\sin{\theta}} \partial_\theta)^n \sin^{2l}{\theta} \\
= & \frac{(-1)^n}{\sin^m{\theta}} \frac{\mathrm{d}^n}{\mathrm{d} (\cos{\theta})^n} \sin^{2l}{\theta}
\end{align}$$
其中用到了 $\frac{\mathrm{d}}{\mathrm{d} \cos{\theta}} = - \frac{1}{\sin{\theta}} \frac{\mathrm{d}}{\mathrm{d} \theta}$.

最后考虑 $n$ 次求导过程中归一化系数的变化
$$\begin{align}
&\frac{1}{\sqrt{(l+m+1)(l-m)}} \frac{1}{\sqrt{(l+m+2)(l-m-1)}} \cdots \frac{1}{\sqrt{(2l-1) \, 2}} \frac{1}{\sqrt{2l}} \\
= & \frac{1}{\sqrt{\frac{(2l)!}{(l+m)!}(l-m)!}} \\
= & \sqrt{\frac{(l+m)!}{(2l)! (l-m)!}}
\end{align}$$

综上所述, 我们得到了
$$\begin{align}
Y_{l m} &= \braket{\hat{\mathbf{n}} | l, m} \\
  &= C \sqrt{\frac{(l+m)!}{(2l)! (l-m)!}} ~ (-1)^n \mathrm{e}^{\mathrm{i} m \phi} ~ \frac{(-1)^n}{\sin^m{\theta}} \frac{\mathrm{d}^n}{\mathrm{d} (\cos{\theta})^n} \sin^{2l}{\theta} \\
  &= \frac{(-1)^l}{2^l \, l!} \sqrt{\frac{(2l+1) (2l)!}{4 \pi}} \sqrt{\frac{(l+m)!}{(2l)! (l-m)!}} ~ \mathrm{e}^{\mathrm{i} m \phi} ~ \frac{1}{\sin^m{\theta}} \frac{\mathrm{d}^n}{\mathrm{d} (\cos{\theta})^n} \sin^{2l}{\theta} \\
  &= \frac{(-1)^l}{2^l \, l!} \sqrt{\frac{(2l+1) (l+m)!}{4 \pi (l-m)!}}  ~  \mathrm{e}^{\mathrm{i} m \phi} ~ \frac{1}{\sin^m{\theta}} \frac{\mathrm{d}^{l-m}}{\mathrm{d} (\cos{\theta})^{l-m}} \sin^{2l}{\theta}
\end{align}$$
可以认出这就是我们所熟知的球谐函数.
