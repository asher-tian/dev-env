# 终端提示符（Starship）

Starship 负责 Shell Prompt；终端本身负责窗口、字体和配色。Windows Terminal、iTerm2、PowerShell 7、zsh 共用仓库中的同一份 `configs/starship.toml`，统一使用 Catppuccin Mocha 配色。

官方资料：[Starship](https://starship.rs/) · [GitHub](https://github.com/starship/starship)。

## 配置文件位置

Starship 默认读取：

- Windows：`$HOME\.config\starship.toml`
- macOS：`~/.config/starship.toml`（若设置了 `XDG_CONFIG_HOME`，则读取该目录下的 `starship.toml`）

仓库中的唯一默认配置是 `configs/starship.toml`。不要分别维护 Windows 和 macOS 两份不同主题配置。

## 安装与配置

### Windows（PowerShell 7）

本仓库不要求通过 WinGet 安装 Starship，避免 WinGet 源或代理不可用时阻塞初始化。

1. 打开 [Starship Releases](https://github.com/starship/starship/releases/latest)。
2. 下载 `starship-x86_64-pc-windows-msvc.zip`。
3. 解压后，将 `starship.exe` 放入以下任一目录：

- 推荐默认目录：`%LOCALAPPDATA%\Programs\starship\starship.exe`
- 如果已通过其他方式安装，也支持：`C:\Program Files\starship\bin\starship.exe`
- 或放在 PATH 已包含的任意目录。

4. 在 `dev-env` 仓库根目录运行：

```powershell
.\scripts\windows\setup-prompt.ps1
```

脚本优先检测 PATH 中已有的 Starship，其次检测 `C:\Program Files\starship\bin\starship.exe` 和 `%LOCALAPPDATA%\Programs\starship\starship.exe`。检测到后会将安装目录加入用户 PATH，再复制配置到 `$HOME\.config\starship.toml` 并配置 PowerShell Profile。脚本不下载二进制文件，也不调用 WinGet。

### macOS

安装 [Homebrew](https://brew.sh/) 后，在仓库根目录运行：

```bash
bash scripts/macos/setup-prompt.sh
```

脚本通过 Homebrew 安装 Starship，将配置复制到 `~/.config/starship.toml`，并在 `.zshrc` 中添加初始化命令。

## 将仓库配置复制到本机

默认脚本会保留已有个人配置。如果你想把仓库最新的 Catppuccin Mocha 配置覆盖到本机：

Windows：

```powershell
.\scripts\windows\setup-prompt.ps1 -ForceConfig
```

也可以手动复制：

```powershell
New-Item -ItemType Directory -Force "$HOME\.config" | Out-Null
Copy-Item .\configs\starship.toml "$HOME\.config\starship.toml" -Force
```

macOS：

```bash
bash scripts/macos/setup-prompt.sh --force
```

也可以手动复制：

```bash
mkdir -p ~/.config
cp configs/starship.toml ~/.config/starship.toml
```

## 默认显示

- 当前目录（蓝色）
- Git 分支（Mauve）和工作区状态（黄色）
- 执行时间超过 2 秒的命令耗时
- 上一条命令的成功 / 失败状态

Git 分支图标需要支持 Nerd Font 的字体，推荐 [Maple Mono NF CN](fonts.md)。

## PowerShell 7 Profile

保留 UTF-8 和 PSReadLine 配置；删除自行定义的 `function prompt`，避免与 Starship 重复管理提示符。将下面代码放在 Profile 末尾：

```powershell
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
```

PSReadLine 的颜色使用 Windows Terminal 当前配色方案的 ANSI 色板。Catppuccin Mocha 下可采用：

```powershell
Set-PSReadLineOption -Colors @{
    Default            = 'Gray'
    Command            = 'Yellow'
    Parameter          = 'Cyan'
    String             = 'Green'
    Number             = 'Magenta'
    Variable           = 'DarkMagenta'
    Operator           = 'DarkGray'
    Comment            = 'DarkGray'
    Keyword             = 'Blue'
    Type               = 'Cyan'
    Member             = 'Gray'
    Error              = 'Red'
    ContinuationPrompt = 'DarkGray'
    Emphasis           = 'Magenta'
    Selection          = 'White'
}
```

## 常见问题

- 修改配置后重新打开终端，或重新初始化当前 Shell。
- Windows 如果提示找不到 `starship`，运行 `Get-Command starship` 检查 PATH；重新运行 `setup-prompt.ps1` 会自动检测常见安装路径并修复用户 PATH。
- 如果已有 Oh My Zsh、Powerlevel10k 或其他自定义 Prompt，避免同时启用多个提示符框架。
- 仓库配置更新后，使用 `-ForceConfig`（Windows）或 `--force`（macOS）同步；默认模式不会覆盖个人修改。
