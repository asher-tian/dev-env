#!/usr/bin/env bash
set -uo pipefail

passed=0
warnings=0

ok() { printf '  [OK] %s\n' "$1"; passed=$((passed + 1)); }
warn() { printf '  [检查] %s\n' "$1"; warnings=$((warnings + 1)); }

check_cmd() {
  local label="$1" cmd="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$label：$(command -v "$cmd")"
  else
    warn "$label：未在 PATH 中找到 $cmd"
  fi
}

echo "==> 基础工具"
for entry in "Git:git" "Homebrew:brew" "mise:mise" "uv:uv" "VS Code CLI:code" "Docker CLI:docker" "Starship:starship"; do
  check_cmd "${entry%%:*}" "${entry#*:}"
done

echo
echo "==> AI Coding（可选）"
check_cmd "Codex" codex
check_cmd "Claude Code" claude

echo
echo "==> 配置"
if [[ -f "${ZDOTDIR:-$HOME}/.zshrc" ]] && grep -Fq 'mise activate zsh' "${ZDOTDIR:-$HOME}/.zshrc"; then
  ok "Zsh：已写入 mise 激活配置"
else
  warn "Zsh：没有发现 mise 激活配置"
fi
if [[ -f "${ZDOTDIR:-$HOME}/.zshrc" ]] && grep -Fq 'starship init zsh' "${ZDOTDIR:-$HOME}/.zshrc"; then
  ok "Zsh：已写入 Starship 配置"
else
  warn "Zsh：未配置 Starship（可选）"
fi
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml" ]]; then
  ok "Starship：配置文件已存在"
else
  warn "Starship：缺少用户配置（可选）"
fi
for setting in user.name user.email; do
  if [[ -n "$(git config --global --get "$setting" 2>/dev/null || true)" ]]; then
    ok "Git：$setting 已设置"
  else
    warn "Git：$setting 未设置"
  fi
done
if [[ -f "$HOME/.ssh/id_ed25519_git.pub" ]]; then
  ok "Git SSH：检测到认证公钥"
else
  warn "Git SSH：未发现约定的认证公钥（也可能使用其他密钥）"
fi

echo
echo "==> 应用与服务"
if [[ -d "/Applications/Visual Studio Code.app" ]]; then ok "VS Code 应用已安装"; else warn "未在 /Applications 找到 VS Code"; fi
if [[ -d "/Applications/iTerm.app" ]]; then ok "iTerm2 已安装"; else warn "未在 /Applications 找到 iTerm2（可选）"; fi
if command -v docker >/dev/null 2>&1 && docker info --format '{{.ServerVersion}}' >/dev/null 2>&1; then
  ok "Docker Engine 可以连接"
else
  warn "Docker Engine 未连接；请先启动 Docker Desktop"
fi
echo "Maple Mono NF CN 字体、终端外观及 SSH 平台认证需要按文档手动检查。"
echo
printf '结果：通过 %s 项；需要检查 %s 项\n' "$passed" "$warnings"
echo "验收指南：https://github.com/asher-tian/dev-env/blob/main/docs/validation.md"
