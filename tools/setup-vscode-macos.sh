#!/usr/bin/env bash
set -euo pipefail

if ! command -v code >/dev/null 2>&1; then
  echo "未检测到 VS Code 的 code 命令。"
  echo "请在 VS Code 命令面板运行：Shell Command: Install 'code' command in PATH"
  exit 1
fi

extensions=(
  Catppuccin.catppuccin-vsc
  Vue.volar
  golang.go
  ms-python.python
  ms-python.vscode-pylance
  charliermarsh.ruff
  ms-azuretools.vscode-docker
  ms-vscode-remote.remote-containers
)

for extension in "${extensions[@]}"; do
  echo "==> 安装或更新扩展：$extension"
  code --install-extension "$extension"
done

echo
echo "扩展安装完成。请按 tools/vscode-terminal.md 配置主题、字体和 Settings Sync。"
