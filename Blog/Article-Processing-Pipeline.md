---
tags:
  - 折腾
date: 2026-01-07
title: 文章处理管线
aliases: [文章处理管线]
---

# 文章处理管线
这篇文章将介绍结合本地 Obsidian 知识库与远程站点的文章处理体系, 聚焦于在本地与 hugo 搭建的静态网站中都实现良好的显示效果, 并构建一套相对自动化的文章发布管线.

我们构建的文章处理流程如下所示:
1. 本地使用 Obsidian 编写与管理.
2. 使用 pandoc 处理文档, 使其符合 hugo 的文档规范.
3. 使用 hugo 打包为静态站点.
4. 发布到托管服务.

因为 Windows 系统对于文件名过于苛刻的限制, 并且我们需要使用命令行工具进行自动化, 将在 Linux 环境下进行处理.
为了照顾本地知识库, 它明显在 Windows 下更方便, 可以将处理管线布置在 WSL 中, 它与 Windows 配合得非常好.
关于 hugo 搭建站点的内容可以查看 [这篇文章](Static-Site-with-Hugo.md).

## 格式化文档
首先要做的就是保证文章格式能够被 pandoc 正确处理, 且被 hugo 正确识别, 因此一方面要保证元数据的正确, 另一方面要确保正文中没有不被 Obsidian, pandoc 和 hugo 支持的 Markdown 语法.

hugo 依赖于 `title` 而非文件名显示文章标题, 使用 `date` 标记文章修改时间, 并且会读取 `tags` 来分类文章.
为了避免流程出错, 与减轻心智负担, 可以在 Obsidian 中安装 [Linter](https://github.com/platers/obsidian-linter) 插件, 它可以自动格式化文档, 并重排与补全元数据.
将 Linter 的 [标题别名](https://platers.github.io/obsidian-linter/settings/yaml-rules/#yaml-title-alias) 部分设置打开, 便可以自动从第一个 `#` 标签处获取文章标题, 并填写到元数据区, 另外还会将标题名作为别名写入.
如果以前在使用 `datetime` 字段储存文档修改或编写日期, **强烈建议改为 `date` 字段**, 因为这一键名在 Obsidian 与 hugo 两端都受到良好的支持.

> [!warning]
> 建议将 Linter 的 *确保中日韩文与英文数字之间有一个空格* 选项中的引号 `"` `'` 删除, 否则中文引号之后也会加入一个空格, 有时会破坏排版.

hugo 的 book 或其他主题提供了一些元数据字段来控制其行为, 例如 `bookToC` 将会控制是否默认展开该文章的目录. 关于 book 的控制字段可以查看其 [文档](https://github.com/alex-shpak/hugo-book?tab=readme-ov-file#page-configuration).

Obsidian 中有些非标准的拓展 Markdown 语法, 例如 *Wiki 链接* 等, 都建议关闭, 因为难以被 hugo 与其他平台的标准化 Markdown 渲染器支持.

目前已经识别到一些 pandoc 处理错误的地方, 例如其**列表内的行间代码块支持较差**, 此时需要**列表内使用四空格缩进, 并注意添加一个空行**, 就像 [这篇文章](Repo-Struct.md) 末尾处做得那样.

## 语法差异处理
hugo 中有些文档元素设计时就有意使用了特殊的语法, 一方面是为了适应网站查看的需要, 另一方面是为了便于处理器进行修饰.
下面将介绍这些差异, 并给出其解决方案.

### 图片资源
hugo 对链接的要求格外与众不同.
对于图片, 若在文中引用图像文件, 普通的相对路径并不可用, 因为 hugo 会重新组织文档路径, 并分离静态元素, 如图片与内容.
它要求我们将图像文件等放置于 `static` 文件夹, 并在文中使用绝对路径来引用.
例如, 原本有如下布局
```
.
├─ a.md
└─ figs
    └─ a
       └─ img.png
```
此时我们会在文中用相对路径引用图片 `![fig (1)](figs/a/img.png)`.
但是在 hugo 站点中, 应当将 `figs` 转移到 `static` 中,
```
static
 └─ figs
     └─ a
        └─ img.png
```
在文中使用绝对路径引用 `![fig (1)](/figs/a/img.png)`.
注意前导 `/` 的不同.
我们将稍后编写一个 pandoc 过滤器来更新图片路径.

### 本地文件链接
更大的区别表现在对文件的链接, 即使用相对路径的本地文件链接.
如果要在此时插入一个跳转到另一篇文章的链接, 一般我们会这样做 `[to another](path/to/another.md)`, 但是 hugo 要求使用 [*Relref 短链接*](https://gohugo.io/shortcodes/relref/), 即改为 `[to another]({{% relref "path/to/another.md" %}})`

还有一些更特殊的, 即指向本地可达, 但不准备上载到网站, 导致在网页上不可达的资源的链接.
当 hugo 遇到这种链接, 将直接报错.
一种方案是使用 Markdown 提供的 *链接标签* 功能, 例如 `[context](path "tag")` 中的 `tag` 便是一个标签, 将鼠标放到链接上等待便会出现.
若一个链接被特殊的标签标记, 将在 pandoc 处理时退化为普通文字 `context`, 去除其链接, 以此避免发布时出现问题, 同时保证行文正常.
以标签为 `local` 举例, `[something in here...](path "local")` 经过处理后将变为 `something in here...`.

下面是处理上述**图片**, **链接**与**标记链接**的 pandoc 过滤器
```lua
-- link_modifier.lua
-- 链接处理器
-- 图片链接: 改为前导 /
-- 文件链接:
--   - 本地可达文件改为 hugo relref 格式
--   - 将标记过的链接改为文字

local utils = require("pandoc.utils")
local TAG = "local"


-- 判断是否外部 URL / scheme
local function is_external_url(s)
  if not s or s == "" then return false end
  return s:match("^//") or s:match("^[a-zA-Z][%w+.-]*:")
end


-- 简单规范路径
-- - 去掉开头的 ./
-- - 合并重复的 / , 但保留前导 ../
local function normalize_path(p)
  if not p then return p end
  -- 去掉前导 ./ , 但保留 ../
  p = p:gsub("^%./+", "")
  -- 合并中间多重 // 为 /
  p = p:gsub("([^:])//+", "%1/")
  return p
end


-- 将显示文本转为安全的 markdown 链接文本
-- - 转义 ] 及反斜杠
-- - 压平换行
local function escape_bracket_text(s)
  if not s then return "" end
  -- stringify
  -- 把 inlines 转为纯文本
  local t = utils.stringify(s)
  -- 压平换行, 合并多空白
  t = t:gsub("\r\n", " "):gsub("\n", " "):gsub("%s+", " ")
  -- 转义反斜杠和右方括号
  -- 放在 [ ... ] 中
  t = t:gsub("\\", "\\\\"):gsub("%]", "\\]")
  return t
end


-- 调整非外部, 非以 / 或 /static/ 开头的路径
function Image(img)
  local src = img.src
  if not src or src == "" then return nil end
  if is_external_url(src) then return nil end
  if src:match("^/static/") or src:match("^/") then return nil end
  local n = normalize_path(src)
  -- 加前导 /
  img.src = "/" .. n
  return img
end


function Link(el)
  local target = el.target or ""
  if not target or target == "" then return nil end

  if is_external_url(target) then
    return nil
  end

  -- 如果是 fragment-only (#anchor)
  -- 不处理
  if target:match("^#") then
    return nil
  end

  -- 如果 link title 标记为 TAG
  -- 去掉链接, 仅保留文字
  if el.title and el.title == TAG then
    return el.content
  end

  -- 将本地 .md 链接改为 relref
  -- 分离 path 与 anchor
  local path, anchor = target:match("^([^#]*)#?(.*)$")
  if not path then path = target end

  if path:lower():match("%.md$") then
    local npath = normalize_path(path)
    if anchor and anchor ~= "" then
      npath = npath .. "#" .. anchor
    end

    -- 生成安全的显示文本
    local text = escape_bracket_text(el.content)
    local md = "[" .. text .. "]({{% relref \"" .. npath .. "\" %}})"
    return pandoc.RawInline("markdown", md)
  end

  return nil
end
```

### HTML 标记
Markdown 中可以插入一些 HTML 代码, 在一般的编辑器中都能正常显示, 但并不推荐这样做.
我将克制地只使用其注释语法, 来提醒自己注意某些事情或编写待办事项.
在交由 hugo 打包前, 必须将这些 HTML 标记除去.
一个简单的 pandoc 过滤器如下
```lua
-- remove_html.lua

function RawBlock(el)
  if el.format == "html" then
    return {}
  else
    return nil
  end
end


function RawInline(el)
  if el.format == "html" then
    return {}
  else
    return nil
  end
end
```

### 特殊标记
与 [这篇文章](Hugo-with-Math.md) 中遭遇的问题一致, 如果在代码块 `...` 中包含短代码, 如 `{{< ... >}}`, hugo 将先处理短代码而忽略代码块的转义作用, 因此其内容不能被正常渲染显示.
为了解决这一问题, 简单修改一下 [那篇文章](Hugo-with-Math.md) 中提供的过滤器:
```lua
-- delimiter.lua

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
  -- {{< -> {{</*
  s = s:gsub("{{<", "{{</*")
  -- >}} -> */>}}
  s = s:gsub(">}}", "*/>}}")
  -- {{% -> {{%/*
  s = s:gsub("{{%%", "{{%%/*")
  -- %}} -> */%}}
  s = s:gsub("%%}}", "*/%%}}")
  el.text = s
  return el
end


function CodeBlock(el)
  local s = el.text
  -- {{< -> {{</*
  s = s:gsub("{{<", "{{</*")
  -- >}} -> */>}}
  s = s:gsub(">}}", "*/>}}")
  -- {{% -> {{%/*
  s = s:gsub("{{%%", "{{%%/*")
  -- %}} -> */%}}
  s = s:gsub("%%}}", "*/%%}}")
  el.text = s
  return el
end
```
它将 `{{<` `{{%` 改为 `{{</*` `{{%/*`, `>}}` `%}}` 改为 `*/>}}` `*/%}}`, 这是 hugo 官方给出的转义方法.

## 自动化
我们期望的自动化流程包括:
1. 从源目录 `src` 中将文档复制到目标目录 `dst` 中; 将图片文件夹 `src/figs` 复制到 `static` 中.
2. 使用 pandoc 处理每个文档.
3. 构建与打包.
4. 便捷地推送到托管平台.

我将编写一个 `Makefile` 来完成上述工作:
```Makefile
SHELL := /bin/bash
root := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

src := <your source dir>
dst := $(root)/content/docs
static := $(root)/static
pandoc_config := $(root)/tools/pandoc.yaml

# 找出 src 下的所有文件
# 但排除 src/figs 下的内容
docs := $(shell find $(src) -type f ! -path '$(src)/figs/*')
docs := $(patsubst $(src)/%,$(dst)/%,$(docs))

figs_src := $(shell [ -d $(src)/figs ] && find $(src)/figs -type f || true)
figs_dst := $(patsubst $(src)/%,$(static)/%,$(figs_src))

.PHONY: all build publish clean
all: $(docs) $(figs_dst)

build: all
        @hugo

publish:
        cd public && \
        git add -A && \
        git diff --cached --quiet || \
        git commit -m "update" && \
        git push

clean:
        -rm -rf $(dst)/*
        -rm -rf $(static)/figs


$(dst)/%.md: $(src)/%.md $(pandoc_config)
        @mkdir -p $(dir $@)
        pandoc $< --defaults $(pandoc_config) -o $@

$(dst)/%: $(src)/%
        @mkdir -p $(dir $@)
        cp -u $< $@

$(static)/%: $(src)/%
        @mkdir -p $(dir $@)
        cp -u $< $@

```
将 `src` 改为对应的源文档目录; 将本文提到的 3 个 pandoc 过滤器放置于 `tools/pandoc-filter` 中, 并编写如下 pandoc 配置文件
```yaml
from: markdown
to: markdown
filters:
  - tools/pandoc-filter/delimiter.lua
  - tools/pandoc-filter/remove-html.lua
  - tools/pandoc-filter/link_modifier.lua
standalone: true
wrap: preserve
```
即可使用.

`make` 或 `make all` 将用于布置文档与图像文件; `make build` 用于打包网站到 `public` 目录; `make publish` 将打包好的 `public` 目录推送到 GitHub Page 服务.