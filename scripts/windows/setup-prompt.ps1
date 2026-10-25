$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "未检测到 winget。请先安装/更新 Windows App Installer：https://aka.ms/getwinget"
}

$installed = winget list --id Starship.Starship --exact 2>$null | Out-String
if ($installed -match "Starship.Starship") {
    Write-Host "Starship 已安装。"
} else {
    winget install --id Starship.Starship --exact --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { throw "Starship 安装失败，请检查 winget 输出后重试。" }
}

$configDir = Join-Path $HOME ".config"
New-Item -ItemType Directory -Path $configDir -Force | Out-Null
$configPath = Join-Path $configDir "starship.toml"
if (-not (Test-Path $configPath)) {
    Copy-Item (Join-Path $PSScriptRoot "../../configs/starship.toml") $configPath
    Write-Host "已创建配置：$configPath"
} else {
    Write-Host "检测到已有 Starship 配置，未覆盖：$configPath"
}

$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($profileContent -notmatch [regex]::Escape("starship init powershell")) {
    Add-Content -Path $PROFILE -Value "`n# Starship prompt`nInvoke-Expression (&starship init powershell)"
    Write-Host "已启用 PowerShell 的 Starship。"
} else {
    Write-Host "PowerShell 已配置 Starship，未重复追加。"
}

Write-Host "`n完成。重新打开 Windows Terminal 即可生效。字体建议使用 Maple Mono NF CN。"
