---
tags:
  - 折腾
  - 编程
  - 开发环境
datetime: 2025-07-05
title: "ESP32: 环境配置与开发"
aliases: ["ESP32: 环境配置与开发"]
---

# ESP32: 环境配置与开发
*我必须承认, esp idf 是我配置过最困难的开发环境.*

本篇文章的开发环境选择是 **Visual Studio Code** 与 **esp idf**.
以 [**微雪电子 ESP32-S3-Nano** 开发板](https://www.waveshare.net/wiki/ESP32-S3-Nano) 为例; 这款开发板理论上与 **Arduino Nano esp32** 开发板完全兼容.
在 [这里](https://docs.arduino.cc/resources/pinouts/ABX00083-full-pinout.pdf) 可以找到 Arduino 开发板的引脚定义.

## esp idf 安装与配置
esp idf 有两种安装途径: 通过官方安装器; 或是通过 VSCode 插件安装.

> [!warning]
>  上述两种方式安装的 esp idf 互不兼容.

鉴于我们将在 VSCode 中进行开发, 所以最好选择第二种: 通过插件安装.

具体的安装过程可以在 [官方教程](https://docs.espressif.com/projects/vscode-esp-idf-extension/zh_CN/latest/installation.html) 找到.

## 安装 USB 设备驱动
安装 [Zadig](https://zadig.akeo.ie). 启动它, 选择 *Options > List All Devices*.
此时应该能在下拉菜单中找到两个 `USB JTAG/serial debug unit`, 分别以 `Interface 0` 与 `Interface 2` 区分. 下面分别设置这两个的驱动.

首先选择 `USB JTAG/serial debug unit (Interface 0)`, 将驱动替换为 `USB Serial (CDC)`.\
然后选择 `USB JTAG/serial debug unit (Interface 2)`, 将驱动替换为 `WinUSB (v6.x)`.

> [!Note]
> 如果你的驱动与上面所写的不一致 (`USB Serial (CDC)` 也显示为 `usbser`), 你这时应该点击 *Replace Driver*. 如果按钮为 *Install WCID Driver*, 你应当在下拉菜单中仔细寻找一番.

> [!Note]
> 对于 `Interface 2`, 驱动版本也要严格对应于 `v6.x`. 更高的版本可能导致问题.

全部完成后, 可以打开设备管理器, 查看下面两个字段:
*端口 (COM 和 LPT)*, 应该包含一个 *USB 串行设备 (COMx)*, *x* 表示数字不确定;
*通用串行总线设备*, 应该包含一个 *USB JTAG/serial debug unit*.

经过上面的配置, 能够得到一个串口和一个 JTAG. 其中串口用于通讯, JTAG 用于调试, 两者都可以用于烧录程序. 所以两者缺一不可.

> [!Note]
> 如果上面驱动设置过程中出现错误, 以至于更换驱动出错, 可以考虑重置所有驱动, 而后重新来过.
> 彻底重置这两个 Interface 的驱动按下面的步骤进行:
> 1. 打开设备管理器, 分别定位到这两个 Interface.\
> 	它们应该只会在 *端口 (COM 和 LPT)* 和 *通用串行总线设备* 这两个字段中.
> 2. 右键, *卸载设备*, 勾选上 *删除此设备的驱动程序软件*, 点击 *卸载*.
> 3. 拔掉开发板.
> 4. 重启计算机.
> 5. 插入开发板, 此时驱动应该已经被重置. 重新配置驱动.

## 调试
在进行下面的操作之前, 请检查驱动是否配置正确.

在 VSCode 中, 按 `Ctrl+Shift+P` 打开命令面板, 输入 `ESP-IDF: Add VS Code Configuration Folder`, 获取预设的运行与调试文件.

检查设置: 打开 `.vscode/settings.json`, 检查 `idf` 相关字段. 两个字段的值应该如下所示.
```json
"idf.openOcdConfigs": [
	"board/esp32s3-builtin.cfg"
],
"idf.customExtraVars": {
	"IDF_TARGET": "esp32s3"
},
```

上述都配置好后, 直接在调试菜单里点击 `Eclipse CDT GDB Adapter` 即可开始调试.

## 疑难杂症
1. *库头文件 (如 `stdio.h`) 无法被导入.*\
	打开 `.vscode/settings.json`, 找到 clangd 相关的字段 `clangd.path` `clangd.arguments`. 如果里面的绝对路径以小写的磁盘标识符开头, 如 `d:\\opt\\...`, 将其改为大写: `D:\\opt\\...`; 而后重启 VSCode (或重新加载窗口).
2. *C 库头文件可以被导入, 但是 C++ 库头文件无法导入.*\
	在 `.vscode/settings.json` 的 `clangd.arguments` 中找到标志 `--query-driver`, 添加上 C++ 的编译器.\
	如果你原来形如 `--query-driver=...\\xtensa-esp32s3-elf-gcc.exe`, 添加后应该类似 `--query-driver=...\\xtensa-esp32s3-elf-gcc.exe,...\\xtensa-esp32s3-elf-g++.exe`. 一般上面两个编译器在同一目录下.
3. *烧录时出现 `PermissionError(13, '连到系统上的设备没有发挥作用。', None, 31)` 报错.*\
	检查端口, 是否是串口烧录. 若都无误, 你应该将引脚 `B1`, 也就是 `GPIO0` 置为低电平, 重置开发板后再次烧录.
4. *运行 monitor 时出现 `waiting for download`.*\
	如果 `B1` 仍被置低, 将它归位为高电平. 只需取消 `B1` 与 `GND` 的短接即可.
5. *调试时出现 `LIBUSB_ERROR_NOT_FOUND`.*\
	检查驱动配置情况. 尤其着重检查 `Interface 2` 的 `WinUSB` 驱动版本是否为 `v6.x`. 若更高, 将其替换为此版本.
6. *我想使用硬件 JTAG 进行调试.*\
	可以, 但是我不知道具体怎么做. 我唯一可以给你的提示是:\
	此开发板的硬件 JTAG 接口在背面尾部的空焊盘上, 可以检查引脚定义表来获取具体信息.
