# Codex 与 Claude Code

本仓库提供可选安装脚本。安装后需要自行登录账号。

## 一键安装

在 `dev-env` 仓库根目录运行。

### macOS

```bash
bash tools/setup-ai-coding-macos.sh
```

### Windows（PowerShell 原生环境）

```powershell
.\tools\setup-ai-coding-windows.ps1
```

脚本只负责安装，不会自动登录或复制认证信息。

## 首次启动

进入你的项目目录后运行：

```bash
codex
claude
```

按工具提示完成登录。Codex 可选择使用 ChatGPT 账号登录；Claude Code 按你的 Claude 账号或组织授权方式登录。

检查安装：

```bash
codex --version
claude --version
```

Claude Code 诊断：

```bash
claude doctor
```

## Windows、WSL2 与 Dev Container

这三个环境是独立的：

- 在 Windows PowerShell 安装的 CLI，只能保证在 Windows 环境可用。
- 在 WSL Ubuntu 安装的 CLI，属于 WSL 用户环境。
- 在 Dev Container 中运行 CLI，需要在容器内安装该 CLI。

同样，Git 配置、SSH 密钥路径、PATH 和用户级认证配置也不会自动共享。Windows + WSL2 的推荐架构和 Git/SSH 配置见 [Windows WSL2 与 Dev Containers 指南](./windows-wsl-devcontainers.md)。

若选择在容器内运行 CLI，把安装步骤写进项目的 Dev Container 配置，但不要把 API Key、访问令牌或个人登录缓存写进镜像或 Git。容器重建后认证状态可能需要重新登录；只有在理解工具的凭据存储机制并采用安全挂载后，才考虑持久化认证目录。不要为方便直接挂载整个宿主机用户目录。

## 配置放在哪里？

| 配置类型 | 放置位置 | 用途 |
|---|---|---|
| 用户级配置 | 工具各自的用户配置目录 | 个人偏好、界面设置、全局权限等 |
| 项目级规范 | 项目根目录的 `AGENTS.md` | Codex 和其他兼容工具可读取的项目协作规则 |
| Claude Code 项目规则 | 项目根目录的 `CLAUDE.md` | Claude Code 专用项目说明 |
| 项目工具版本 | `mise.toml`、`pyproject.toml`、`package.json` 等 | 让不同电脑使用一致的工具和依赖版本 |

不要把个人令牌、API Key、登录缓存或私密配置提交到 Git。用户级配置不建议直接放进公共仓库。

## 项目中的 AI 规则

建议在项目根目录维护简洁的 `AGENTS.md`，写清楚：

- 项目结构与主要技术栈
- 如何安装依赖、运行程序和测试
- 代码风格与目录约定
- 修改完成前必须执行的检查
- 不要提交密钥、环境变量文件和生产凭据

Claude Code 需要专用规则时，再添加 `CLAUDE.md`。不要在多个文件里复制大量重复内容。

你在 [dev-templates](https://github.com/asher-tian/dev-templates) 的 Python CLI 模板中维护共享的 `AGENTS.md`；模板里的 `CLAUDE.md` 引用它，让 Claude Code 也遵循同一份规范。后续项目规则应继续维护在模板或具体项目中，而不是复制到本仓库。

## 官方文档

- [Codex CLI 官方仓库与安装说明](https://github.com/openai/codex)
- [Codex 文档](https://developers.openai.com/codex/)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Claude Code 官方安装说明](https://docs.anthropic.com/en/docs/claude-code/setup)
