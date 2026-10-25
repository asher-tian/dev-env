#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "未检测到 Homebrew。请先安装：https://brew.sh/"
  exit 1
fi

if brew list --formula starship >/dev/null 2>&1; then
  echo "Starship 已安装。"
else
  brew install starship
fi

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$CONFIG_DIR"
if [[ ! -f "$CONFIG_DIR/starship.toml" ]]; then
  cp "$(dirname "$0")/../../configs/starship.toml" "$CONFIG_DIR/starship.toml"
  echo "已创建配置：$CONFIG_DIR/starship.toml"
else
  echo "检测到已有 Starship 配置，未覆盖：$CONFIG_DIR/starship.toml"
fi

ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
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
