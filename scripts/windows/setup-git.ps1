$ErrorActionPreference = "Stop"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "未检测到 Git。请先运行 scripts\windows\setup.ps1，然后重新打开 PowerShell。" }
if (-not (Get-Command ssh-keygen -ErrorAction SilentlyContinue)) { throw "未检测到 ssh-keygen，请检查 Git for Windows 或 Windows OpenSSH。" }

$gitName = Read-Host "Git 提交昵称"
$gitEmail = Read-Host "Git 提交邮箱（已添加并验证到 GitHub/Gitee）"
if ([string]::IsNullOrWhiteSpace($gitName) -or [string]::IsNullOrWhiteSpace($gitEmail)) { throw "昵称和邮箱不能为空。" }
git config --global user.name $gitName
git config --global user.email $gitEmail
Write-Host "已设置全局 Git 提交身份。"

$sshDir = Join-Path $HOME ".ssh"
New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
$authKey = Join-Path $sshDir "id_ed25519_git"
if (-not (Test-Path $authKey)) {
    Write-Host "正在生成 GitHub/Gitee SSH 认证密钥。按提示输入 passphrase；按 Enter 两次可不设置。"
    ssh-keygen -t ed25519 -C $gitEmail -f $authKey
    if ($LASTEXITCODE -ne 0) { throw "SSH 认证密钥生成失败。" }
} else { Write-Host "已存在 SSH 认证密钥，跳过生成：$authKey" }

$sshConfig = Join-Path $sshDir "config"
$marker = "# dev-env Git hosting keys"
$configText = Get-Content $sshConfig -Raw -ErrorAction SilentlyContinue
if ($configText -notmatch [regex]::Escape($marker)) {
    Add-Content -Path $sshConfig -Value "`n$marker`nHost github.com gitee.com`n  IdentityFile ~/.ssh/id_ed25519_git`n  IdentitiesOnly yes`n"
    Write-Host "已配置 SSH 使用 id_ed25519_git。"
} else { Write-Host "SSH config 中已存在 dev-env 配置标记，未重复追加。" }

Write-Host ""
Write-Host "选择 Git Commit 签名方式："
Write-Host "  0. 保持现有签名配置不变"
Write-Host "  1. SSH Signing"
Write-Host "  2. GPG Signing"
$signMode = Read-Host "请选择 [0/1/2，默认 0]"

if ($signMode -eq "1") {
    $signKey = Join-Path $sshDir "id_ed25519_signing"
    if (-not (Test-Path $signKey)) {
        Write-Host "正在生成独立的 SSH 提交签名密钥。按提示输入 passphrase；按 Enter 两次可不设置。"
        ssh-keygen -t ed25519 -C $gitEmail -f $signKey
        if ($LASTEXITCODE -ne 0) { throw "SSH 签名密钥生成失败。" }
    } else { Write-Host "已存在 SSH 签名密钥，跳过生成：$signKey" }
    git config --global gpg.format ssh
    git config --global user.signingkey "$signKey.pub"
    git config --global commit.gpgsign true
    Write-Host "已启用 SSH Commit Signing。请将签名公钥添加到 GitHub 的 Signing Key。"
} elseif ($signMode -eq "2") {
    $gpgCommand = Get-Command gpg -ErrorAction SilentlyContinue
    if ($null -eq $gpgCommand) { throw "未检测到 GPG。请先安装 GnuPG，并重新打开 PowerShell。" }
    Write-Host "`n当前 GPG 私钥："
    & $gpgCommand.Source --list-secret-keys --keyid-format LONG
    if ($LASTEXITCODE -ne 0) { throw "无法读取 GPG 私钥列表。" }
    $signKey = Read-Host "请输入用于签名的 GPG 主密钥 ID 或 UID 邮箱"
    if ([string]::IsNullOrWhiteSpace($signKey)) { throw "GPG 签名密钥不能为空。" }
    & $gpgCommand.Source --list-secret-keys $signKey *> $null
    if ($LASTEXITCODE -ne 0) { throw "当前 GPG 密钥库中找不到指定私钥：$signKey" }
    git config --global gpg.format openpgp
    git config --global gpg.program "$($gpgCommand.Source)"
    git config --global user.signingkey $signKey
    git config --global commit.gpgsign true
    Write-Host "已启用 GPG Commit Signing。请将对应公钥添加到 GitHub GPG keys 或内部 Git 平台。"
} elseif ($signMode -eq "0" -or [string]::IsNullOrWhiteSpace($signMode)) {
    Write-Host "保留现有 Commit Signing 配置，不作修改。"
} else { throw "无效选项：$signMode。请输入 0、1 或 2。" }

Write-Host "`n=== SSH 认证公钥（添加到 GitHub Authentication Key 和 Gitee SSH 公钥）==="
Get-Content "$authKey.pub"
if ($signMode -eq "1") {
    Write-Host "`n=== SSH 签名公钥（单独添加到 GitHub Signing Key）==="
    Get-Content "$sshDir\id_ed25519_signing.pub"
} elseif ($signMode -eq "2") {
    Write-Host "`n=== GPG 签名公钥（添加到 GitHub GPG keys / 内部 Git 平台）==="
    & $gpgCommand.Source --armor --export $signKey
}
Write-Host "`n后续操作："
Write-Host "1. 只上传公钥，不要上传 SSH 私钥或 GPG 私钥。"
Write-Host "2. SSH 认证测试：ssh -T git@github.com；ssh -T git@gitee.com"
Write-Host "3. GitHub 密钥设置：https://github.com/settings/keys"
Write-Host "4. GitHub GPG 设置：https://github.com/settings/gpg/new"
Write-Host "5. 查看签名配置：git config --show-origin --show-scope --get-regexp 'gpg\.|user.signingkey|commit.gpgsign'"
