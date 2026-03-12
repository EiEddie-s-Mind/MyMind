---
tags:
  - linux
  - 折腾
date: 2026-03-12
lastmod: 2026-03-12
title: 将应用打包为单个文件
aliases: [将应用打包为单个文件]
---

# 将应用打包为单个文件
为什么要将 Linux 的程序打包为单个文件?
众所周知, 程序可能有数个甚至几十上百个依赖库, 或者叫*动态链接库*.
这一设计是为了减小程序体积, 因为可以多个程序共用同一套功能相同的代码.
但在一些时候, 它帮得倒忙远比其优点多.
具体地说, 当你的程序:
- 依赖数量庞大的动态链接库;
- 部分依赖安装起来非常麻烦, 或只能从半公开渠道获取 (例如需要注册后下载);
- 无法静态编译, 或部分库未提供静态版本;
- 需要在极短的时间内完成部署.

那么将其打包为单个文件可以解决你的烦恼.

当然, 这一方法并非没有缺点.
我们都很清楚, 把所有依赖都打包进来会导致分发文件体积膨胀严重, 甚至文件大小翻百倍都是常事.
在我的测试中, 打包后的应用大小在 120MB 左右.
如果你能接受这一点, 那么我确信它很适合你.

我们使用的文件格式被称为 [**AppImage**](https://appimage.org/), 对于几乎所有发行版, 它都是开箱即用的.
我们将先介绍手动打包的方式, 并以此认识包的格式;
随后给出更简单的打包方法.

## 手动打包
下面的内容基于官方给出的 [手动打包流程](https://docs.appimage.org/packaging-guide/manual.html).

要手动打包, 你需要一个以下结构的目录:
```
MyApp.AppDir
├── AppRun
├── myapp.desktop
├── myapp.png
└── usr
     ├── bin
     │   └── myapp
     └── lib
         └── lib*.so
```
上面给出的是最小结构, 也就是说你不能再省略内容了.
目录名 `*.AppDir` 是惯例;
`AppRun` 将作为被执行的程序, 它可以是可执行文件, 或是一个脚本, 关于它我们会在后文详细讲述;
`myapp.desktop` 是清单文件, 文件名基本是任意的, 但根目录必须存在且只存在一个 `.desktop` 文件;
`myapp.png` 是程序图标, 遗憾的是它不能省略.
`usr` 目录就像 LFS 描述的一样, `bin` 内存放可执行文件, `lib` 内存放库文件.
你要执行的应用文件应该就是 `myapp`.

`*.desktop` 的最小内容应该如下所示:
```ini
[Desktop Entry]
Name=MyApp
Exec=myapp
Icon=myapp
Type=Application
Categories=Utility;
```
`Name` 写它的名字;
`Exec` 为可执行文件名, 即 `bin` 存放的那个, 你也可以写绝对路径 `/bin/myapp`;
`Icon` 为图标文件名, 不带拓展名, 它不可省略;
`Type` 基本上不需要变化.
`Categories` 必须为 [已注册的类别](https://specifications.freedesktop.org/menu/latest/category-registry.html) 之一, 摘录如下:
- `Development`: 用于开发的软件应用
- `Utility`: 小型实用应用程序
- `AudioVideo`: 处理多媒体文件
- `Audio`: 用于音频文件
- `Video`: 用于视频文件
- `Education`: 教育软件
- `HealthFitness`: 健身软件
- `Game`: 游戏
- `Graphics`: 用于查看, 创建或处理图形
- `Network`: 网络应用程序, 例如网页浏览器
- `Office`: 办公软件
- `Science`: 科学软件
- `Settings`: 设置
-  `System`: 系统工具, 例如日志查看器或网络监视器

`Categories` 是一个字符串列表, 每个元素用分号 `;` 分隔, 并且**列表必须以分号结尾**.

接下来需要将可执行文件 `myapp` 依赖的所有动态链接库复制到 `usr/lib` 中.
可以使用下面的命令
```shell
ldd usr/bin/myapp | awk '{print $3}' | grep "^/" | xargs -I{} cp {} usr/lib
```
注意把程序名改为真实名字; 在 `*.AppDir` 目录中执行.

注意, 在上面复制的链接库的基础上, **必须删去系统运行时**, 例如 glibc 等.
官方警告说 [不要依赖系统提供的资源](https://docs.appimage.org/introduction/concepts.html#do-not-depend-on-system-provided-resources), 并给出了一个 [排除列表](https://github.com/AppImage/pkg2appimage/blob/master/excludelist).
对此, 若目标设备无图形界面, 且程序依赖处理图形的代码 (如 OpenGL; 但程序可能并不包含显示图像的功能), 将上面的库全部排除仍可能会导致运行时错误.
我建议只去除 C/C++, 以及 Linux 运行时环境, 即下面这些
```
ld-linux.so.2
ld-linux-x86-64.so.2
libanl.so.1
libBrokenLocale.so.1
libcidn.so.1
libc.so.6
libdl.so.2
libm.so.6
libmvec.so.1
libnss_compat.so.2
libnss_db.so.2
libnss_dns.so.2
libnss_files.so.2
libnss_hesiod.so.2
libnss_nisplus.so.2
libnss_nis.so.2
libpthread.so.0
libresolv.so.2
librt.so.1
libthread_db.so.1
libutil.so.1
libstdc++.so.6
```

为了使程序能够读取到动态链接库, 需要修改 `LD_LIBRARY_PATH` 环境变量.
这就是为什么需要 `AppRun`, 因为它可以编写为一个脚本:
```bash
#!/bin/bash
HERE="$(dirname "$(readlink -f "$0")")"
export LD_LIBRARY_PATH="$HERE/usr/lib:$LD_LIBRARY_PATH"
exec "$HERE/usr/bin/myapp" "$@"
```
在程序启动前将 `usr/lib` 写入 `LD_LIBRARY_PATH`.
别忘了为 `AppRun` 添加执行权限: `chmod a+x AppRun`.

全部准备好后, 使用 [appimagetool](https://github.com/AppImage/appimagetool) 打包:
```
appimagetool-x86_64.AppImage MyApp.AppDir
```
即可获得单个可执行文件 `MyApp-x86_64.AppImage`.

必须指出, 这种方法对 glibc 版本不匹配的系统不能适用, 比如目标系统比打包系统的 glibc 版本更低, 这就是官方建议的 [**基于旧系统构建, 在新系统上运行**](https://docs.appimage.org/introduction/concepts.html#build-on-old-systems-run-on-newer-systems).

## 使用工具打包
当然也有更简单的打包方式, 例如实用程序 [linuxdeploy](https://github.com/linuxdeploy/linuxdeploy).

> [!warning]
> *linuxdeploy* 在 GitHub 有两个储存库同名, 分别为 linuxdeploy/linuxdeploy 与 meefik/linuxdeploy, 我们需要的是前者.

要使用它, 需要准备好:
- 可执行文件 `myapp`
- `*.desktop` 文件 `myapp.desktop`
- 一个图标文件 `icon.png`
- 一个空目录, 用于存放中间产物 `MyApp.AppDir`

使用命令
```shell
linuxdeploy \
  --appdir MyApp.AppDir \
  --executable myapp \
  --desktop-file myapp.desktop \
  --icon-file icon.png \
  --output appimage
```
即可完成打包.

需要注意的是, 打包过程中会删去*排除列表*中的全部动态库, 因此不保证在无头系统中能正常使用, 但在有图形界面的系统上一般都没有问题.