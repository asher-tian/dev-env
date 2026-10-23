# GitHub Verified 签名提交（SSH）

签名提交可以让 GitHub 在提交记录中显示 **Verified**。这与 SSH 推送认证不同：认证密钥用于证明你可以访问仓库；签名密钥用于验证提交签名。

本教程使用 SSH 签名。建议每台开发机器使用自己的密钥。

## 1. 准备签名密钥

可以复用已有 SSH 密钥，但需要在 GitHub 中将公钥另外登记为 **Signing Key**。更清晰的做法是单独生成签名密钥：

```bash
ssh-keygen -t ed25519 -C "你的真实邮箱" -f ~/.ssh/id_ed25519_signing
```

询问 passphrase 时，可以直接按 Enter 不设置；passphrase 是可选的。无 passphrase 使用方便，但私钥文件泄露后的风险更高。

## 2. 在 GitHub 添加签名公钥

复制公钥：

```bash
cat ~/.ssh/id_ed25519_signing.pub
```

打开 [GitHub SSH and GPG keys](https://github.com/settings/keys)，选择 **New SSH key**，将 **Key type** 选为 **Signing Key**，粘贴公钥并保存。

注意：用于登录的 Authentication Key 不会因为已添加就自动成为 Signing Key；若复用同一把密钥，需要另外以 Signing Key 用途登记。

## 3. 配置 Git 自动签名

在该机器执行：

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519_signing.pub
git config --global commit.gpgsign true
```

确保提交邮箱与 GitHub 账号中已验证的邮箱一致。你选择使用真实邮箱时，可全局设置：

```bash
git config --global user.email "你的真实邮箱"
```

## 4. 验证

在任意测试仓库创建一次提交：

```bash
git commit --allow-empty -m "test: verify signed commits"
git log -1 --show-signature
```

推送到 GitHub 后，打开该提交详情，确认显示 **Verified**。如果没有显示，检查签名公钥是否登记为 Signing Key、邮箱是否已验证，以及本地签名配置是否生效。

## 多台开发机器

每台机器独立生成签名密钥，并将各自公钥添加到 GitHub 的 **Signing Key**。每台机器都执行第 3 步配置。不要共享或上传私钥。

本教程针对 GitHub 的 Verified 展示。Gitee 对签名提交的支持和界面展示需另行确认，不能假设 GitHub 的 Verified 标记会同步到 Gitee。
