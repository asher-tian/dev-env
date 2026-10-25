# 脚本清单与执行顺序

[返回入口](../../README.md) · [完整初始化步骤](new-computer-setup.md) · [手动配置清单](manual-configuration.md)

以下命令都在 `dev-env` 仓库根目录执行。只运行当前操作系统对应的一列；不要跨系统执行。WSL2 / Linux 暂无自动安装脚本，按 [WSL2 指南](../development/windows-wsl-devcontainers.md)手动安装。

## 执行哪些脚本

按表格从上到下执行，每一步完成后再继续。AI CLI 和 Starship 可按需跳过。

| 顺序 | 用途 | macOS（Bash） | Windows 原生（PowerShell） |
| --- | --- | --- | --- |
| 1 | 基础开发环境 | `bash scripts/macos/setup.sh` | `.\scripts\windows\setup.ps1` |
| 2 | Git 身份与 SSH | `bash scripts/macos/setup-git.sh` | `.\scripts\windows\setup-git.ps1` |
| 3（可选） | Codex / Claude Code | `bash scripts/macos/setup-ai-coding.sh` | `.\scripts\windows\setup-ai-coding.ps1` |
| 4 | Maple Mono NF CN 字体 | `bash scripts/macos/install-font.sh` | `.\scripts\windows\install-font.ps1` |
| 5 | VS Code 扩展 | `bash scripts/macos/setup-vscode.sh` | `.\scripts\windows\setup-vscode.ps1` |
| 6（可选） | Starship 提示符 | `bash scripts/macos/setup-prompt.sh` | `.\scripts\windows\setup-prompt.ps1` |
| 7 | 完成手动配置后验收 | `bash scripts/macos/check.sh` | `.\scripts\windows\check.ps1` |

Windows 当前 PowerShell 会话如阻止执行脚本，先运行 `Set-ExecutionPolicy -Scope Process Bypass`。所有 Bash 脚本也可用 `./scripts/macos/setup.sh` 执行；ZIP 下载丢失执行权限时优先使用 `bash`。

## 每一步的前提和改动

| 脚本名 | 执行前准备 | 自动完成 | 仍需手动完成 |
| --- | --- | --- | --- |
| `setup` | macOS 先安装 Homebrew；Windows 先准备 winget | 安装 Git、mise、uv、VS Code、Docker Desktop，以及 iTerm2（macOS）或 Windows Terminal；写入 mise 的 Shell 初始化 | 重开终端，首次启动桌面应用，启动 Docker Desktop |
| `setup-git` | Git 和 `ssh-keygen` 可用；准备提交昵称和已验证邮箱 | 交互设置全局身份；生成认证密钥，追加 SSH 配置；选择签名时生成独立签名密钥并启用自动签名 | 输入身份与密钥 passphrase；在 GitHub / Gitee 登记认证公钥；选择签名时另登记 Signing Key |
| `setup-ai-coding` | macOS 需 Homebrew；Windows 需 winget 和可联网运行的安装程序 | 安装两种 AI CLI | 重开终端，分别启动并登录；在实际使用的环境里配置 |
| `install-font` | macOS 需 Homebrew；Windows 需先安装 Scoop | 安装 Maple Mono NF CN；Windows 按需添加 Nerd Fonts bucket | 重启应用，在 VS Code 和终端选择字体 |
| `setup-vscode` | VS Code 的 `code` 命令在 PATH 中 | 安装或更新 Catppuccin、Vue、Go、Python、Pylance、Ruff、Docker 和 Dev Containers 扩展 | 合并用户设置、设置终端外观、登录 Settings Sync；WSL 扩展另按需安装 |
| `setup-prompt` | macOS 需 Homebrew；Windows 需 winget | 安装 Starship；复制 `configs/starship.toml` 到用户配置目录；追加 Shell 初始化 | 重开终端；已有配置不会覆盖，需要时备份后手动替换 |
| `check` | 完成安装和手动配置 | 只读检查命令、部分配置和 Docker 连接，输出 `[OK]` / `[检查]` | 按[验收指南](validation.md)确认字体、SSH 平台认证、登录及项目实际运行 |

## 配置写到哪里

| 内容 | macOS | Windows 原生 |
| --- | --- | --- |
| mise / Starship Shell 初始化 | `${ZDOTDIR:-$HOME}/.zshrc` | 当前 PowerShell 的 `$PROFILE` |
| Git 全局身份与可选签名设置 | `git config --global` 管理 | `git config --global` 管理 |
| SSH 配置与认证密钥 | `~/.ssh/config`、`~/.ssh/id_ed25519_git` 及 `.pub` | `$HOME\.ssh\config`、`$HOME\.ssh\id_ed25519_git` 及 `.pub` |
| 可选签名密钥 | `~/.ssh/id_ed25519_signing` 及 `.pub` | `$HOME\.ssh\id_ed25519_signing` 及 `.pub` |
| Starship 默认配置 | `${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml` | `$HOME\.config\starship.toml` |

脚本需要完整仓库目录；Starship 脚本会相对脚本位置读取 `configs/starship.toml`，不要只复制单个脚本后运行。

## 重跑与失败处理

- 基础安装会跳过已检测到的工具，单项失败后继续并汇总失败项；看到“流程结束”仍需检查失败汇总。
- Git 脚本重跑会重新询问并设置全局身份，已有约定名称的密钥跳过生成，SSH 配置标记存在时不重复追加。选择不启用签名不会撤销以前启用的签名设置。
- 字体与 AI CLI 脚本跳过已检测到的安装；VS Code 脚本会安装或更新扩展；Starship 保留已有配置和初始化行。
- Windows AI CLI / VS Code 扩展安装可能以警告报告单项失败，需阅读输出并检查实际命令或扩展。
- 安装后找不到命令，先重开终端，再处理 PATH 或重新运行对应脚本。
- `check` 的提示和汇总用于人工自检，不将退出码当作环境全部可用的证明。当前 CI 只检查脚本语法。
