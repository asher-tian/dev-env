# Git Commit 签名（SSH / GPG）

Commit Signing 用于验证提交签名，与 SSH 仓库访问认证不同。认证密钥用于证明你可以访问仓库；签名密钥用于验证提交确实由对应私钥持有者签署。

本仓库支持两种签名方式。每个 Git 配置作用域（全局或单个仓库）在同一时刻只能选择一种签名格式。

## 1. SSH Signing

适用于支持 SSH Signing 的 Git 平台。

生成独立签名密钥：

```bash
ssh-keygen -t ed25519 -C "你的真实邮箱" -f ~/.ssh/id_ed25519_signing
```

复制公钥：

```bash
cat ~/.ssh/id_ed25519_signing.pub
```

在 GitHub 的 [SSH and GPG keys](https://github.com/settings/keys) 中选择 **New SSH key**，将 **Key type** 选为 **Signing Key**。Authentication Key 不能自动代替 Signing Key。

配置 Git：

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519_signing.pub
git config --global commit.gpgsign true
```

## 2. GPG Signing

适用于要求 OpenPGP 签名的 Git 平台。先安装 GnuPG 并生成密钥，确保本机存在可用于签名的私钥。

查看密钥并确定具有签名能力的主密钥 ID：

```bash
gpg --list-secret-keys --keyid-format LONG
```

导出公钥：

```bash
gpg --armor --export YOUR_KEY_ID
```

复制从 `-----BEGIN PGP PUBLIC KEY BLOCK-----` 到 `-----END PGP PUBLIC KEY BLOCK-----` 的全部内容。在 GitHub 的 [New GPG key](https://github.com/settings/gpg/new) 页面添加；内部 Git 平台按其要求登记公钥。

配置 Git：

```bash
git config --global gpg.format openpgp
git config --global gpg.program gpg
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```

Windows 上若 Git 无法通过 PATH 找到 GPG，可将 `gpg.program` 设置为 `gpg.exe` 的完整路径。

## 3. 验证签名

```bash
git commit --allow-empty -m "test: verify signed commits"
git log -1 --show-signature
```

推送后按平台的提交详情确认签名状态。平台必须支持所选签名格式，且对应公钥必须登记为 Signing Key 或 GPG Key。内部平台若明确要求 GPG，必须使用 GPG，不能用 SSH Signing 替代。

## 4. 按仓库选择不同签名方式

全局配置作为默认值，单个仓库可以覆盖：

```bash
# 当前仓库使用 GPG
git config --local gpg.format openpgp
git config --local user.signingkey YOUR_GPG_KEY_ID

# 另一个仓库使用 SSH
git config --local gpg.format ssh
git config --local user.signingkey ~/.ssh/id_ed25519_signing.pub
```

排查配置来源：

```bash
git config --show-origin --show-scope --get-regexp "gpg\\.|user.signingkey|commit.gpgsign"
```

## 5. 安全与多设备管理

- 只上传公钥；不要上传 SSH 私钥或 GPG 私钥。
- 不同设备建议使用独立密钥，设备丢失或退役时可以单独撤销。
- GPG 私钥应妥善备份；不要把私钥备份提交到仓库。
- SSH Authentication 与 Commit Signing 是不同用途，建议分别使用独立密钥。
