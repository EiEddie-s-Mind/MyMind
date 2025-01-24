---
tags:
  - 折腾
  - 开发环境
datetime: 2024-09-20
---

# VSCode & CMake & vcpkg & MSVC 的 C/C++ 开发环境配置

首先应该确保电脑上有这些必需的软件:
- CMake
- Ninja
- vcpkg
- MSVC 套件

## MSVC 安装
可以使用 [*Visual Studio 安装工具*](https://visualstudio.microsoft.com/zh-hans/downloads/) 针对性地安装 MSVC 套件而不必安装全套 Visual Studio .

只需在下载的 Visual Studio Installer 中选择 **单个组件 → 编译器、生成工具和运行时 → MSVC vXXX - VS 2022 C++ x64/x86 生成工具** 选项进行安装. 建议安装最新版本.

MSVC 环境必须经过初始化才可以使用. 安装完成后会自动出现 *Developer Command Prompt for VS 20xx* (即 *开发人员命令提示符* ) 和 *Developer PowerShell for VS 20xx* (即 *开发人员 PowerShell* ), 这两个终端就是已经初始化的环境, 在这两个终端中可以直接调用编译器. 另外 Visual Studio 还提供了初始化脚本来初始化编译器环境.

## vcpkg 安装
访问 vcpkg 的 GitHub 仓库以查看安装说明.

将仓库克隆到本地后, 需要将可执行文件添加到 `PATH` 环境变量中, 并声明 `VCPKG_ROOT` 环境变量. 我个人的做法是为可执行文件创建符号链接, 就像 Linux 中创建链接到 `/usr/local/bin` 一样. 声明 `VCPKG_ROOT` 变量并将值定义为你克隆仓库目录的绝对地址, 这样 vcpkg 才在终端环境中可用.

## Ninja 安装
Ninja 是一个跨平台的构建系统, 我们使用它来作为 CMake 的生成器. 安装它的方式很简单, 在 GitHub 仓库下载最新版本后放到 `PATH` 环境变量中的文件夹即可.

## VS Code 配置
为了与 CMake 配合, 这些扩展是必须的:
- **C/C++**
- **CMake**
- **CMake Tools**

另外, 为了获得更完备的开发体验, 建议使用 **clangd** 替代 **C/C++** 作为代码静态分析和补全的后端. 但 **C/C++** 也得保留, 为了与 CMake 有关插件配合. 我们可以把 **C/C++** 的所有代码提示全部关掉, 防止与 **clangd** 冲突.

**clangd** 需要配置才能识别引入的第三方库, 否则就会报 `file not found` 错误. 可以读取通过 CMake 自动生成的 `compile_commands.json` 文件来配置第三方库信息. 然而 CMake 只能为 Ninja 和 Makefile 生成此文件[^1]. 因为我们想尽可能做到跨平台, 所以使用 Ninja  是更好的选择.

在项目的根目录下放置一个 `CMakePresets.json` 可以控制 VS Code 中 CMake 的配置行为, 各种命令行参数也可以在这里面定义. 下面是一个示例文件, 定义了四个可选的项目配置预设:
```json
{
  "version": 2,
  "configurePresets": [
    {
      "name": "vcpkg",
      // 隐藏此配置
      "hidden": true,
      "cacheVariables": {
	      // 引入 vcpkg 包管理
        "CMAKE_TOOLCHAIN_FILE": "$env{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
      }
    },
    {
      "name": "debug",
      "inherits": "vcpkg",
      "hidden": true,
      // 指定生成器为 Ninja
      "generator": "Ninja",
       // 输出文件到项目目录下的 build/debug 文件夹
      "binaryDir": "${sourceDir}/build/debug",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        // 生成 compile_commands.json 文件
        "CMAKE_EXPORT_COMPILE_COMMANDS": "True"
      }
    },
    {
      "name": "release",
      "inherits": "vcpkg",
      "hidden": true,
      "generator": "Ninja",
       // 输出文件到项目目录下的 build/release 文件夹
      "binaryDir": "${sourceDir}/build/release",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release"
      }
    },
    {
      "name": "windows-debug-x86_64-msvc",
      "inherits": "debug",
      "displayName": "Windows x86_64 MSVC (Debug)",
      "description": "MSVC with vcpkg for Windows x86_64 - Debug Configuration",
      "cacheVariables": {
	      // 指定使用 MSVC 编译套件
        "CMAKE_C_COMPILER": "cl",
        "CMAKE_CXX_COMPILER": "cl"
      }
    },
    {
      "name": "windows-release-x86_64-msvc",
      "inherits": "release",
      "displayName": "Windows x86_64 MSVC (Release)",
      "description": "MSVC with vcpkg for Windows x86_64 - Release Configuration",
      "cacheVariables": {
	      // 指定使用 MSVC 编译套件
        "CMAKE_C_COMPILER": "cl",
        "CMAKE_CXX_COMPILER": "cl"
      }
    },
    {
      "name": "windows-debug-x86_64-mingw",
      "inherits": "debug",
      "displayName": "Windows x86_64 MinGW (Debug)",
      "description": "MinGW with vcpkg for Windows x86_64 - Debug Configuration",
      "cacheVariables": {
	      // 指定使用 GUN gcc 编译套件, 来自 MinGW
        "CMAKE_C_COMPILER": "cc",
        "CMAKE_CXX_COMPILER": "c++"
      }
    },
    {
      "name": "windows-release-x86_64-mingw",
      "inherits": "release",
      "displayName": "Windows x86_64 MinGW (Release)",
      "description": "MinGW with vcpkg for Windows x86_64 - Release Configuration",
      "cacheVariables": {
	      // 指定使用 GUN gcc 编译套件, 来自 MinGW
        "CMAKE_C_COMPILER": "cc",
        "CMAKE_CXX_COMPILER": "c++"
      }
    }
  ]
}
```

**CMake Tools** 自带一个复制 `compile_commands.json` 到指定位置的功能. 如果这个指定的位置恰好是文件默认所处的位置, 就会出现错误, 这一点应当注意. 我们可以把生成在 `build/debug` 的文件复制到 `build` 文件夹, 以确保一致性. 在 `.vscode/settings.json` 中添加下面一句来启用这一项功能:
```json
"cmake.copyCompileCommands": "${workspaceFolder}/build/compile_commands.json"
```

然后配置 **clangd** 让它能够找到此文件. 在 `.vscode/settings.json` 下添加这样一句来向 **clangd** 指明文件位置:
```json
"clangd.arguments": ["--compile-commands-dir=build"]
```

现在这一套组合应该已经可用了.

## 构建过程
当你点击 *全部构建* 时发生了什么? 最终的二进制文件是怎么编译出来的?

我们在上面定义了一套比较复杂的调用关系, 具体就是:
```
cmake → ninja → cl (MSVC)
```

当你想要获得最终的编译成果时, 实际上会发生以下步骤:
1. 配置 Configure  
	这一步 `cmake` 会读取 `CMakePresets.json` 文件中的内容, 综合我们的要求解析 `CMakeLists.txt` 输出一个编译文件, 在使用 Ninja 作为生成器时输出的是 `build.ninja`, 在 `build` 文件夹中.

2. 构建 Build  
	  这一步 `cmake` 会调用指定的生成器 (`ninja`), 逐条按照编译文件执行指令; 生成器会负责调用指定的编译器按指令进行编译.

3. 编译与链接 Compile & Link  
	  生成器 `ninja` 会调用编译器与链接器, 先将源代码文件编译成中间文件 `.obj` / `.o` , 而后与外部库进行链接, 输出最终的二进制文件. 如果有动态链接库, 也会被复制过来.

另外, *配置* 时会产生 `compile_commands.json` 文件, 然后 **clangd** 才能读取进而提供静态分析和代码补全. 所以想用 **clangd** 的功能时, 必须得先 *配置* 一遍才行.

## 示例
我们来实际编译一个简单的 OpenCV 项目来验证上述设置都是否正确.

> [!Warning]
> 必须初始化 MSVC 环境后才能调用它的编译套件.
> 
> 可以在开发人员 *命令提示符中* 输入 `code <path>` 命令打开 VS Code 后进行操作.

### 安装 OpenCV
使用 vcpkg 来安装, 只需使用命令:
```bash
vcpkg install opencv
```

然后 vcpkg 就会自动安装所有依赖项, 并在本地编译.

因为我们是在 Windows 环境中, 所以库的三元组为 `x64-windows` , 这也是 Windows 上的默认值.

### 编写 `CMakeLists.txt`
项目根目录下应该存在一个 `CMakeLists.txt`  来指定构建选项. 下面是一个示例:

```cmake
# CMakeLists.txt

cmake_minimum_required(VERSION 3.10)

project("test-opencv")

# 搜索依赖的 OpenCV 库
find_package("OpenCV" CONFIG REQUIRED)

add_executable("test" "src/main.cpp")
target_link_libraries("test" PRIVATE ${OpenCV_LIBS})
# 不要用 vcpkg 给出的下面的设置, 会出现链接错误
#target_link_libraries("text" PRIVATE opencv_ml opencv_dnn opencv_core opencv_flann)
```

### 源代码
我们来写一个打印 OpenCV 版本的小程序来验证是否正常安装依赖:

```cpp
// src/main.cpp

#include <opencv2/opencv.hpp>
#include <cstdio>

int main() {
	std::printf("OpenCV version: " CV_VERSION "\n");
	return 0;
}
```

### 构建项目
先来检查一下项目结构:
```
.
├─ .vscode
│   └─ settings.json
├─ src
│   └─ main.cpp
├─ CMakeLists.txt
└─ CMakePresets.json
```

之后进行构建, 使用 `Windows x86_64 MSVC (Debug)` 预设, 应该能在 `build/debug`目录里找到 `text.exe` , 运行它会打印一行 OpenCV 的版本信息.

构建一遍以后再修改源代码, 应该可以享受到 **clangd** 的代码分析和补全了.


[^1]: https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html
