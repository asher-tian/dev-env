$ErrorActionPreference = "Stop"

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    throw "未检测到 VS Code 的 code 命令。请重新打开终端；如果仍不可用，请检查 VS Code PATH 安装选项。"
}

$extensions = @(
    "Catppuccin.catppuccin-vsc",
    "Vue.volar",
    "golang.go",
    "ms-python.python",
    "charliermarsh.ruff",
    "ms-azuretools.vscode-docker",
    "ms-vscode-remote.remote-containers"
)

foreach ($extension in $extensions) {
    Write-Host "`n==> 安装或更新扩展：$extension"
    code --install-extension $extension
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "扩展安装失败：$extension。请检查网络或扩展 ID 后重试。"
    }
}

Write-Host "`n扩展安装完成。请按 tools/vscode-terminal.md 配置主题、字体和 Settings Sync。"
