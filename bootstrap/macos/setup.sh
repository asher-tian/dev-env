#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "未检测到 Homebrew。请先按官方文档安装：https://brew.sh/"
  exit 1
fi

failed_packages=()

echo "==> 安装基础开发工具"
for package in git mise uv; do
  if brew list --formula "$package" >/dev/null 2>&1; then
    echo "已安装：$package"
  else
    if brew install "$package"; then
      :
    else
      status=$?
      echo "警告：安装失败：${package}（退出码 ${status}），继续安装后续工具。" >&2
      failed_packages+=("$package")
    fi
  fi
done

echo "==> 安装 VS Code、Docker Desktop 和 iTerm2"
for app in visual-studio-code docker iterm2; do
  if brew list --cask "$app" >/dev/null 2>&1; then
    echo "已安装：$app"
  else
    if brew install --cask "$app"; then
      :
    else
      status=$?
      echo "警告：安装失败：${app}（退出码 ${status}），继续安装后续工具。" >&2
      failed_packages+=("$app")
    fi
  fi
done

ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"
mkdir -p "$(dirname "$ZSHRC")"
if ! grep -Fq 'mise activate zsh' "$ZSHRC" 2>/dev/null; then
  {
    echo
    echo '# mise: activate project-specific tool versions'
    echo 'eval "$(mise activate zsh)"'
  } >> "$ZSHRC"
  echo "已将 mise 初始化配置写入：$ZSHRC"
else
  echo "已存在 mise zsh 初始化配置"
fi

echo
if [ "${#failed_packages[@]}" -gt 0 ]; then
  echo "初始化流程已结束，以下工具安装失败，请检查上方输出后重新运行脚本：" >&2
  printf '  - %s\n' "${failed_packages[@]}" >&2
else
  echo "初始化完成。"
fi
echo "请重新打开终端，然后启动 Docker Desktop。"
echo "检查版本：git --version && mise --version && uv --version"
echo "VS Code、iTerm2 和 Docker Desktop 首次启动可能需要完成系统提示。"
