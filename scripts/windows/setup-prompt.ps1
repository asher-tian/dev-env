[CmdletBinding()]
param([switch]$ForceConfig)

$ErrorActionPreference = "Stop"

# Starship binary is installed manually from GitHub Releases; WinGet is not required.
$installDir = Join-Path $env:LOCALAPPDATA "Programs\starship"
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathEntries = @($userPath -split ";" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
$pathExists = $false
foreach ($entry in $pathEntries) {
    if ($entry.TrimEnd("\") -ieq $installDir.TrimEnd("\")) {
        $pathExists = $true
        break
    }
}
if (-not $pathExists) {
    $newUserPath = if ([string]::IsNullOrWhiteSpace($userPath)) { $installDir } else { "$installDir;$userPath" }
    [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
    Write-Host "已将 Starship 目录加入用户 PATH：$installDir"
}
if (($env:Path -split ";") -notcontains $installDir) {
    $env:Path = "$installDir;$env:Path"
}

$configDir = Join-Path $HOME ".config"
New-Item -ItemType Directory -Path $configDir -Force | Out-Null
$configPath = Join-Path $configDir "starship.toml"
$sourceConfig = Join-Path $PSScriptRoot "../../configs/starship.toml"
if (-not (Test-Path $sourceConfig)) {
    throw "找不到仓库配置文件：$sourceConfig。请从 dev-env 仓库根目录运行脚本。"
}
if ((Test-Path $configPath) -and -not $ForceConfig) {
    Write-Host "检测到已有配置，未覆盖：$configPath"
    Write-Host "如需同步仓库最新配置，请使用：.\scripts\windows\setup-prompt.ps1 -ForceConfig"
} else {
    Copy-Item -LiteralPath $sourceConfig -Destination $configPath -Force
    Write-Host "已复制 Starship 配置：$configPath"
}

$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
$initBlock = @'
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
'@
$guardedPattern = '(?s)if\s*\(Get-Command starship -ErrorAction SilentlyContinue\)\s*\{\s*Invoke-Expression\s+\(&starship init powershell\)\s*\}'
$plainPattern = '(?m)^[ \t]*Invoke-Expression\s+\(&starship init powershell\)[ \t]*$'

if ($profileContent -match $guardedPattern) {
    Write-Host "PowerShell Profile 已配置 Starship。"
} elseif ($profileContent -match $plainPattern) {
    $profileContent = [regex]::Replace($profileContent, $plainPattern, $initBlock.TrimEnd(), 1)
    Set-Content -Path $PROFILE -Value $profileContent -Encoding utf8NoBOM
    Write-Host "已将旧版 Starship 初始化命令改为安全检查形式。"
} elseif ($profileContent -notmatch 'starship init powershell') {
    $newline = [Environment]::NewLine
    Add-Content -Path $PROFILE -Value ($newline + "# Starship prompt" + $newline + $initBlock.TrimEnd())
    Write-Host "已将 Starship 初始化配置写入：$PROFILE"
} else {
    Write-Host "检测到现有 Starship 初始化配置，未重复添加。"
}

$starshipCommand = Get-Command starship -ErrorAction SilentlyContinue
if (-not $starshipCommand) {
    Write-Warning "尚未检测到 starship.exe。"
    Write-Host "下载 Windows x86_64 MSVC ZIP：https://github.com/starship/starship/releases/latest"
    Write-Host "将解压出的 starship.exe 放到：$installDir"
} else {
    Write-Host "Starship 已就绪：$($starshipCommand.Source)"
}

Write-Host ""
Write-Host "完成。重新打开 PowerShell 7 即可生效。默认主题：Catppuccin Mocha"
