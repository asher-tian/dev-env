#!/usr/bin/env bash
set -euo pipefail

if ! command -v code >/dev/null 2>&1; then
  echo "未检测到 VS Code 的 code 命令。"
  echo "请在 VS Code 命令面板运行：Shell Command: Install 'code' command in PATH"
  exit 1
fi

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
extensions_file="$repo_root/configs/vscode/extensions.txt"

if [[ ! -f "$extensions_file" ]]; then
  echo "找不到 VS Code 扩展清单：$extensions_file" >&2
  exit 1
fi

failed_extensions=""
failed_count=0
installed_count=0

while IFS= read -r extension || [[ -n "$extension" ]]; do
  extension="$(printf '%s' "$extension" | tr -d '\r')"
  case "$extension" in
    ""|\#*) continue ;;
  esac

  echo "==> 安装或更新扩展：$extension"
  if code --install-extension "$extension"; then
    installed_count=$((installed_count + 1))
  else
    echo "扩展安装失败：$extension" >&2
    failed_extensions="$failed_extensions
  - $extension"
    failed_count=$((failed_count + 1))
  fi
done < "$extensions_file"

if [[ "$failed_count" -gt 0 ]]; then
  echo
  echo "以下扩展安装失败：" >&2
  printf '%s\n' "$failed_extensions" >&2
  exit 1
fi

echo
echo "VS Code 扩展安装完成，共处理 $installed_count 个扩展。"
echo "请按 docs/editor/vscode-terminal.md 配置主题、字体和 Settings Sync。"
