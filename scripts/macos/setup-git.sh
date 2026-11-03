#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || { echo "未检测到 Git。请先运行 scripts/macos/setup.sh"; exit 1; }
command -v ssh-keygen >/dev/null 2>&1 || { echo "未检测到 ssh-keygen，请检查系统 OpenSSH 安装。"; exit 1; }

read -r -p "Git 提交昵称: " git_name
read -r -p "Git 提交邮箱（已添加并验证到 GitHub/Gitee）: " git_email
[[ -n "$git_name" && -n "$git_email" ]] || { echo "昵称和邮箱不能为空。"; exit 1; }
git config --global user.name "$git_name"
git config --global user.email "$git_email"
echo "已设置全局 Git 提交身份。"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
auth_key="$HOME/.ssh/id_ed25519_git"
if [[ ! -f "$auth_key" ]]; then
  echo "正在生成 GitHub/Gitee SSH 认证密钥。按提示输入 passphrase；按 Enter 两次可不设置。"
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
echo "选择 Git Commit 签名方式："
echo "  0. 保持现有签名配置不变"
echo "  1. SSH Signing"
echo "  2. GPG Signing"
read -r -p "请选择 [0/1/2，默认 0]: " sign_mode

if [[ "$sign_mode" == "1" ]]; then
  sign_key="$HOME/.ssh/id_ed25519_signing"
  if [[ ! -f "$sign_key" ]]; then
    echo "正在生成独立的 SSH 提交签名密钥。按提示输入 passphrase；按 Enter 两次可不设置。"
    ssh-keygen -t ed25519 -C "$git_email" -f "$sign_key"
  else
    echo "已存在 SSH 签名密钥，跳过生成：$sign_key"
  fi
  git config --global gpg.format ssh
  git config --global user.signingkey "$sign_key.pub"
  git config --global commit.gpgsign true
  echo "已启用 SSH Commit Signing。请将签名公钥添加到 GitHub 的 Signing Key。"
elif [[ "$sign_mode" == "2" ]]; then
  command -v gpg >/dev/null 2>&1 || { echo "未检测到 GPG。请先安装 GnuPG，再重新运行脚本。"; exit 1; }
  echo "当前 GPG 私钥："
  gpg --list-secret-keys --keyid-format LONG
  read -r -p "请输入用于签名的 GPG 主密钥 ID 或 UID 邮箱: " sign_key
  [[ -n "$sign_key" ]] || { echo "GPG 签名密钥不能为空。"; exit 1; }
  gpg --list-secret-keys "$sign_key" >/dev/null 2>&1 || { echo "当前 GPG 密钥库中找不到指定私钥：$sign_key"; exit 1; }
  git config --global gpg.format openpgp
  git config --global gpg.program "$(command -v gpg)"
  git config --global user.signingkey "$sign_key"
  git config --global commit.gpgsign true
  echo "已启用 GPG Commit Signing。请将对应公钥添加到 GitHub GPG keys 或内部 Git 平台。"
elif [[ "$sign_mode" == "0" || -z "$sign_mode" ]]; then
  echo "保留现有 Commit Signing 配置，不作修改。"
else
  echo "无效选项：$sign_mode。请输入 0、1 或 2。"
  exit 1
fi

echo
echo "=== SSH 认证公钥（添加到 GitHub Authentication Key 和 Gitee SSH 公钥）==="
cat "$auth_key.pub"
if [[ "$sign_mode" == "1" ]]; then
  echo
  echo "=== SSH 签名公钥（单独添加到 GitHub Signing Key）==="
  cat "$HOME/.ssh/id_ed25519_signing.pub"
elif [[ "$sign_mode" == "2" ]]; then
  echo
  echo "=== GPG 签名公钥（添加到 GitHub GPG keys / 内部 Git 平台）==="
  gpg --armor --export "$sign_key"
fi
echo
echo "后续操作："
echo "1. 只上传公钥，不要上传 SSH 私钥或 GPG 私钥。"
echo "2. SSH 认证测试：ssh -T git@github.com && ssh -T git@gitee.com"
echo "3. GitHub 密钥设置：https://github.com/settings/keys"
echo "4. GitHub GPG 设置：https://github.com/settings/gpg/new"
echo "5. 查看签名配置：git config --show-origin --show-scope --get-regexp 'gpg\.|user.signingkey|commit.gpgsign'"
