#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "未检测到 Homebrew。请先安装：https://brew.sh/"
  exit 1
fi

if brew list --cask font-maple-mono-nf-cn >/dev/null 2>&1; then
  echo "Maple Mono NF CN 已安装。"
else
  brew install --cask font-maple-mono-nf-cn
fi

echo
echo "完成。若 VS Code 或终端未识别字体，请重启对应应用。"
