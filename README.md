# dev-env

新电脑初始化与个人开发环境配置：通用工具由脚本安装，账号登录和个人偏好按清单手动完成，项目工具链由项目配置管理。

## macOS：复制执行

先安装 [Homebrew](https://brew.sh/)。以下命令假设仓库位于 `~/code/dev-env`；已有仓库时跳过 clone。未安装 Git 时，可先下载仓库 ZIP 并解压到该目录。

```bash
# 获取仓库；已有仓库时跳过这三行
mkdir -p ~/code
cd ~/code
git clone https://github.com/asher-tian/dev-env.git

# 安装 Git、mise、uv、VS Code、Docker Desktop、iTerm2，并在 .zshrc 启用 mise
cd ~/code/dev-env
bash scripts/macos/setup.sh
```

完成后重新打开终端，启动 Docker Desktop，再执行：

```bash
cd ~/code/dev-env

# 交互设置 Git 昵称/邮箱、生成 SSH 密钥；按提示选择是否启用提交签名
bash scripts/macos/setup-git.sh

# 安装 Maple Mono NF CN 字体
bash scripts/macos/install-font.sh

# 安装或更新 Catppuccin、Vue、Go、Python、Pylance、Ruff、Docker、Dev Containers 扩展
bash scripts/macos/setup-vscode.sh
```

可选工具按需单独执行：

```bash
# 安装 Codex 和 Claude Code CLI；安装后需分别启动并登录
bash scripts/macos/setup-ai-coding.sh

# 安装 Starship、复制默认配置并写入 .zshrc；保留已有 Starship 配置
bash scripts/macos/setup-prompt.sh
```

## Windows：在 PowerShell 中复制执行

先安装或更新 [App Installer / winget](https://aka.ms/getwinget)。以下命令假设仓库位于 `$HOME\code\dev-env`；已有仓库时跳过 clone。未安装 Git 时，可先下载仓库 ZIP 并解压到该目录。

```powershell
# 获取仓库；已有仓库时跳过这三行
New-Item -ItemType Directory -Force "$HOME\code" | Out-Null
Set-Location "$HOME\code"
git clone https://github.com/asher-tian/dev-env.git

# 仅为当前 PowerShell 会话允许执行脚本
Set-ExecutionPolicy -Scope Process Bypass
Set-Location "$HOME\code\dev-env"

# 安装 Git、mise、uv、VS Code、Docker Desktop、Windows Terminal，并在当前 PowerShell profile 启用 mise
.\scripts\windows\setup.ps1
```

完成后重新打开 PowerShell，启动 Docker Desktop，再执行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
Set-Location "$HOME\code\dev-env"

# 交互设置 Git 昵称/邮箱、生成 SSH 密钥；按提示选择是否启用提交签名
.\scripts\windows\setup-git.ps1

# 安装 Maple Mono NF CN 字体；需先手动安装 Scoop：https://scoop.sh/
.\scripts\windows\install-font.ps1

# 安装或更新 Catppuccin、Vue、Go、Python、Pylance、Ruff、Docker、Dev Containers 扩展
.\scripts\windows\setup-vscode.ps1
```

可选工具按需单独执行：

```powershell
# 安装 Codex 和 Claude Code CLI；安装后需分别启动并登录
.\scripts\windows\setup-ai-coding.ps1

# 安装 Starship、复制默认配置并写入当前 PowerShell profile；保留已有 Starship 配置
.\scripts\windows\setup-prompt.ps1
```

以上 Windows 脚本用于原生 PowerShell 环境。WSL2 暂无自动初始化脚本，按 [WSL2 指南](docs/development/windows-wsl-devcontainers.md)手动配置。

## 还需手动完成，然后验收

- **Git**：将认证公钥添加到 GitHub / Gitee；若启用签名，将签名公钥另加为 GitHub Signing Key。
- **编辑器与终端**：按 [VS Code 设置示例](docs/editor/vscode-terminal.md#2-vs-code-用户设置)合并用户设置，选择字体和主题；按需登录 Settings Sync。
- **可选工具**：分别启动 `codex`、`claude` 登录；安装 Starship 后重开终端。

完整操作见[手动配置清单](docs/getting-started/manual-configuration.md)。基础安装如有失败汇总，先修复并重跑；找不到 `code` 时，按 [VS Code 指南](docs/editor/vscode-terminal.md#1-安装常用-vs-code-扩展)配置 PATH。最后在仓库根目录执行当前系统的检查命令：

macOS：

```bash
# 只读检查工具、Git/Shell 配置和 Docker 连接，不安装软件或修改配置
bash scripts/macos/check.sh
```

Windows PowerShell：

```powershell
# 只读检查工具、Git/Shell 配置和 Docker 连接，不安装软件或修改配置
.\scripts\windows\check.ps1
```

检查结果按[验收指南](docs/getting-started/validation.md)确认。每个脚本的前提、写入位置和重跑行为见[脚本清单](docs/getting-started/scripts.md)；获取仓库到创建项目的完整流程见[初始化指南](docs/getting-started/new-computer-setup.md)。

## 目录与文档导航

```text
dev-env/
├── README.md                 # 入口与导航
├── docs/                     # 使用文档，按主题分类
│   ├── getting-started/      # 初始化、脚本清单、手动配置、验收
│   ├── git/                  # Git 身份、SSH、签名与双平台同步
│   ├── development/          # mise、Docker、WSL2 与项目环境
│   ├── editor/               # VS Code、字体与终端提示符
│   └── ai/                   # Codex 与 Claude Code
├── scripts/                  # 可执行脚本，按操作系统分类
│   ├── macos/
│   └── windows/
├── configs/                  # 供脚本使用的默认配置
│   └── starship.toml
└── .github/workflows/        # 脚本语法检查
```

| 主题 | 文档 |
| --- | --- |
| 初始化与验收 | [完整步骤](docs/getting-started/new-computer-setup.md) · [脚本清单](docs/getting-started/scripts.md) · [手动配置](docs/getting-started/manual-configuration.md) · [验收与排查](docs/getting-started/validation.md) |
| Git | [配置入口](docs/git/README.md) · [SSH](docs/git/github-ssh.md) · [签名提交](docs/git/signed-commits.md) · [GitHub / Gitee 同步](docs/git/github-gitee-sync.md) |
| 项目环境 | [mise](docs/development/mise.md) · [Docker 与 Dev Containers](docs/development/docker-devcontainers.md) · [Windows / WSL2](docs/development/windows-wsl-devcontainers.md) |
| 编辑器与终端 | [VS Code 与终端](docs/editor/vscode-terminal.md) · [字体](docs/editor/fonts.md) · [Starship](docs/editor/starship.md) |
| AI Coding | [Codex 与 Claude Code](docs/ai/ai-coding.md) |

## 目录与开发约定

- macOS / Linux / WSL2 的项目放在 `~/code/project-name`；Windows 原生项目放在 `$HOME\code\project-name`。
- WSL2 项目放在 Linux 内部的 `~/code`，通过工作区挂载进入 Dev Container。
- 宿主机安装通用工具；项目语言版本和依赖由 `mise.toml`、`pyproject.toml` 等项目配置固定。
- 复杂项目按需使用 Dev Containers；数据库、Redis 等服务优先用项目的 Docker Compose 隔离。
- 安装脚本不代替账号登录，不提交访问令牌、SSH 私钥或生产凭据。

新增教程放入对应的 `docs/` 主题目录；新增脚本放入对应系统的 `scripts/` 并更新脚本清单；可复用的默认配置放入 `configs/`。

