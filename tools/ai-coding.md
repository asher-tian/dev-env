# Codex 与 Claude Code

本仓库提供可选安装脚本。安装后需要自行登录账号。

## 一键安装

在 `dev-env` 仓库根目录运行。

### macOS

```bash
bash tools/setup-ai-coding-macos.sh
```

### Windows（PowerShell）

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

你在 [dev-templates](https://github.com/asher-tian/dev-templates) 的项目模板中已经有 `AGENTS.md`，后续应在模板中维护项目级规则，而不是把每个项目的规则写进本仓库。

## 官方文档

- [Codex CLI 官方仓库与安装说明](https://github.com/openai/codex)
- [Codex 文档](https://developers.openai.com/codex/)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Claude Code 官方安装说明](https://docs.anthropic.com/en/docs/claude-code/setup)
