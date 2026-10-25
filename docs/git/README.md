# Git 配置指南

适用于 macOS 和 Windows。所有项目可以放在同一个目录，例如 `~/code/`，不需要按平台分目录。

## 快速配置

完成基础工具安装后，在仓库根目录运行对应脚本。

### macOS

```bash
bash scripts/macos/setup-git.sh
```

### Windows（PowerShell）

```powershell
.\scripts\windows\setup-git.ps1
```

脚本会询问 Git 提交昵称和邮箱，设置全局提交身份，生成 GitHub / Gitee 共用的 SSH 认证密钥，并配置 SSH 使用该密钥。签名提交是可选项。

脚本会显示公钥，但不会自动上传公钥。按提示将认证公钥添加到 GitHub 和 Gitee；如果启用了签名，再将签名公钥单独添加到 GitHub 的 **Signing Key**。

## 手动教程

1. [GitHub / Gitee SSH 连接](github-ssh.md)
2. [GitHub Verified 签名提交](signed-commits.md)：可选。
3. [GitHub + Gitee 双平台同步](github-gitee-sync.md)：需要同时推送两个平台时使用。

## 统一提交身份

你选择使用真实邮箱，因此可以全局配置一次：

```bash
git config --global user.name "你的昵称"
git config --global user.email "你的真实邮箱"
```

请确认这个邮箱已经添加并验证到 GitHub 和 Gitee 账号。公开仓库的 Git 提交会公开作者邮箱。

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
- SSH 登录认证与 commit 签名是两件事，详见对应教程。
- 多台开发机器建议各自生成独立密钥；设备丢失或退役时，可单独撤销该设备的公钥。
