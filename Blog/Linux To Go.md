---
imageNameKey: linux_to_go
tags:
  - 折腾
  - linux
  - undone
datetime: 2023-09-12
title: 在移动介质中安装操作系统
aliases: [在移动介质中安装操作系统]
---

# 在移动介质中安装操作系统

> 所需工具:
> - 安装了任意 linux 发行版的电脑
>   - 此处使用安装了 debian 的 VMware 虚拟机
> - 系统安装光盘文件 (`.iso` 文件)
>   - 我选择的发行版是 debian
> - 容量足够的移动介质 (如 U 盘)

## 1. 检查移动介质 (如 U 盘) 的分区表类型

我们计划使用更现代的 `UEFI` 引导操作系统启动,
为了具有更好的兼容性, 移动介质的分区表类型应为 `GPT`.

因此第一步是将 `MBR` 类型的移动介质转换为 `GPT` 分区表类型.
假如你的介质已为 `GPT`, 可以跳过此章.

### 1.1. 检查分区表类型

使用 `fdisk` 命令检查介质:

```
# fdisk -l
Disk /dev/sdb: 15.24 GiB, 16358834176 bytes, 31950848 sectors
Disk model: SD/MMC
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00109879
```
上面显示了在我的机器上返回的信息, 其中:
- 目标设备: sd 卡 被识别为 `/dev/sdb`
- sd 卡已预先被我格式化, 因此没有分区
- `Disklabel type` 显示为 `dos`, 这意味着 sd 卡为 `MBR` 类型

### 1.2. 更改分区表类型

使用 `parted` 命令交互式地更改分区表类型:

```
# parted /dev/sdb
GNU Parted 3.5
Using /dev/sdb
Welcome to GNU Parted! Type 'help' to view a list of commands.

(parted) mklabel gpt
Yes/No? Yes

(parted) print
Model: Generic- SD/MMC (scsi)
Disk /dev/sdb: 16.4GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start  End  Size  File system  Name  Flags

(parted) quit
```

- 键入命令 `parted /dev/sdb`, 其中应输入你自己的 u 盘设备
- 在交互式界面里输入 `mklabel gpt`, 更改分区表类型
  - 此时会给出警告, 将会抹去盘上所有数据. 输入 `Yes` 以继续
- 输入 `print` 查看此时分区表情况, 可以看到 `Partition Table` 已经变为 `gpt`
- 输入 `quit` 退出

## 2. 预先手动分区

在操作系统安装时分区繁琐且麻烦, 因此此时先分好区.

我们计划分出五个区:
- `vfat`, 用于 `UEFI` 引导, 200M 左右
- `ext4`, 挂载到 `/`, 根文件系统
- `ext4`, 挂载到 `/home`
- `swap`, 不期望使用此分区, 因为频繁读写对 U 盘损害较大
- `vfat`, 此分区使 U 盘插入 `Windows` 时仍被识别为 U 盘, 可用于方便地在 `linux` 与 `Windows` 间传递文件

### 2.1. 开始分区

使用 `gdisk` 交互式命令行分区:

```
# gdisk /dev/sdb
GPT fdisk (gdisk) version 1.0.9

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: damaged

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************

Command (? for help): n
Partition number (1-128, default 1):
First sector (34-31950814, default = 2048) or {+-}size{KMGTP}:
Last sector (2048-31950814, default = 31948799) or {+-}size{KMGTP}: +200M
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): EF00
Changed type of partition to 'EFI system partition'

Command (? for help): n
Partition number (2-128, default 2):
First sector (34-31950814, default = 411648) or {+-}size{KMGTP}:
Last sector (411648-31950814, default = 31948799) or {+-}size{KMGTP}: +8G
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 8300
Changed type of partition to 'Linux filesystem'

Command (? for help): n
Partition number (3-128, default 3):
First sector (34-31950814, default = 17188864) or {+-}size{KMGTP}:
Last sector (17188864-31950814, default = 31948799) or {+-}size{KMGTP}: +1G
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 8200
Changed type of partition to 'Linux swap'

Command (? for help): n
Partition number (4-128, default 4):
First sector (34-31950814, default = 19286016) or {+-}size{KMGTP}:
Last sector (19286016-31950814, default = 31948799) or {+-}size{KMGTP}: +2G
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 8300
Changed type of partition to 'Linux filesystem'

Command (? for help): n
Partition number (5-128, default 5):
First sector (34-31950814, default = 23480320) or {+-}size{KMGTP}:
Last sector (23480320-31950814, default = 31948799) or {+-}size{KMGTP}: +2G
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 0700
Changed type of partition to 'Microsoft basic data'

Command (? for help): p
Disk /dev/sdb: 31950848 sectors, 15.2 GiB
Model: SD/MMC
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 29B98EB7-2B1C-4CD5-B5D0-D49DCEFAA7A5
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 31950814
Partitions will be aligned on 2048-sector boundaries
Total free space is 4278205 sectors (2.0 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048          411647   200.0 MiB   EF00  EFI system partition
   2          411648        17188863   8.0 GiB     8300  Linux filesystem
   3        17188864        19286015   1024.0 MiB  8200  Linux swap
   4        19286016        23480319   2.0 GiB     8300  Linux filesystem
   5        23480320        27674623   2.0 GiB     0700  Microsoft basic data

Command (? for help): w
Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sdb.
Warning: The kernel is still using the old partition table.
The new table will be used at the next reboot or after you
run partprobe(8) or kpartx(8)
The operation has completed successfully.
```

- 键入命令 `gdisk /dev/sdb`, 选择自己的设备
- 划分 `EFI` 分区, 依次输入以下命令
  - `n`, 创建新分区
  - `<Enter>`, 选择默认: 1
  - `<Enter>`, 选择默认配置
  - `+200M`, 为分区划出 200M 空间
  - `EF00`, 设置为 `EFI system partition` 类型
- 划分根文件系统分区
  - `n`
  - `<Enter>`, 选择默认: 2
  - `<Enter>`
  - `+8G`, 划出 8GiB 空间
  - `8300`, 设置为 `Linux filesystem` 类型
- 划分 `swap` 分区
  - `n`
  - `<Enter>`, 选择默认: 3
  - `<Enter>`
  - `+1G`, 划出 1GiB 空间
  - `8200`, 设置为 `Linux swap` 类型
- 划分挂载在 `/home` 处的分区
  - `n`
  - `<Enter>`, 选择默认: 4
  - `<Enter>`
  - `+2G`, 划出 2GiB 空间
  - `8300`
- 划分被 `Windows` 识别的分区
  - `n`
  - `<Enter>`, 选择默认: 5
  - `<Enter>`
  - `+2G`, 划出 2GiB 空间
  - `0700`, 设置为 `Microsoft basic data` 类型
- 分区完毕, 键入 `p` 打印划好的分区
- 若一切正常, 键入 `wq` 保存并退出

### 2.2. 格式化分区

预先格式化 `EFI` 分区:

```
# mkfs.vfat /dev/sdb1
```

可选: 格式化为 `Windows` 准备的分区:

```
# mkfs.vfat /dev/sdb5
```

## 3. 开始安装

## 4. 重建引导
