[CmdletBinding()]
param([switch]$ForceConfig)

$ErrorActionPreference = "Stop"

# Detect an existing Starship installation before falling back to the
# repository's default per-user installation directory. WinGet is not required.
$starshipPath = $null
$starshipCommand = Get-Command starship -CommandType Application -ErrorAction SilentlyContinue |
    Select-Object -First 1

if ($starshipCommand) {
    $starshipPath = $starshipCommand.Source
}

if (-not $starshipPath) {
    $candidates = @(
        "C:\Program Files\starship\bin\starship.exe",
        (Join-Path $env:LOCALAPPDATA "Programs\starship\starship.exe")
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            $starshipPath = $candidate
            break
        }
    }
}

if ($starshipPath) {
    $installDir = Split-Path -Parent $starshipPath
    Write-Host "检测到 Starship：$starshipPath"
} else {
    $installDir = Join-Path $env:LOCALAPPDATA "Programs\starship"
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    Write-Warning "尚未检测到 Starship，将使用默认安装目录：$installDir"
    Write-Host "请从官方 Releases 下载 Windows x86_64 MSVC ZIP："
    Write-Host "https://github.com/starship/starship/releases/latest"
    Write-Host "将解压出的 starship.exe 放到：$installDir"
}

# Ensure the detected directory is available in the current process and
# persist it in the user's PATH. This also supports Program Files installs.
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
    $newUserPath = if ([string]::IsNullOrWhiteSpace($userPath)) {
        $installDir
    } else {
        "$userPath;$installDir"
    }
    [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
    Write-Host "已将 Starship 目录加入用户 PATH：$installDir"
}

$currentPathExists = $false
foreach ($entry in ($env:Path -split ";")) {
    if ($entry.TrimEnd("\") -ieq $installDir.TrimEnd("\")) {
        $currentPathExists = $true
        break
    }
}
if (-not $currentPathExists) {
    $env:Path = "$installDir;$env:Path"
}

$configDir = Join-Path $HOME ".config"
New-Item -ItemType Directory -Path $configDir -Force | Out-Null
$configPath = Join-Path $configDir "starship.toml"
$sourceConfig = Join-Path $PSScriptRoot "../../configs/starship.toml"

if (-not (Test-Path -LiteralPath $sourceConfig -PathType Leaf)) {
    throw "找不到仓库配置文件：$sourceConfig。请从 dev-env 仓库根目录运行脚本。"
}

if ((Test-Path -LiteralPath $configPath) -and -not $ForceConfig) {
    Write-Host "检测到已有配置，未覆盖：$configPath"
    Write-Host "如需同步仓库最新配置，请使用：.\scripts\windows\setup-prompt.ps1 -ForceConfig"
} else {
    Copy-Item -LiteralPath $sourceConfig -Destination $configPath -Force
    Write-Host "已复制 Starship 配置：$configPath"
}

$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path -LiteralPath $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
if (-not (Test-Path -LiteralPath $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$profileContent = Get-Content -LiteralPath $PROFILE -Raw -ErrorAction SilentlyContinue
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
    [System.IO.File]::WriteAllText($PROFILE, $profileContent, [System.Text.UTF8Encoding]::new($true))
    Write-Host "已将旧版 Starship 初始化命令改为安全检查形式。"
} elseif ($profileContent -notmatch 'starship init powershell') {
    $newline = [Environment]::NewLine
    $profileContent = [string]$profileContent + $newline + "# Starship prompt" + $newline + $initBlock.TrimEnd()
    [System.IO.File]::WriteAllText($PROFILE, $profileContent, [System.Text.UTF8Encoding]::new($true))
    Write-Host "已将 Starship 初始化配置写入：$PROFILE"
} else {
    Write-Host "检测到现有 Starship 初始化配置，未重复添加。"
}

$resolvedStarship = Get-Command starship -CommandType Application -ErrorAction SilentlyContinue
if ($resolvedStarship) {
    Write-Host "Starship 已就绪：$($resolvedStarship.Source)"
} elseif ($starshipPath -and (Test-Path -LiteralPath $starshipPath -PathType Leaf)) {
    Write-Host "Starship 已就绪：$starshipPath"
} else {
    Write-Warning "请先将 starship.exe 放入上述目录，再重新打开 PowerShell。"
}

Write-Host ""
Write-Host "完成。重新打开 PowerShell 7 即可生效。默认主题：Catppuccin Mocha"
