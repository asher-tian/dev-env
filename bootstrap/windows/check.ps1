$ErrorActionPreference = "Continue"
$passed = 0
$warnings = 0

function Ok([string] $Message) {
    $script:passed++
    Write-Host "  [OK] $Message" -ForegroundColor Green
}
function Warn([string] $Message) {
    $script:warnings++
    Write-Host "  [检查] $Message" -ForegroundColor Yellow
}
function Check-Command([string] $Label, [string] $Name) {
    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($null -ne $command) {
        Ok "${Label}：$($command.Source)"
    } else {
        Warn "${Label}：未在 PATH 中找到 $Name"
    }
}

Write-Host "==> 基础工具"
Check-Command "Git" "git"
Check-Command "winget" "winget"
Check-Command "mise" "mise"
Check-Command "uv" "uv"
Check-Command "VS Code CLI" "code"
Check-Command "Docker CLI" "docker"
Check-Command "Windows Terminal" "wt"
Check-Command "Starship" "starship"

Write-Host "`n==> AI Coding（可选）"
Check-Command "Codex" "codex"
Check-Command "Claude Code" "claude"

Write-Host "`n==> 配置"
$profileContent = if (Test-Path $PROFILE) { Get-Content $PROFILE -Raw } else { "" }
if ($profileContent.Contains("mise activate pwsh")) { Ok "PowerShell：已配置 mise" } else { Warn "PowerShell：未配置 mise" }
if ($profileContent.Contains("starship init powershell")) { Ok "PowerShell：已配置 Starship" } else { Warn "PowerShell：未配置 Starship（可选）" }

if (Test-Path (Join-Path $HOME ".config/starship.toml")) {
    Ok "Starship：用户配置文件已存在"
} else {
    Warn "Starship：缺少用户配置（可选）"
}

if (Get-Command git -ErrorAction SilentlyContinue) {
    foreach ($setting in @("user.name", "user.email")) {
        $value = git config --global --get $setting 2>$null
        if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($value)) {
            Ok "Git：$setting 已设置"
        } else {
            Warn "Git：$setting 未设置"
        }
    }
}
if (Test-Path (Join-Path $HOME ".ssh/id_ed25519_git.pub")) {
    Ok "Git SSH：检测到认证公钥"
} else {
    Warn "Git SSH：未发现约定的认证公钥（也可能使用其他密钥）"
}

Write-Host "`n==> Docker"
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $null = docker info --format '{{.ServerVersion}}' 2>$null
    if ($LASTEXITCODE -eq 0) { Ok "Docker Engine 可以连接" }
    else { Warn "Docker Engine 未连接；请先启动 Docker Desktop" }
} else {
    Warn "Docker CLI 未安装"
}

Write-Host "`nMaple Mono NF CN 字体、终端外观及 SSH 平台认证需要按文档手动检查。"
Write-Host "`n结果：通过 $passed 项；需要检查 $warnings 项"
Write-Host "验收指南：https://github.com/asher-tian/dev-env/blob/main/docs/validation.md"
