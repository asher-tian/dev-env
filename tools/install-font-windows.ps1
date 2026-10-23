$ErrorActionPreference = "Stop"

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    throw "未检测到 Scoop。请先按官方说明安装：https://scoop.sh/ ，然后重新打开 PowerShell。"
}

$bucketList = scoop bucket list | Out-String
if ($bucketList -notmatch "(?m)^nerd-fonts\s") {
    scoop bucket add nerd-fonts
    if ($LASTEXITCODE -ne 0) { throw "添加 nerd-fonts bucket 失败。" }
}

$installed = scoop list Maple-Mono-NF-CN 2>$null | Out-String
if ($installed -match "Maple-Mono-NF-CN") {
    Write-Host "Maple Mono NF CN 已安装。"
} else {
    scoop install Maple-Mono-NF-CN
    if ($LASTEXITCODE -ne 0) { throw "Maple Mono NF CN 安装失败。" }
}

Write-Host "`n完成。若 VS Code 或终端未识别字体，请重启对应应用。"
