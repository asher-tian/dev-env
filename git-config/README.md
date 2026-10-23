# Git 配置指南

适用于 macOS、Linux、Windows（Git Bash）。所有项目可以放在同一个目录，例如 `~/code/`，不需要按平台分目录。

## 推荐配置顺序

1. [GitHub / Gitee SSH 连接](./github-ssh.md)：配置密钥，推送代码时无需反复输入账号密码。
2. [GitHub Verified 签名提交](./signed-commits.md)：让提交显示 `Verified`，可选。
3. [GitHub + Gitee 双平台同步](./github-gitee-sync.md)：同一份代码推送到两个远程仓库时使用。

## 统一提交身份

你选择使用真实邮箱，因此可以全局配置一次：

```bash
git config --global user.name "你的昵称"
git config --global user.email "你的真实邮箱"
```

请确认这个邮箱已经添加并验证到 GitHub 和 Gitee 账号。公开仓库的 Git 提交会公开作者邮箱；这是你选择的行为。

查看当前仓库实际使用的提交身份：

```bash
git config user.name
git config user.email
git var GIT_AUTHOR_IDENT
```

## 安全注意

- SSH 私钥保存在本机，绝不上传 GitHub、Gitee 或发给他人。
- 可以不给 SSH 私钥设置 passphrase，使用更方便；代价是任何拿到该私钥文件的人都可能使用它。passphrase 是可选项。
- 不要把密码、访问令牌、私钥或生产环境密钥提交到仓库。
- 本指南中的 SSH 登录认证与 commit 签名是两件事，详见对应教程。
