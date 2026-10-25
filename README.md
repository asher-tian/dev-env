# dev-env

新电脑初始化与个人开发环境配置。目标是：**操作简单、优先脚本化、项目环境可复现**。

## 统一项目目录

所有代码仓库统一放在 `~/code` 下。

- macOS / Linux / WSL2：`~/code/project-name`
- Windows 原生 PowerShell：`$HOME\code\project-name`
- Windows + WSL2 开发时，使用 WSL2 内部的 `~/code`，不要把 Linux 项目放在 `/mnt/c` 下。

Windows、WSL2 和容器是不同环境；WSL2 项目通过 Dev Containers 工作区挂载进入容器，不需要复制一份代码。

## 新电脑快速开始

先按[新电脑初始化指南](./docs/new-computer-setup.md#1-获取仓库)获取仓库。以下脚本均在 `dev-env` 仓库根目录执行，选择当前系统对应的命令。

所有 `.sh` 脚本均支持 `bash 路径/脚本.sh` 和 `./路径/脚本.sh` 两种执行方式，例如 `bash bootstrap/macos/setup.sh` 或 `./bootstrap/macos/setup.sh`。通过 Git 克隆仓库后可直接执行；如果下载 ZIP 后执行权限丢失，可先运行 `chmod +x 路径/脚本.sh`。

### 1. 安装基础工具

macOS（先安装 [Homebrew](https://brew.sh/)）：

```bash
bash bootstrap/macos/setup.sh
```

Windows PowerShell（先安装或更新 [App Installer / winget](https://aka.ms/getwinget)）：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\bootstrap\windows\setup.ps1
```

安装完成后重新打开终端，回到仓库根目录，并启动 Docker Desktop。

### 2. 配置 Git 身份与 SSH

macOS：

```bash
bash git-config/setup-macos.sh
```

Windows PowerShell：

```powershell
.\git-config\setup-windows.ps1
```

按脚本提示将公钥添加到 GitHub / Gitee。详见 [Git 配置指南](./git-config/README.md)。

### 3. 安装 Codex 与 Claude Code

macOS：

```bash
bash tools/setup-ai-coding-macos.sh
```

Windows PowerShell：

```powershell
.\tools\setup-ai-coding-windows.ps1
```

安装后重新打开终端，分别运行 `codex` 和 `claude` 完成登录。详见 [AI Coding 工具指南](./tools/ai-coding.md)。

### 4. 安装 Maple Mono NF CN 字体

macOS：

```bash
bash tools/install-font-macos.sh
```

Windows PowerShell（先安装 [Scoop](https://scoop.sh/)）：

```powershell
.\tools\install-font-windows.ps1
```

详见[字体指南](./tools/fonts.md)。

### 5. 安装 VS Code 扩展并配置编辑器

macOS：

```bash
bash tools/setup-vscode-macos.sh
```

Windows PowerShell：

```powershell
.\tools\setup-vscode-windows.ps1
```

脚本安装 Catppuccin、Vue、Go、Python、Pylance、Ruff、Docker 和 Dev Containers 扩展。用户设置、终端字体和 Settings Sync 按 [VS Code 与终端指南](./tools/vscode-terminal.md)配置。

### 6. 可选：配置 Starship 提示符

macOS：

```bash
bash tools/setup-prompt-macos.sh
```

Windows PowerShell：

```powershell
.\tools\setup-prompt-windows.ps1
```

详见 [Starship 指南](./tools/starship.md)。

### 7. 验收开发环境

macOS：

```bash
bash bootstrap/macos/check.sh
```

Windows PowerShell：

```powershell
.\bootstrap\windows\check.ps1
```

检查项和排查说明参见[开发环境验收指南](./docs/validation.md)。

### 8. 创建项目

以下示例在 macOS / Linux / WSL2 中执行；已有 `~/code/dev-templates` 时跳过 clone：

```bash
uv tool install copier
cd ~/code
git clone https://github.com/asher-tian/dev-templates.git
copier copy ./dev-templates/python-cli ./my-cli
```

Windows PowerShell 原生环境：

```powershell
uv tool install copier
Set-Location "$HOME\code"
git clone https://github.com/asher-tian/dev-templates.git
copier copy ./dev-templates/python-cli ./my-cli
```

项目模板及使用说明见 [dev-templates](https://github.com/asher-tian/dev-templates)。Windows + WSL2 开发请先按 [WSL2 指南](./tools/windows-wsl-devcontainers.md)配置对应环境，Windows 原生安装结果不会自动用于 WSL2。

## 目录

- [新电脑初始化](./docs/new-computer-setup.md)：从基础软件安装到开始开发。
- [Git 配置](./git-config/README.md)：自动配置脚本、GitHub / Gitee SSH、GitHub Verified 签名提交、双平台同步。
- [mise](./tools/mise.md)：项目级运行时版本管理。
- [Docker 与 Dev Containers](./tools/docker-devcontainers.md)：容器开发与服务依赖的配置约定。
- [Windows + WSL2 + Dev Containers](./tools/windows-wsl-devcontainers.md)：Windows 上推荐的 Linux 开发流程、Git/SSH 和 AI CLI 分层。
- [Codex 与 Claude Code](./tools/ai-coding.md)：安装、登录、项目规则与配置边界。
- [字体与编辑器显示](./tools/fonts.md)：Maple Mono NF CN 安装。
- [VS Code 与终端](./tools/vscode-terminal.md)：Catppuccin Mocha、扩展、iTerm2、Windows Terminal 和 Settings Sync。
- [Starship 提示符](./tools/starship.md)：跨 macOS / Windows 的终端提示符配置。

## 设计原则

- 宿主机只安装通用工具；项目运行时和依赖优先由项目配置管理。
- 正式项目按需使用 Dev Containers；简单临时脚本不强制容器化。
- 项目语言版本由 `mise.toml`、`pyproject.toml` 等项目配置固定。
- Redis、数据库等服务默认随项目使用 Docker Compose 隔离；确实需要共享时再单独配置。
- Codex、Claude Code、微信开发者工具按需安装并登录，不把账号认证写进初始化脚本。
- 不提交访问令牌、SSH 私钥、密码或生产环境密钥。

## 说明

初始化脚本不会自动登录 GitHub、Gitee、Codex 或 Claude Code。Git 配置脚本只在本机生成密钥、设置 Git，并显示需要手动添加到平台的公钥。
