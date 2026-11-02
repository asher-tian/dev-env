$ErrorActionPreference = "Stop"

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    throw "未检测到 VS Code 的 code 命令。请重新打开终端；如果仍不可用，请检查 VS Code PATH 安装选项。"
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "../..")).Path
$extensionsFile = Join-Path $repoRoot "configs/vscode/extensions.txt"

if (-not (Test-Path -LiteralPath $extensionsFile -PathType Leaf)) {
    throw "找不到 VS Code 扩展清单：$extensionsFile"
}

$extensions = @(
    Get-Content -LiteralPath $extensionsFile -Encoding UTF8 |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith("#") }
)

if ($extensions.Count -eq 0) {
    throw "VS Code 扩展清单为空：$extensionsFile"
}

$failedExtensions = @()

foreach ($extension in $extensions) {
    Write-Host "`n==> 安装或更新扩展：$extension"
    & code --install-extension $extension
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "扩展安装失败：$extension"
        $failedExtensions += $extension
    }
}

if ($failedExtensions.Count -gt 0) {
    Write-Host "`n以下扩展安装失败：" -ForegroundColor Red
    $failedExtensions | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    throw "VS Code 扩展安装未全部完成。请检查网络后重新运行脚本。"
}

Write-Host "`nVS Code 扩展安装完成，共处理 $($extensions.Count) 个扩展。"
Write-Host "请按 docs/editor/vscode-terminal.md 配置主题、字体和 Settings Sync。"
