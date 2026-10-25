# 终端提示符（Starship）

推荐使用 Starship：macOS 的 zsh 和 Windows PowerShell 都能使用同一份简洁配置。不需要安装 Oh My Zsh，也不需要额外的主题框架。

官方资料：[Starship](https://starship.rs/) · [GitHub](https://github.com/starship/starship)。

## 安装与配置

在 `dev-env` 仓库根目录执行。

### macOS

```bash
bash scripts/macos/setup-prompt.sh
```

脚本通过 Homebrew 安装 Starship，将配置复制到 `~/.config/starship.toml`，并在 `.zshrc` 中添加初始化命令。

### Windows（PowerShell）

```powershell
.\scripts\windows\setup-prompt.ps1
```

脚本通过 winget 安装 Starship，将配置复制到 `~/.config/starship.toml`，并在 PowerShell profile 中添加初始化命令。

脚本不会覆盖已存在的 `starship.toml`，也不会重复添加初始化命令。配置文件已存在时，若想使用仓库默认配置，请先备份并手动替换。

## 默认显示

- 当前目录
- Git 分支和工作区状态
- 执行时间超过 2 秒的命令耗时
- 上一条命令的成功 / 失败状态

推荐配合 [Maple Mono NF CN](fonts.md)，以正确显示终端图标。

## 常见问题

- 修改配置后，重新打开终端；也可以执行 `exec zsh`（macOS）。
- Windows 如果提示找不到 `starship`，重新打开 Windows Terminal，确认 winget 安装目录已加入 PATH。
- 如果已有 Oh My Zsh、Powerlevel10k 等提示符框架，避免同时启用多个提示符。使用 Starship 时可先关闭其他主题的 prompt 初始化。
