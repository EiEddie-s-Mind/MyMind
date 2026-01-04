---
tags:
  - 折腾
date: 2026-01-04
title: 使用 Hugo 搭建静态站点
aliases: [使用 Hugo 搭建静态站点]
---

# 使用 Hugo 搭建静态站点
在本地知识库软件编写文章在很多时候已经足够满足我参考的需要, 但若遇上呈给别人台鉴的情况, 终归不够方便.
另外文章虽在 GitHub 保存, 但其缺失对元数据的整理功能, 对于必要的 Markdown 拓展语法支持也不佳, 更关键的是, 其使用的 KaTeX 数学引擎较为简陋, 难以招架文章中出现的连篇累牍的公式.
无奈之下, 恐怕建立一个阅览站点成了唯一可行的选择.

## 主题选择
我希望站点整体上是静态的, 没有过分到眼花缭乱的小动画与动态效果, 主题风格简洁严肃, 就像一本书或一页纸一样, 仅用来供人阅览而不喧宾夺主.
最后我选择的主题是 [book](https://github.com/alex-shpak/hugo-book), 效果和它的名字一样沉静.
然而不得不说的是, 或许我下面的要求过分了点, 没有让我完全满意的主题, book 也不例外.
于是只好对它进行一番改造了.

## 格式化文档
首先要做的就是保证文章格式能够被 hugo 正确识别, 因此一方面要保证元数据的正确, 另一方面要确保正文中没有不被支持的 Markdown 语法.
我们的目的是文章能够在 Obsidian 与 hugo 两端都能被正确渲染.
日后发布文章或博客的工作流将是使用 Obsidian 编写, 并在本地查看审阅, 待满意后使用 hugo 打包并推送服务器上线.

hugo 依赖于 `title` 而非文件名显示文章标题, 使用 `date` 标记文章修改时间, 并且会读取 `tags` 来分类文章.
为了避免流程出错, 与减轻心智负担, 可以在 Obsidian 中安装 [Linter](https://github.com/platers/obsidian-linter) 插件, 它可以自动格式化文档, 并重排与补全元数据.
将 Linter 的 [标题别名](https://platers.github.io/obsidian-linter/settings/yaml-rules/#yaml-title-alias) 部分设置打开, 便可以自动从第一个 `#` 标签处获取文章标题, 并填写到元数据区, 另外还会将标题名作为别名写入.
如果以前在使用 `datetime` 字段储存文档修改或编写日期, **强烈建议改为 `date` 字段**, 因为这一键名在 Obsidian 与 hugo 两端都受到良好的支持.

book 或其他主题提供了一些元数据字段来控制其行为, 例如 `bookToC` 将会控制是否默认展开该文章的目录. 关于 book 的控制字段可以查看其 [文档](https://github.com/alex-shpak/hugo-book?tab=readme-ov-file#page-configuration).

Obsidian 中有些非标准的拓展 Markdown 语法, 例如 *Wiki 链接* 等, 都建议关闭, 因为难以被 hugo 与其他平台的标准化 Markdown 渲染器支持.

但对于一些特别有益的拓展语法, 例如 `admonitions`, 我们希望尽可能地使其可用.
幸运地是 book 主题本身就支持这一语法, 因此我们并不需要大费周章配置.
但如果是不支持此语法的主题, 可以额外安装一个 [hugo-admonitions](https://github.com/KKKZOZ/hugo-admonitions) 主题, 并将其置于主要主题之前, 这样便可覆盖原主题来提供 admonitions 支持, 如下
```
theme = ["hugo-admonitions", "book"]
```

> [!note]
> 一定注意 hugo-admonitions 应该放置于主要主题--这里是 book--前面, 因为主题的使用是从前到后的.
> 
> 另外, 这就是一个 admonition.

## 添加数学支持
接下来为站点添加数学公式渲染支持, 我们将使用 MathJax, 因为相比 KaTeX, 它支持更多 $\LaTeX$ 语法, 例如 `align` 对齐环境等.

hugo 管理站点的方式是 *联合文件系统*.
简单地说, 站点的各项文件配置都是分层的, 放置在上层的文件将会覆盖下层.
目录层级如下所示.
```
<root>
<root>/themes/<theme-a>
...
```
因此, `layouts/baseof.html` 将会覆盖 `themes/book/layouts/baseof.html`, 其余目录和文件皆是同理.

一般来说, 几乎每个主题都会预留 *注入点 (inject)*.
它们是主题中空的占位文件, 等待着被来自上层的文件覆盖.
它们已经被主题中的各项文件引用, 但因为是空的, 不会有任何效果, 当它们被覆盖后, 新文件的内容就会出现在站点中.
这是一种非侵入式的个性化手段.
book 主题中提供的注入点可以在 GitHub [自述文件](https://github.com/alex-shpak/hugo-book?tab=readme-ov-file#partials) 中找到.

因为分层文件系统的存在, 再配合注入点, 我们可以在不修改主题的前提下最大程度地个性化, 当然也包括引入 MathJax.

在 `layouts/partials` 中新建 `mathjax.html`, 用于作为组件被调用.
```html
<!-- layouts/partials/mathjax.html -->
{{ if or .Params.math .Site.Params.math }}
<script>
  window.MathJax = {
    tex: {
      inlineMath: [['$', '$'], ['\\(', '\\)']],
      displayMath: [['$$', '$$'], ['\\[', '\\]']]
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
这段代码引入了 MathJax, 并配置渲染块标识符, 内联公式为 `$...$` `\(...\)`, 行间公式为 `$$...$$` `\[...\]`.

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
delimiters = { block = [['\[', '\]'], ['$$', '$$']], inline = [['\(', '\)'], ['$', '$']] }
```
这会要求 Markdown 解析器将上述标识符中包裹的内容不做任何处理, 直接移交渲染流水线的下一层, 即 MathJax 处理, 于是公式便可正常渲染,

## 定制字体
我希望站点正文字体使用衬线体, 以此增强内容的出版物质感, 更有 "文章感".
book 主题提供了设置字体的 [定制文件](https://github.com/alex-shpak/hugo-book?tab=readme-ov-file#extra-customisation) `assets/_fonts.scss`, 我们修改它即可更换字体.

将下面的内容填入此文件中
```scss
/* assets/_fonts.scss */
@import url('https://fonts.googleapis.com/css2?family=Source+Serif+4:wght@400;600&family=Inter:wght@300;400;600&family=JetBrains+Mono:wght@400;700&display=swap');

:root {
  --paper-font-body: "Source Serif 4", "Noto Serif SC", "serif";
  --paper-font-ui: "Inter", "system-ui", "-apple-system", "Segoe UI", "Helvetica Neue", "Arial";
  --paper-font-mono: "Iosevka", "JetBrains Mono", "ui-monospace", "SFMono-Regular", "Menlo", "monospace";
}


html, body {
  font-family: var(--paper-font-body);
}

h1, h2, h3, h4, h5, h6 {
  font-family: var(--paper-font-ui);
}

code, pre {
  font-family: var(--paper-font-mono);
  font-size: 0.95em;
}
```
这将设置正文字体为衬线体, 标题为无衬线体, 代码块为等宽无衬线体.

## 添加文章修改时间
book 中同样也有修改时间的原生支持, 但是需要与 GitHub 仓库进行集成, 这是一个比较苛刻的条件, 我无法做到, 因此我将手动实现一个放置在左下角的文章修改时间.
如果你对 book 中提供的修改时间显示有兴趣, 可以去看 [站点配置](https://github.com/alex-shpak/hugo-book?tab=readme-ov-file#site-configuration) 中 `enableGitInfo` 与 `BookLastChangeLink` 两个字段.
只有这两者都被正确配置, 时间显示才会开启.

我将利用 book 在**页面内容之后**的注入点 `layouts/partials/docs/inject/content-after.html` 来手动实现一个修改时间显示, 它会读取文档元数据 `date` 字段来格式化为相应的日期显示.

```html
<!-- layouts/partials/docs/inject/content-after.html -->
{{ $date := .Lastmod | default .Date }}

{{ if not .IsHome }}
{{ with $date }}
  <div class="flex flex-wrap justify-between">
    <div class="flex align-center text-sm text-muted">
      <!--img src="{{ partial "docs/icon" "calendar" }}" class="book-icon" alt="{{ partial "docs/text/i18n" "Calendar" }}" /-->
      <span class="overline" style="font-style:italic;">Last updated: {{ .Format (default "January 2, 2006" $.Site.Params.BookDateFormat) }}</span>
    </div>
  </div>
{{ end }}
{{ end }}
```
以及其配套的样式 `overline`
```scss
/* assets/_custom.scss */

.overline {
  display: inline-block;
  position: relative;
  display: block;
  margin-top: 16px;
}

/* 伪元素作为横线 */
.overline::before {
  /* background-color: currentColor; */
  background: var(--gray-200);
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width:100%;
  height: 2px;
  z-index: 2;
  pointer-events: none;
  transform: translateY(-200%);
}
```
这段代码将从文档元数据字段 `date` 中读取日期, 并按站点设置 `BookDateFormat` 中规定的样式格式化.
最后的显示效果为左下角的 *Last updated: January 2, 2006*, 斜体, 上方覆盖一条与文字等长的灰色分割线.

## 最终配置文件
最终使用的 `hugo.toml` 配置文件如下所示
```toml
baseURL = 'https://example.org/'
languageCode = 'zh-cn'
title = "EiEddie's Mind"
# theme = ["hugo-admonitions", "book"]
theme = ["book"]


[params]
math = true
BookTheme = 'auto'
BookDateFormat = 'January 2, 2006'


[markup.tableOfContents]
startLevel = 2
endLevel = 4
ordered = false

[markup.goldmark.renderer]
unsafe = true

[markup.goldmark.extensions.passthrough]
enable = true
delimiters = { block = [['\[', '\]'], ['$$', '$$']], inline = [['\(', '\)'], ['$', '$']] }
```

[^1]: [Hugo+Mathjax的正确姿势](https://www.windtunnel.cn/posts/hugo/hugo-mathjax/)