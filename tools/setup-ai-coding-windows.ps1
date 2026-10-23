$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "未检测到 winget。请先安装/更新 Windows App Installer：https://aka.ms/getwinget"
}

Write-Host "==> 安装 Claude Code"
$claudeInstalled = winget list --id Anthropic.ClaudeCode --exact 2>$null | Out-String
if ($claudeInstalled -match "Anthropic.ClaudeCode") {
    Write-Host "Claude Code 已安装，跳过。"
} else {
    winget install --id Anthropic.ClaudeCode --exact --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Claude Code 安装未成功，请检查 winget 输出后重试。"
    }
}

Write-Host "`n==> 安装 Codex CLI（官方安装程序）"
if (Get-Command codex -ErrorAction SilentlyContinue) {
    Write-Host "Codex CLI 已安装，跳过。"
} else {
    powershell -ExecutionPolicy ByPass -Command "irm https://chatgpt.com/codex/install.ps1 | iex"
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Codex 安装程序返回非零状态。请重新打开终端并检查 codex --version。"
    }
}

Write-Host "`n安装命令已执行。请重新打开终端并检查："
Write-Host "codex --version"
Write-Host "claude --version"
Write-Host "首次运行 codex 和 claude 时，请按提示自行登录。"
