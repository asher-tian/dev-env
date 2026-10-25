$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "未检测到 Git。请先运行 scripts\windows\setup.ps1，然后重新打开 PowerShell。"
}
if (-not (Get-Command ssh-keygen -ErrorAction SilentlyContinue)) {
    throw "未检测到 ssh-keygen，请检查 Git for Windows 或 Windows OpenSSH 是否可用。"
}

$gitName = Read-Host "Git 提交昵称"
$gitEmail = Read-Host "Git 提交邮箱（已添加并验证到 GitHub/Gitee）"
if ([string]::IsNullOrWhiteSpace($gitName) -or [string]::IsNullOrWhiteSpace($gitEmail)) {
    throw "昵称和邮箱不能为空。"
}

git config --global user.name $gitName
git config --global user.email $gitEmail
Write-Host "已设置全局 Git 提交身份。"

$sshDir = Join-Path $HOME ".ssh"
New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
$authKey = Join-Path $sshDir "id_ed25519_git"

if (-not (Test-Path $authKey)) {
    Write-Host "正在生成 GitHub/Gitee SSH 认证密钥。"
    Write-Host "按提示输入 passphrase；按 Enter 两次可不设置（更方便，但私钥泄露风险更高）。"
    ssh-keygen -t ed25519 -C $gitEmail -f $authKey
    if ($LASTEXITCODE -ne 0) { throw "SSH 认证密钥生成失败。" }
} else {
    Write-Host "已存在 SSH 认证密钥，跳过生成：$authKey"
}

$sshConfig = Join-Path $sshDir "config"
$marker = "# dev-env Git hosting keys"
$configText = Get-Content $sshConfig -Raw -ErrorAction SilentlyContinue
if ($configText -notmatch [regex]::Escape($marker)) {
    Add-Content -Path $sshConfig -Value "`n$marker`nHost github.com gitee.com`n  IdentityFile ~/.ssh/id_ed25519_git`n  IdentitiesOnly yes`n"
    Write-Host "已配置 SSH 使用 id_ed25519_git。"
} else {
    Write-Host "SSH config 中已存在 dev-env 配置标记，未重复追加。"
}

$enableSign = Read-Host "是否配置 GitHub Verified 签名提交？[y/N]"
if ($enableSign -match '^[Yy]$') {
    $signKey = Join-Path $sshDir "id_ed25519_signing"
    if (-not (Test-Path $signKey)) {
        Write-Host "正在生成独立的提交签名密钥。"
        Write-Host "按提示输入 passphrase；按 Enter 两次可不设置。"
        ssh-keygen -t ed25519 -C $gitEmail -f $signKey
        if ($LASTEXITCODE -ne 0) { throw "SSH 签名密钥生成失败。" }
    } else {
        Write-Host "已存在签名密钥，跳过生成：$signKey"
    }
    git config --global gpg.format ssh
    git config --global user.signingkey "$signKey.pub"
    git config --global commit.gpgsign true
    Write-Host "已启用 Git 自动签名。请将签名公钥单独添加到 GitHub 的 Signing Key。"
}

Write-Host "`n=== SSH 认证公钥（添加到 GitHub Authentication Key 和 Gitee SSH 公钥）==="
Get-Content "$authKey.pub"
if ($enableSign -match '^[Yy]$') {
    Write-Host "`n=== 签名公钥（单独添加到 GitHub Signing Key）==="
    Get-Content "$sshDir\id_ed25519_signing.pub"
}

Write-Host "`n后续操作："
Write-Host "1. 添加上面显示的公钥到对应平台（不要上传无 .pub 后缀的私钥）。"
Write-Host "2. 测试：ssh -T git@github.com；ssh -T git@gitee.com"
Write-Host "3. GitHub 签名设置：https://github.com/settings/keys"
Write-Host "4. Gitee SSH 设置：https://gitee.com/profile/sshkeys"
