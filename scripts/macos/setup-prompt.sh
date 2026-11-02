#!/usr/bin/env bash
set -euo pipefail

FORCE_CONFIG=false
if [[ "$#" -gt 0 && "$1" == "--force" ]]; then
  FORCE_CONFIG=true
elif [[ "$#" -gt 0 ]]; then
  echo "用法：bash scripts/macos/setup-prompt.sh [--force]"
  exit 2
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "未检测到 Homebrew。请先安装：https://brew.sh/"
  exit 1
fi

if brew list --formula starship >/dev/null 2>&1; then
  echo "Starship 已安装。"
else
  brew install starship
fi

CONFIG_DIR="$HOME/.config"
if printenv XDG_CONFIG_HOME >/dev/null 2>&1; then
  CONFIG_DIR="$(printenv XDG_CONFIG_HOME)"
fi
mkdir -p "$CONFIG_DIR"
CONFIG_PATH="$CONFIG_DIR/starship.toml"
SOURCE_CONFIG="$(dirname "$0")/../../configs/starship.toml"

if [[ ! -f "$CONFIG_PATH" || "$FORCE_CONFIG" == true ]]; then
  cp "$SOURCE_CONFIG" "$CONFIG_PATH"
  echo "已同步 Starship 配置：$CONFIG_PATH"
else
  echo "检测到已有 Starship 配置，未覆盖：$CONFIG_PATH"
  echo "如需同步仓库最新配置，请使用：bash scripts/macos/setup-prompt.sh --force"
fi

ZSHRC="$HOME/.zshrc"
if printenv ZDOTDIR >/dev/null 2>&1; then
  ZSHRC="$(printenv ZDOTDIR)/.zshrc"
fi
touch "$ZSHRC"
if ! grep -Fq 'starship init zsh' "$ZSHRC"; then
  {
    echo
    echo '# Starship prompt'
    echo 'eval "$(starship init zsh)"'
  } >> "$ZSHRC"
  echo "已启用 zsh 的 Starship。"
else
  echo "zsh 已配置 Starship，未重复追加。"
fi

echo
echo "完成。重新打开终端即可生效。字体建议使用 Maple Mono NF CN。"
