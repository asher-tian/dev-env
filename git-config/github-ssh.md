# GitHub / Gitee SSH 连接

配置后，Git 通过 SSH 密钥认证，不必每次输入网站账号密码。GitHub 和 Gitee 都要添加公钥。

## 1. 检查是否已有密钥

```bash
ls -la ~/.ssh
```

如果已有可用密钥，可以直接使用；否则生成一把专门用于 Git 平台认证的密钥。

## 2. 生成密钥

建议每台开发机器各自生成独立密钥。以下以 Ed25519 为例：

```bash
ssh-keygen -t ed25519 -C "你的真实邮箱" -f ~/.ssh/id_ed25519_git
```

命令询问 passphrase 时，直接按 Enter 可以不设置密码；也可以自行设置。**不设置更方便，但如果私钥文件被他人取得，对方就可能使用它。**

## 3. 启动 SSH Agent 并加载密钥

macOS / Linux / Git Bash 通常可以执行：

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_git
```

如果密钥没有设置 passphrase，加载时通常不会要求输入密码。

## 4. 添加公钥到 GitHub 和 Gitee

显示并复制公钥内容：

```bash
cat ~/.ssh/id_ed25519_git.pub
```

- GitHub：打开 [SSH and GPG keys](https://github.com/settings/keys)，选择 **New SSH key**，用途选择 **Authentication Key**。
- Gitee：打开 [Gitee SSH 公钥设置](https://gitee.com/profile/sshkeys)，添加同一公钥。

只复制以 `.pub` 结尾的公钥文件内容。**不要复制或上传没有 `.pub` 后缀的私钥文件。**

## 5. 测试连接

```bash
ssh -T git@github.com
ssh -T git@gitee.com
```

首次连接时，确认主机指纹可信后再接受。成功后，平台通常会提示认证成功；这不代表获得了所有仓库的权限，仍需对目标仓库有访问权限。

## 6. 将仓库远程地址改为 SSH

进入项目目录，先查看现有地址：

```bash
git remote -v
```

GitHub 仓库：

```bash
git remote set-url origin git@github.com:用户名/仓库名.git
```

Gitee 仓库：

```bash
git remote set-url origin git@gitee.com:用户名/仓库名.git
```

将示例替换为自己的地址。如果同一项目要同时推送到两个平台，请参考[双平台同步](./github-gitee-sync.md)，不要把两个地址都设为同一个 `origin`。

## 多台开发机器

每台机器建议独立生成密钥，并将对应公钥添加到平台。设备丢失或退役时，可以单独撤销该设备的公钥。不要把私钥复制到所有机器或提交到仓库。
