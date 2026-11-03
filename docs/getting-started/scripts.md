# 脚本清单与执行顺序

[返回入口](../../README.md) · [完整初始化步骤](new-computer-setup.md) · [手动配置清单](manual-configuration.md)

以下命令都在 `dev-env` 仓库根目录执行。只运行当前操作系统对应的一列；不要跨系统执行。WSL2 / Linux 暂无自动安装脚本，按 [WSL2 指南](../development/windows-wsl-devcontainers.md)手动安装。

## 执行哪些脚本

| 顺序 | 用途 | macOS（Bash） | Windows 原生（PowerShell） |
| --- | --- | --- | --- |
| 1 | 基础开发环境 | `bash scripts/macos/setup.sh` | `.\\scripts\\windows\\setup.ps1` |
| 2 | Git 身份、SSH 与可选签名 | `bash scripts/macos/setup-git.sh` | `.\\scripts\\windows\\setup-git.ps1` |
| 3（可选） | Codex / Claude Code | `bash scripts/macos/setup-ai-coding.sh` | `.\\scripts\\windows\\setup-ai-coding.ps1` |
| 4 | Maple Mono NF CN 字体 | `bash scripts/macos/install-font.sh` | `.\\scripts\\windows\\install-font.ps1` |
| 5 | VS Code 扩展 | `bash scripts/macos/setup-vscode.sh` | `.\\scripts\\windows\\setup-vscode.ps1` |
| 6（可选） | Starship 提示符 | `bash scripts/macos/setup-prompt.sh` | `.\\scripts\\windows\\setup-prompt.ps1` |
| 7 | 完成手动配置后验收 | `bash scripts/macos/check.sh` | `.\\scripts\\windows\\check.ps1` |

Windows 当前 PowerShell 会话如阻止执行脚本，先运行 `Set-ExecutionPolicy -Scope Process Bypass`。

## 每一步的前提和改动

| 脚本名 | 执行前准备 | 自动完成 | 仍需手动完成 |
| --- | --- | --- | --- |
| `setup` | macOS 先安装 Homebrew；Windows 先准备 winget | 安装 Git、mise、uv、VS Code、Docker Desktop，以及 iTerm2（macOS）或 Windows Terminal | 重开终端，启动桌面应用和 Docker Desktop |
| `setup-git` | Git、`ssh-keygen` 可用；选择 GPG 时需安装 GnuPG | 设置全局身份；生成 SSH 认证密钥并配置 SSH；可选择保持现有签名配置、启用 SSH Signing 或 GPG Signing | 在平台登记认证公钥及所选签名方式的公钥 |
| `setup-ai-coding` | macOS 需 Homebrew；Windows 需 winget | 安装两种 AI CLI | 重开终端，分别启动并登录 |
| `install-font` | macOS 需 Homebrew；Windows 需 Scoop | 安装 Maple Mono NF CN | 重启应用并选择字体 |
| `setup-vscode` | VS Code 的 `code` 命令在 PATH 中 | 安装统一清单中的扩展 | 合并用户设置、登录 Settings Sync |
| `setup-prompt` | macOS 需 Homebrew；Windows 需 winget | 安装 Starship 并配置 Shell 初始化 | 重开终端 |
| `check` | 完成安装和手动配置 | 只读检查命令、部分配置和 Docker 连接 | 按验收指南人工确认 |

## 配置写到哪里

| 内容 | macOS | Windows 原生 |
| --- | --- | --- |
| Git 全局身份与可选签名设置 | `git config --global` | `git config --global` |
| SSH 配置与认证密钥 | `~/.ssh/config`、`~/.ssh/id_ed25519_git` | `$HOME\\.ssh\\config`、`$HOME\\.ssh\\id_ed25519_git` |
| SSH 签名密钥（选择 SSH Signing 时） | `~/.ssh/id_ed25519_signing` | `$HOME\\.ssh\\id_ed25519_signing` |
| GPG 密钥（选择 GPG Signing 时） | GnuPG 密钥库 | GnuPG 密钥库 |

## 重跑与失败处理

- Git 脚本重跑会重新询问身份；已有约定名称的 SSH 密钥跳过生成，SSH 配置标记存在时不重复追加。
- 选择“保持现有签名配置”不会修改签名设置；选择 SSH 或 GPG 会更新对应的全局签名配置。
- 安装后找不到命令，先重开终端，再处理 PATH 或重新运行对应脚本。
- `check` 的提示用于人工自检，不代表所有平台功能均已验证。
