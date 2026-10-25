$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "未检测到 winget。请先安装/更新 Windows App Installer：https://aka.ms/getwinget"
}

$packages = @(
    @{ Id = "Git.Git"; Name = "Git" },
    @{ Id = "jdx.mise"; Name = "mise" },
    @{ Id = "astral-sh.uv"; Name = "uv" },
    @{ Id = "Microsoft.VisualStudioCode"; Name = "Visual Studio Code" },
    @{ Id = "Docker.DockerDesktop"; Name = "Docker Desktop" },
    @{ Id = "Microsoft.WindowsTerminal"; Name = "Windows Terminal" }
)

$failedPackages = @()

foreach ($package in $packages) {
    try {
        Write-Host "`n==> 检查 $($package.Name)"
        $installed = winget list --id $package.Id --exact 2>$null | Out-String
        if ($installed -match [regex]::Escape($package.Id)) {
            Write-Host "已安装，跳过：$($package.Name)"
            continue
        }

        Write-Host "正在安装：$($package.Name)"
        winget install --id $package.Id --exact --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            $failedPackages += $package.Name
            Write-Warning "安装失败：$($package.Name)（退出码 $LASTEXITCODE），继续安装后续工具。"
        }
    } catch {
        $failedPackages += $package.Name
        Write-Warning "检查或安装失败：$($package.Name)：$($_.Exception.Message)。继续安装后续工具。"
    }
}

# 在 PowerShell 启动时激活 mise。
$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}
$activation = '(& mise activate pwsh) | Out-String | Invoke-Expression'
$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($profileContent -notmatch [regex]::Escape('mise activate pwsh')) {
    Add-Content -Path $PROFILE -Value "`n# mise: activate project-specific tool versions`n$activation"
    Write-Host "已将 mise 初始化配置写入：$PROFILE"
} else {
    Write-Host "已存在 mise PowerShell 初始化配置"
}

if ($failedPackages.Count -gt 0) {
    Write-Warning "初始化流程已结束，以下工具检查或安装失败，请检查上方输出后重新运行脚本：$($failedPackages -join '、')"
} else {
    Write-Host "`n初始化完成。"
}
Write-Host "请关闭并重新打开终端，再启动 Docker Desktop。"
Write-Host "检查版本：git --version; mise --version; uv --version"
Write-Host "如果某个软件刚安装后仍无法识别，请重新打开终端后再检查。"
