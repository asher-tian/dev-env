# 新电脑初始化

目标：用尽量少的手工操作，准备好 Git、VS Code、Docker、mise 和 uv；项目运行时再按项目配置安装语言版本与依赖。所有项目仓库统一放在 `~/code` 下。

先查看[脚本清单与执行顺序](scripts.md)；每一步的手动操作集中列在[手动配置清单](manual-configuration.md)。本文按顺序提供可直接执行的命令。AI CLI 和 Starship 可按需跳过。

## 1. 获取仓库

如果已安装 Git，按系统打开终端并执行。

macOS / Linux / WSL2：

```bash
mkdir -p ~/code
cd ~/code
git clone https://github.com/asher-tian/dev-env.git
cd dev-env
```

Windows PowerShell 原生环境：

```powershell
New-Item -ItemType Directory -Force "$HOME\code" | Out-Null
Set-Location "$HOME\code"
git clone https://github.com/asher-tian/dev-env.git
Set-Location dev-env
```

如果还没有 Git，可以先从 GitHub 下载仓库 ZIP 并解压到对应的 code 目录，再按后续步骤安装工具。

以下 `.sh` 脚本均可用 `bash 路径/脚本.sh` 或 `./路径/脚本.sh` 执行，例如 `bash scripts/macos/setup.sh` 和 `./scripts/macos/setup.sh`。Git 克隆会保留执行权限；如果下载 ZIP 后执行权限丢失，可先运行 `chmod +x 路径/脚本.sh`。

## 2. 安装基础工具

基础安装脚本在单个工具安装失败时会提示错误并继续安装后续工具，结束时汇总失败项。修复问题后可重新运行脚本，已安装的工具会自动跳过。

### macOS

先安装 [Homebrew](https://brew.sh/)，然后执行：

```bash
bash scripts/macos/setup.sh
```

### Windows

安装/更新 [Windows App Installer（winget）](https://aka.ms/getwinget)，打开 PowerShell，在仓库目录执行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup.ps1
```

**建议：** 如果主要使用 Docker、Dev Containers 和 Linux 工具链，继续按 [Windows WSL2 开发指南](../development/windows-wsl-devcontainers.md)完成 WSL2 配置。Windows 原生 PowerShell、WSL2 和容器是独立环境；在 Windows 安装的 Git / SSH / Codex / Claude CLI 不会自动出现在 WSL 或容器中。

## 3. 配置 Git

macOS：

```bash
bash scripts/macos/setup-git.sh
```

Windows 原生开发：

```powershell
.\scripts\windows\setup-git.ps1
```

如果主要在 WSL2 中开发，请在 WSL Ubuntu 内另行配置 Git 身份与 SSH；不要假设 Windows 的 `C:\Users\...\.ssh` 会自动等同于 WSL 的 `~/.ssh`。按脚本最后显示的链接，将公钥添加到 GitHub / Gitee。不要上传私钥。详细说明见 [Git 配置指南](../git/README.md)。

## 4. 可选：安装 Codex 与 Claude Code

macOS：

```bash
bash scripts/macos/setup-ai-coding.sh
```

Windows 原生 PowerShell：

```powershell
.\scripts\windows\setup-ai-coding.ps1
```

安装完成后，重新打开对应终端并检查：

```bash
codex --version
claude --version
```

首次运行 `codex` 和 `claude` 时按提示自行登录。若在 WSL 或 Dev Container 内运行 CLI，需要在对应环境安装并登录；不同环境的 CLI 和认证状态不会自动共享。配置见 [Codex 与 Claude Code 指南](../ai/ai-coding.md)。

## 5. 安装 Maple Mono NF CN 字体

统一使用 Maple Mono NF CN。macOS：

```bash
bash scripts/macos/install-font.sh
```

Windows（需先安装 [Scoop](https://scoop.sh/)）：

```powershell
.\scripts\windows\install-font.ps1
```

## 6. 安装 VS Code 扩展并配置编辑器

macOS：

```bash
bash scripts/macos/setup-vscode.sh
```

Windows PowerShell：

```powershell
.\scripts\windows\setup-vscode.ps1
```

脚本安装 Catppuccin、Vue、Go、Python、Pylance、Ruff、Docker 和 Dev Containers 扩展。若 macOS 提示找不到 `code`，先在 VS Code 命令面板运行 **Shell Command: Install 'code' command in PATH**，再重新打开终端执行脚本。

安装后，在 VS Code 命令面板运行 **Preferences: Open User Settings (JSON)**，按[VS Code 与终端配置指南](../editor/vscode-terminal.md)合并用户设置，再配置终端字体和 Settings Sync。

macOS 基础脚本会安装 iTerm2；Windows 基础脚本会安装 Windows Terminal。VS Code 设置可使用内置 Settings Sync 同步到其他电脑。

## 7. 可选：配置 Starship 提示符

Starship 可以统一 macOS zsh 和 Windows PowerShell 的终端提示符。运行对应脚本：

macOS：

```bash
bash scripts/macos/setup-prompt.sh
```

Windows：

```powershell
.\scripts\windows\setup-prompt.ps1
```

脚本不会覆盖已有的 Starship 配置。详见 [Starship 指南](../editor/starship.md)。

## 8. 验收开发环境

完成安装与配置后，运行对应系统的只读检查脚本：

macOS：

```bash
bash scripts/macos/check.sh
```

Windows PowerShell：

```powershell
.\scripts\windows\check.ps1
```

如有 `[检查]` 项，按[验收及故障排查指南](validation.md)逐项确认。脚本只读，不会安装软件或修改配置。

## 9. 创建项目

模板仓库也放在 `~/code` 下。从 `~/code` 执行：

```bash
uv tool install copier
cd ~/code
git clone https://github.com/asher-tian/dev-templates.git
copier copy ./dev-templates/python-cli ./my-cli
```

如果 `~/code/dev-templates` 已经存在，跳过 clone，直接执行 Copier 命令。Windows PowerShell 原生环境：

```powershell
uv tool install copier
Set-Location "$HOME\code"
git clone https://github.com/asher-tian/dev-templates.git
copier copy ./dev-templates/python-cli ./my-cli
```

已有 `$HOME\code\dev-templates` 时同样跳过 clone。模板及使用说明见 [dev-templates](https://github.com/asher-tian/dev-templates)。WSL2 开发使用 WSL2 内部的 `~/code`。

Copier 官方资料：[文档](https://copier.readthedocs.io/) · [GitHub](https://github.com/copier-org/copier)。

## 10. 开发原则

- 项目语言版本由项目配置决定，不在初始化脚本里安装所有 Python、Node.js、Go 版本。
- 优先使用 Dev Containers 固定复杂项目的 Linux 开发环境；简单的一次性脚本不强制容器化。
- Redis、数据库等依赖由项目的 Docker Compose 管理，除非确实需要共享服务。
- 微信开发者工具按需安装；它需要宿主机 GUI，不放进开发容器。
