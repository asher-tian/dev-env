# 同一份代码同步到 GitHub 和 Gitee

同一份代码只需要一个本地 Git 仓库，配置两个远程地址即可。所有项目可以统一放在 `~/code/`，不需要按平台分目录。

## 1. 配置提交身份

你选择使用真实邮箱，可以全局配置一次：

```bash
git config --global user.name "你的昵称"
git config --global user.email "你的真实邮箱"
```

确保这个邮箱已添加并验证到 GitHub 和 Gitee。公开提交可能公开该邮箱。

## 2. 配置两个远程仓库

先在 GitHub 和 Gitee 分别创建仓库，然后进入本地项目目录。

如果 GitHub 已经是 `origin`：

```bash
git remote -v
git remote add gitee git@gitee.com:用户名/仓库名.git
```

此时 `origin` 指向 GitHub，`gitee` 指向 Gitee。建议确认 `origin` 地址正确：

```bash
git remote set-url origin git@github.com:用户名/仓库名.git
```

如果项目还没有远程地址：

```bash
git remote add github git@github.com:用户名/仓库名.git
git remote add gitee git@gitee.com:用户名/仓库名.git
```

## 3. 推送到两个平台

确认分支名（以下假设为 `main`）：

```bash
git branch --show-current
git push origin main
git push gitee main
```

如果远程名使用 `github` 而不是 `origin`，将第一条命令改成 `git push github main`。

常用时可以连续执行：

```bash
git push origin main && git push gitee main
```

第一条推送失败时，第二条不会执行。两次推送不是原子操作；如果其中一个失败，修复后重试即可。

## 4. 日常维护

- 开发、提交只做一次；每次提交后分别推送两个远程仓库。
- 两个平台都有人直接提交时，先明确哪个仓库是主仓库，并先拉取、合并变更，再推送，避免历史分叉。
- 两个平台的仓库应保持相同分支策略；首次同步前确认目标仓库没有需要保留的独立提交。
- 如果使用 SSH，按[SSH 教程](./github-ssh.md)分别添加 GitHub 和 Gitee 公钥。
- commit 签名不会因为推送到两个平台而自动改变；GitHub Verified 不代表 Gitee 一定会显示同样标记。
