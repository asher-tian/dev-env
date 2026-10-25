#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "未检测到 Homebrew。请先安装：https://brew.sh/"
  exit 1
fi

for app in codex claude-code; do
  if brew list --cask "$app" >/dev/null 2>&1; then
    echo "已安装，跳过：$app"
  else
    echo "正在安装：$app"
    brew install --cask "$app"
  fi
done

echo
echo "安装命令已执行。请重新打开终端并检查："
echo "codex --version"
echo "claude --version"
echo
echo "首次运行 codex 和 claude 时，请按提示自行登录。"
