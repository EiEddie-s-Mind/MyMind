---
tags:
  - git
datetime: 2025-01-25
---

# `git` 子模块
`git` *子模块 (submodule)* 是挂于某 `git` 仓库下的子仓库. 当父仓库想使用第三方或者是与主业务分离的模块时, 可以通过将其注册为子模块来增加灵活性.

## 添加子模块
通过在父仓库使用
```
git submodule add <url> <path>
```
可以在 `<path>` 地址处添加一个子模块.

其中, `url` 可以为远程仓库地址, 也可以是本地仓库地址. 例如, 要把下面的 `new_repo` 仓库添加为 `repo` 的子模块, 可以使用命令: \
`git submodule add ./3rd/new_repo 3rd/new_repo` \
其中 `./3rd/new_repo` 即为本地仓库的 `url`. 需要注意的是本地 `url` 前面的 `./` 或 `../` 是必须的, `<path>` 也不能省略.

```
repo
├─ .git
└─ 3rd
    └─ new_repo
        └─ .git
```

另外一个远程仓库的例子. 若想把 `github.com/user/new_repo.git` 仓库添加为 `repo` 的子模块, 并要求 `new_repo` 放置在 `3rd` 文件夹内, 可以使用命令: \
`git submodule add github.com/user/new_repo 3rd` \
如果不指定后面的路径 `3rd`, 则会直接把 `new_repo` 克隆到父仓库目录下.

添加子模块后会在父目录下新建一个 `.gitmodule` 文件, 里面储存了所有子模块的信息.

## 修改子模块
可以对子模块内的文件进行修改.

前面提到子模块同样是一个完备的 `git` 仓库, 在子模块内进行的修改会同时反映在子模块本身与父仓库上. 对于子模块, 就是普通的 `git` 修改; 但是对于父仓库, 提示的是子模块整体发生了修改, 如下在父仓库进行的 `git status` 结果:
```
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   3rd/new_repo
```

因此一次修改需要提交两遍. 一遍是子模块内的提交, 就像普通的提交一样. 第二遍是在父仓库内, 将子模块作为整体暂存并提交.

## 删除子模块
要删除一个子模块, 遵循以下三步走原则:

1. *卸载 (deinit)* 子模块 \
	使用 `git submodule deinit <path>` 卸载子模块.
	如果子模块包含修改, 需要加上 `--force` (`-f`) 来强制卸载.
	卸载后目录里的文件仍然还会被保留.
2. 删除子模块目录 \
	使用 `git rm <path>` 来删除子模块所在的目录.
3. 提交修改 \
	最后在父仓库提交上述修改 (在父仓库看来删除子模块同样是一个修改).
