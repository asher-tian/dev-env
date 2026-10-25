#!/usr/bin/env bash
set -euo pipefail

if ! command -v git >/dev/null 2>&1; then
  echo "未检测到 Git。请先运行 scripts/macos/setup.sh"
  exit 1
fi
if ! command -v ssh-keygen >/dev/null 2>&1; then
  echo "未检测到 ssh-keygen，请检查系统 OpenSSH 安装。"
  exit 1
fi

read -r -p "Git 提交昵称: " git_name
read -r -p "Git 提交邮箱（已添加并验证到 GitHub/Gitee）: " git_email
if [[ -z "$git_name" || -z "$git_email" ]]; then
  echo "昵称和邮箱不能为空。"
  exit 1
fi

git config --global user.name "$git_name"
git config --global user.email "$git_email"
echo "已设置全局 Git 提交身份。"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
auth_key="$HOME/.ssh/id_ed25519_git"

if [[ ! -f "$auth_key" ]]; then
  echo
  echo "正在生成 GitHub/Gitee SSH 认证密钥。"
  echo "按提示输入 passphrase；按 Enter 两次可不设置（更方便，但私钥泄露风险更高）。"
  ssh-keygen -t ed25519 -C "$git_email" -f "$auth_key"
else
  echo "已存在 SSH 认证密钥，跳过生成：$auth_key"
fi

ssh_config="$HOME/.ssh/config"
touch "$ssh_config"
if ! grep -qF "# dev-env Git hosting keys" "$ssh_config"; then
  cat >> "$ssh_config" <<'EOF'

# dev-env Git hosting keys
Host github.com gitee.com
  IdentityFile ~/.ssh/id_ed25519_git
  IdentitiesOnly yes
EOF
  chmod 600 "$ssh_config"
  echo "已配置 SSH 使用 id_ed25519_git。"
else
  echo "SSH config 中已存在 dev-env 配置标记，未重复追加。"
fi

echo
read -r -p "是否配置 GitHub Verified 签名提交？[y/N] " enable_sign
if [[ "$enable_sign" =~ ^[Yy]$ ]]; then
  sign_key="$HOME/.ssh/id_ed25519_signing"
  if [[ ! -f "$sign_key" ]]; then
    echo "正在生成独立的提交签名密钥。"
    echo "按提示输入 passphrase；按 Enter 两次可不设置。"
    ssh-keygen -t ed25519 -C "$git_email" -f "$sign_key"
  else
    echo "已存在签名密钥，跳过生成：$sign_key"
  fi
  git config --global gpg.format ssh
  git config --global user.signingkey "$sign_key.pub"
  git config --global commit.gpgsign true
  echo "已启用 Git 自动签名。请将签名公钥单独添加到 GitHub 的 Signing Key。"
fi

echo
echo "=== SSH 认证公钥（添加到 GitHub Authentication Key 和 Gitee SSH 公钥）==="
cat "$auth_key.pub"
if [[ "${enable_sign:-}" =~ ^[Yy]$ ]]; then
  echo
  echo "=== 签名公钥（单独添加到 GitHub Signing Key）==="
  cat "$HOME/.ssh/id_ed25519_signing.pub"
fi

echo
echo "后续操作："
echo "1. 添加上面显示的公钥到对应平台（不要上传无 .pub 后缀的私钥）。"
echo "2. 测试：ssh -T git@github.com && ssh -T git@gitee.com"
echo "3. GitHub 签名设置：https://github.com/settings/keys"
echo "4. Gitee SSH 设置：https://gitee.com/profile/sshkeys"
