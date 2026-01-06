---
tags:
  - 折腾
  - 物理
date: 2026-01-03
title: 带有单位的物理计算
aliases:
  - 带有单位的物理计算
---

# 带有单位的物理计算

## Mathematica
**Mathematica** 中可以带单位计算; 同样, 可以获取任意物理常数, 并以任意精度进行计算.

要使用物理常数, 首先使用 `Quantity` 函数获取它并保存在变量里, 接着就可以在运算中使用这一常数的带有单位的精确值. 例如
```
h = Quantity["PlanckConstant"]
```
获取了*普朗克常量*的值并保存在变量 `h` 中.

如果想要知道该常数在国际单位制下的准确值, 可以使用函数 `UnitConvert`. 例如
```
UnitConvert@Quantity["PlanckConstant"]
```
将给出结果
$$\frac{132521403}{200000000000000000000000000000000000000000} \mathrm{kg ~ m^2 / s}$$

要定义带有单位的变量, 依旧使用 `Quantity`, 只需如下所示
```
Quantity[600*^6, "Hz"] (* 给出 600000000 Hz *)

Quantity[1, "kg m/s^2"] (* 给出 1 kg m/s^2 *)
```
软件在解析单位时较慢, 但识别较为精确.

还可以使用语法 `Ctrl+=` 输入, 这其实是*自然语言输入*, 可以替换函数 `Quantity`, 只需按下 `Ctrl+=` 后输入想要的常数或带单位量即可. 例如 `600*^6Hz`, `1 kg m/s^2`, `Planck Constant` 等等, 都可被正常识别.

要将带单位的运算结果约化为最简单的国际单位, 或是转化为想要的其他单位, 依旧使用 `UnitConvert`. 具体操作可以查看该函数的文档.

在处理常数时, 其实软件也会将所需常数也视为一个单位来处理, 这样可以将两者通过同一套自然的方式统一起来.

## Julia
一些简单的物理计算可以在 **Julia** 中完成, 物理常数与带单位的量通过包 `Unitful` 提供支持. 需要注意的是 Julia 只能完成数值计算, 无法进行符号计算.

使用 `using Unitful.DefaultSymbols` 激活单位功能, 此时就可以为数值添加单位, 例如 `1kg*m/s^2` 给出结果 `1 kg m s^-2` 等等. 对于没有以变量形式给出的单位, 可以使用单位字符串 `u""` 指定, 例如 `1u"eV"` 给出 1 *电子伏特*. 阅读 [文档](https://juliaphysics.github.io/Unitful.jl/stable) 以获取更多信息.

单位同样也被注册为函数, 作为转换器, 使用目标单位可以将物理量转换为以该单位表示, 例如 `J(1u"eV")` 与 `1u"eV" |> J` 都会将能量单位电子伏特的值转为按焦耳为单位 `1.602176634e-19 J`. 同样支持语法 `u"eV"(1J)` 或 `1J |> u"eV"`.

`Unitful` 内置了许多带单位物理常量, 但是无法全部一次性加载到环境中, 必须显式 `include`. 可供使用的物理常数列举在 [文档](https://juliaphysics.github.io/Unitful.jl/stable/defaultunits/#Physical-constants) 中,
