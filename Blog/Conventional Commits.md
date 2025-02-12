---
tags:
  - git
datetime: 2025-01-26
---

# 约定式提交
约定式提交规定了一套编写 `git` 提交信息的规范, 方便写出清晰, 突出重点, 分类明确的提交信息, 尤其在团队协作时十分必要.

本文中介绍的规范有别于标准的 [约定式提交规范](#参考), 在一些方面做了让步, 方便新手编写.

## 概述
一个提交应由以下几部分组成
```
<类型>: <描述>

[正文]
```

*类型* 字段见下文 [类型](#类型) 一章.

*描述* 应当是对提交的一句话总结, 力求简洁清楚, 重点分明. 对于描述部分的详细解释, 可以写在 *正文* 部分. 正文并非必要, 最好只在提交十分复杂, 或是包含了多个不同修改时编写.

要使用约定式提交, 需要对提交本身进行规范:
- 拆分不同文件的修改. \
	例如文档的修改与源代码的修改应该分开提交;
	配置文件, 测试代码, 编译脚本等等都应该尽量分离.
	可以阅读 [类型](#类型) 一章, 了解哪些修改应该单独提交.
	拆分提交的方法在 [[Git Tips#拆分提交]].
- 尽量更细致地进行提交, 一次提交一个功能的修改. \
	也就是说, 不要一股脑将全部文件的修改送入版本库.
	例如在某一源代码文件中, 既修改了数据的展示方式, 又修改了某 API 的实现,
	那它们应该被拆分为两个提交.
- 避免过于细小的提交. \
	某些微小又不重要的提交,
	例如文档中某个拼写或代码某处符号后的空格, 可以等后面修改此文件时一并提交.

描述与正文部分尽量使用 `markdown` 语言标记. 特别地, 提到文件名时应使用反引号 `` ` `` 括起. 在正文中陈列多条修改时使用 `markdown` 的列表语法.

当修改过多以至于无法细致提交时, 可以在描述处写 **多次提交**, 转而在正文处陈列.
但是强烈建议涉及业务功能的修改不要这样, 以免淹没在不重要的琐碎提交中.

在分支 *合并 (merge)* 时可以不遵守约定式提交, 但是也要具有统一的规范.

相较于标准规范, 取消了关于 *提交范围 (scope)* 和 *破坏性提交* 的部分.

## 类型
- `feat`: 新功能, 新特性.
- `fix`: 修改 bug.
- `perf`: 在不影响代码内部行为的前提下, 更改代码, 对程序性能进行优化.
- `refactor`: 代码重构. 在不影响代码内部行为, 功能下的代码修改.
- `docs`: 文档修改.
- `style`: 代码格式修改. 例如添加分号, 修改或添加空格, 更改缩进格式等.
- `test`: 测试的新增, 修改.
- `build`: 影响项目构建或依赖项修改.
- `revert`: 恢复上一次提交.
- `ci`: 持续集成相关文件修改.
- `chore`: 其他修改, 即不在上述类型中的修改. 例如 `.gitignore` 的修改.

## 更多规范
1. 每个提交都**必须**使用类型字段前缀, 它由一个名词构成, 诸如 `feat` 或 `fix`, 其后接**必要的**冒号（**英文半角**）和**空格**.
2. 当一个提交为应用或类库实现了新功能时, **必须**使用 `feat` 类型.
3. 当一个提交为应用修复了 bug 时, **必须**使用 `fix` 类型.
4. 在简短描述之后, 可以编写较长的提交正文, 为代码变更提供额外的上下文信息. 正文**必须**起始于描述字段结束的一个空行后.
5. 提交的正文内容自由编写, 并使用空行分隔不同段落.
6. 所有符号都建议使用半角符号.

## 参考
[约定式提交规范](https://www.conventionalcommits.org/zh-hans/v1.0.0)