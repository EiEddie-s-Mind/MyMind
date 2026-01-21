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

本篇文章着重介绍站点本身的配置与搭建, 关于内容的编写与发布请看 [这篇文章](Article-Processing-Pipeline.md).

## 主题选择
我希望站点整体上是静态的, 没有过分到眼花缭乱的小动画与动态效果, 主题风格简洁严肃, 就像一本书或一页纸一样, 仅用来供人阅览而不喧宾夺主.
最后我选择的主题是 [book](https://github.com/alex-shpak/hugo-book), 效果和它的名字一样沉静.
然而不得不说的是, 或许我下面的要求过分了点, 没有让我完全满意的主题, book 也不例外.
于是只好对它进行一番改造了.

## 特殊语法支持
一些 Markdown 方言提供了特别有益的拓展语法, 例如 `admonitions`, 我们希望尽可能地使其可用.
幸运地是 book 主题本身就支持这一语法, 因此我们并不需要大费周章配置.
但如果是不支持此语法的主题, 可以额外安装一个 [hugo-admonitions](https://github.com/KKKZOZ/hugo-admonitions) 主题, 并将其置于主要主题之前, 这样便可覆盖原主题来提供 admonitions 支持, 如下
```
theme = ["hugo-admonitions", "book"]
```

> [!note]
> 
> 一定注意 hugo-admonitions 应该放置于主要主题 -- 这里是 book-- 前面, 因为主题的使用是从前到后的.
> 
> 另外, 这就是一个 admonition.

## 定制字体
hugo 管理站点的方式是 *联合文件系统*.
简单地说, 站点的各项文件配置都是分层的, 放置在上层的文件将会覆盖下层.
目录层级如下所示.
```
<root>
<root>/themes/<theme-a>
...
```
因此, `layouts/baseof.html` 将会覆盖 `themes/book/layouts/baseof.html`, 其余目录和文件皆是同理.

我希望站点正文字体使用衬线体, 以此增强内容的出版物质感, 更有 "文章感".
book 主题提供了设置字体的 [定制文件](https://github.com/alex-shpak/hugo-book?tab=readme-ov-file#extra-customisation) `assets/_fonts.scss`, 我们修改它即可更换字体.

将下面的内容填入此文件中
```scss
/* assets/_fonts.scss */

@import url('https://fonts.googleapis.com/css2?family=Source+Serif+4:wght@400;600;700;900&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@100;200;300;400;500;600;700;800;900&display=swap');
@import url('https://cdn.jsdelivr.net/npm/cn-fontsource-source-han-serif-sc-vf@1.0.9/font.css');
@import url('https://cdnjs.cloudflare.com/ajax/libs/Iosevka/6.0.0/iosevka/iosevka.min.css');


:root {
  --paper-font-body: "Source Serif 4", "Source Han Serif SC", "Noto Serif SC", serif;
  --paper-font-ui: "Inter", system-ui, -apple-system, "Segoe UI", "Helvetica Neue", Arial;
  --paper-font-mono: "Iosevka Web", "Iosevka", "JetBrains Mono", ui-monospace, "SFMono-Regular", "Menlo", monospace;

  --normal-wght: 300;
  --mono-wght: 400;
  --strong-wght: 600;
}


html, body {
  font-family: var(--paper-font-body);
  font-weight: var(--normal-wght);
}

strong {
  font-weight: var(--strong-wght) !important;
}

h1, h2, h3, h4, h5, h6 {
  font-family: var(--paper-font-ui);
}

code, pre {
  font-family: var(--paper-font-mono);
  font-weight: var(--mono-wght);
}
```
这将设置正文字体为衬线体 (中文 Source Han Serif SC, 西文 Source Serif), 标题为无衬线体 (Inter), 代码块为等宽无衬线体 (Iosevka);
并将加粗 `strong` 字重改大来提高可见性.
以上 4 个字体都配置了 CDN.

## 添加文章修改时间
book 中同样也有修改时间的原生支持, 但是需要与 GitHub 仓库进行集成, 这是一个比较苛刻的条件, 我无法做到, 因此我将手动实现一个放置在左下角的文章修改时间.
如果你对 book 中提供的修改时间显示有兴趣, 可以去看 [站点配置](https://github.com/alex-shpak/hugo-book?tab=readme-ov-file#site-configuration) 中 `enableGitInfo` 与 `BookLastChangeLink` 两个字段.
只有这两者都被正确配置, 时间显示才会开启.

一般来说, 几乎每个主题都会预留 *注入点 (inject)*.
它们是主题中空的占位文件, 等待着被来自上层的文件覆盖.
它们已经被主题中的各项文件引用, 但因为是空的, 不会有任何效果, 当它们被覆盖后, 新文件的内容就会出现在站点中.
这是一种非侵入式的个性化手段.
book 主题中提供的注入点可以在 GitHub [自述文件](https://github.com/alex-shpak/hugo-book?tab=readme-ov-file#partials) 中找到.

我将利用 book 在**页面内容之后**的注入点 `layouts/partials/docs/inject/content-after.html` 来手动实现一个修改时间显示, 它会读取文档元数据 `date` 字段来格式化为相应的日期显示.

```html
<!-- layouts/partials/docs/inject/content-after.html -->
{{ $date := .Lastmod | default .Date }}

{{ if .IsPage  }}
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

## 数学支持
关于为 hugo 添加 MathJax 支持, 请看 [这篇文章](Hugo-with-Math.md).

## 主页面
访问网址时进入的页面为主页面, 默认情况下主页面是空的, 你可以在 `content` 目录中新建一个 `content/_index.md` 来定制你主页面的内容.
我希望在主页中呈现一个导航菜单, 按文章 tag 分类.
要做到这一点, 让 hugo 自行渲染是最方便的, 免于我们手动编写代码.

book 主题中自带了一个导航页, 但是隐藏得比较深.
这一部分页面编写在 book 仓库的 `layouts/_partials/docs/taxonomy.html` 中, 我们直接调用这一部分代码即可.
我将使用 hugo 提供的 *Shortcode* 机制, 它能让我们在 Markdown 中引入 HTML 或其他逻辑.

在 `layouts/shortcodes` 中新建 `book-taxonomy.html`, 如下
```html
<!-- layouts/shortcodes/book-taxonomy.html -->
{{ partial "docs/taxonomy" .Page }}
```
这样你就可以在 Markdown 中使用 `{{< book-taxonomy >}}` 来渲染一个按 tag 分类的导航页.

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
delimiters = { block = [['$$', '$$']], inline = [['\(', '\)']] }
```