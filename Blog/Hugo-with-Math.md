---
tags:
  - 折腾
date: 2026-01-04
title: 为 Hugo 添加数学支持
aliases: [为 Hugo 添加数学支持]
---

# 为 Hugo 添加数学支持
本文将聚焦于为 hugo 生成的静态站点添加数学公式渲染支持, 我们将使用 MathJax, 因为相比 KaTeX, 它支持更多 $\LaTeX$ 语法, 例如 `align` 对齐环境等.

关于 hugo 的 *联合文件系统* 与 *注入点* 相关内容, 请看 [这篇文章](Static-Site-with-Hugo.md).

首先在 `layouts/partials` 中新建 `mathjax.html`, 用于作为组件被调用.
```html
<!-- layouts/partials/mathjax.html -->
{{ if or .Params.math .Site.Params.math }}
<script>
  window.MathJax = {
    tex: {
      inlineMath: [['\\(', '\\)']],
      displayMath: [['$$', '$$']]
    },
    options: {
      skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre']
    }
  };
</script>
<script
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"
  async>
</script>
{{ end }}
```
这段代码引入了 MathJax, 并配置渲染块标识符, 内联公式为 `\(...\)`, 行间公式为 `$$...$$`.
不使用 `$...$` 与 `\[...\]` 的理由将在后文叙述.

被 `{{ }}` 括起来的部分为 *模板*, 它将作为占位符被解析器用正文替换, 也可作为判断语句.
文件中的模板是一个判断, 意味**仅当文章元数据启用了 `math` 或站点配置中启用了 `math`, 才会引入 MathJax 渲染**.
为了全局启用, 可以在站点配置文件 `hugo.toml` 中声明
```toml
[params]
math = true
```

接下来需要将上述文件引入主题, 我们使用 book 主题提供的 **`<head>` 末尾处**的注入点 `layouts/partials/docs/inject/head.html`.
将下面的内容放入此文件
```html
<!-- layouts/partials/docs/inject/head.html -->
{{ partial "mathjax.html" . }}
```
这段模板会把上面编写的 `partial/mathjax.html` 引入.
于是最终 MathJax 相关代码将会出现在页面 html `<head>` 标签结尾处.

此时理论上就可以使用了, 但是会出现一些 bug, 例如公式块内如果出现 Markdown 语法, 例如 `$$A_n*B_m$$` 中出现了一个 Markdown 强调块 `_..._`, 此时 hugo 将会先按 Markdown 解析, 将 `_..._` 替换成特定的样式, 如此一来公式就不能被正确渲染了.
为了避免这种问题, 我们启用 Markdown 解析时的 *透传* 功能[^1], 在 `hugo.toml` 中配置
```toml
[markup.goldmark.extensions.passthrough]
enable = true
delimiters = { block = [['$$', '$$']], inline = [['\(', '\)']] }
```
这会要求 Markdown 解析器将上述标识符中包裹的内容不做任何处理, 直接移交渲染流水线的下一层, 即 MathJax 处理, 于是公式便可正常渲染.

---

但事情没有这么简单.
我们习惯使用 `$...$` 来编写行内公式, 为何这里不启用对 `$` 的支持呢?
因为日常行文中 `$` 是一个常见的符号, 而且在很多编程语言中作为关键符号存在.
如果我们启用了 `$...$` 支持, 由于 Hugo 的透传机制是先于 Markdown 解析运作的, 即使是包裹在 `` ` `` 内的 \$ 块也会被渲染为公式.
另外, 在 hugo 中转义 \$ 需要双转义 `\\$`, 因为渲染流水线有 Goldmark, 即 hugo 的 Markdown 解析器, 和 MathJax 两层, `\\$` 经过 Goldmark 后变为 `\$`, 而后 MathJax 才知道这不是公式定界符, 从而将其格式化为正常的美元符号 `$`.

综合各方面考虑, 我们将额外添加一个环节, 先使用 pandoc 将 \$ 定界的内联公式块 `$...$` 转为 `\(...\)`, 这样既能在平时使用更熟悉的语法写作, 又避免了纠缠不清的 \$.
另外, 还有一些补全 Goldmark 漏洞的规则, 例如 `$$...$$` 会被识别为行间公式, 于是我们在编写 pandoc 过滤器时将内联代码块内的双美元符号 `$$` 进行转义 `\$\$`;
内联代码块中如果出现这种模式 `\\$` 就会被识别为一个转义的反斜杠与一个美元符号 `\$`, 因此干脆将所有的 `\` 都转义.

下面是能够达成我们目标的 lua 过滤器, 用于被 pandoc 使用
```lua
-- math-delimiter.lua

function Math(el)
  if el.mathtype == "InlineMath" then
    -- $...$ -> \(...\)
    return pandoc.RawInline("markdown", "\\(" .. el.text .. "\\)")
  end
  return nil
end

function Code(el)
  local s = el.text
  -- \ -> \\
  s = s:gsub("\\", "\\\\")
  -- $$ -> \$\$
  s = s:gsub("%$%$", "\\$\\$")
  el.text = s
  return el
end
```

并且应当以下面的方式使用
```bash
pandoc -s in.md -t markdown --lua-filter=math-delimiter.lua -o out.md
```
不要忘记 `-s`/`--standalone=true` 参数, 否则你的元数据将被吞掉.

[^1]: [Hugo+Mathjax的正确姿势](https://www.windtunnel.cn/posts/hugo/hugo-mathjax/)
