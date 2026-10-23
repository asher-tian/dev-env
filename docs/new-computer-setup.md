# 新电脑初始化

目标：用尽量少的手工操作，准备好 Git、VS Code、Docker、mise 和 uv；项目运行时再按项目配置安装语言版本与依赖。

## 1. 获取仓库

先安装 Git，或先从 GitHub 下载仓库 ZIP。已有 Git 时执行：

```bash
git clone https://github.com/asher-tian/dev-env.git
cd dev-env
```

## 2. 安装基础工具

### macOS

先安装 [Homebrew](https://brew.sh/)，然后执行：

```bash
bash bootstrap/macos/setup.sh
```

### Windows

安装/更新 [Windows App Installer（winget）](https://aka.ms/getwinget)，打开 PowerShell，在仓库目录执行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\bootstrap\windows\setup.ps1
```

## 3. 配置 Git

macOS：

```bash
bash git-config/setup-macos.sh
```

Windows：

```powershell
.\git-config\setup-windows.ps1
```

按脚本最后显示的链接，将公钥添加到 GitHub / Gitee。不要上传私钥。详细说明见 [Git 配置指南](../git-config/README.md)。

## 4. 安装 AI Coding 工具

macOS：

```bash
bash tools/setup-ai-coding-macos.sh
```

Windows：

```powershell
.\tools\setup-ai-coding-windows.ps1
```

安装完成后，重新打开终端并检查：

```bash
codex --version
claude --version
```

首次运行 `codex` 和 `claude` 时按提示自行登录。配置和项目规则见 [Codex 与 Claude Code 指南](../tools/ai-coding.md)。

## 5. 安装字体并配置 VS Code / 终端

统一使用 Maple Mono NF CN。macOS：

```bash
bash tools/install-font-macos.sh
```

Windows（需先安装 [Scoop](https://scoop.sh/)）：

```powershell
.\tools\install-font-windows.ps1
```

然后按[VS Code 与终端配置指南](../tools/vscode-terminal.md)安装扩展、选择 Catppuccin Mocha 主题并配置字体。

macOS 基础脚本会安装 iTerm2；Windows 基础脚本会安装 Windows Terminal。VS Code 设置可使用内置 Settings Sync 同步到其他电脑。

## 6. 创建项目

项目模板单独维护在 [dev-templates](https://github.com/asher-tian/dev-templates)。

```bash
git clone https://github.com/asher-tian/dev-templates.git
copier copy ./dev-templates/python-cli ./my-cli
```

Copier 官方资料：[文档](https://copier.readthedocs.io/) · [GitHub](https://github.com/copier-org/copier)。

## 7. 开发原则

- 项目语言版本由项目配置决定，不在初始化脚本里安装所有 Python、Node.js、Go 版本。
- 优先使用 Dev Containers 固定复杂项目的 Linux 开发环境；简单的一次性脚本不强制容器化。
- Redis、数据库等依赖由项目的 Docker Compose 管理，除非确实需要共享服务。
- 微信开发者工具按需安装；它需要宿主机 GUI，不放进开发容器。
