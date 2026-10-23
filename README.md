# dev-env

新电脑初始化与个人开发环境配置。目标是：**操作简单、优先脚本化、项目环境可复现**。

## 新电脑快速开始

1. 打开[新电脑初始化指南](./docs/new-computer-setup.md)。
2. macOS 运行 `bash bootstrap/macos/setup.sh`；Windows 在 PowerShell 运行 `.\bootstrap\windows\setup.ps1`。
3. 运行对应的 [Git 配置脚本](./git-config/README.md)，设置提交身份和 SSH。
4. 运行 [AI Coding 工具安装脚本](./tools/ai-coding.md)，安装 Codex 和 Claude Code。
5. 按[字体配置指南](./tools/fonts.md)安装 Maple Mono NF CN，并配置 VS Code / 终端。
6. 用 [dev-templates](https://github.com/asher-tian/dev-templates) 创建新项目。

## 目录

- [新电脑初始化](./docs/new-computer-setup.md)：从基础软件安装到开始开发。
- [Git 配置](./git-config/README.md)：自动配置脚本、GitHub / Gitee SSH、GitHub Verified 签名提交、双平台同步。
- [mise](./tools/mise.md)：项目级运行时版本管理。
- [Docker 与 Dev Containers](./tools/docker-devcontainers.md)：容器开发与服务依赖的配置约定。
- [Codex 与 Claude Code](./tools/ai-coding.md)：安装、登录、项目规则与配置边界。
- [字体与编辑器显示](./tools/fonts.md)：Maple Mono NF CN、VS Code 和终端字体设置。
- `bootstrap/macos/setup.sh`：macOS 基础工具初始化脚本。
- `bootstrap/windows/setup.ps1`：Windows 基础工具初始化脚本。
- `tools/setup-ai-coding-macos.sh`：macOS AI Coding 工具安装脚本。
- `tools/setup-ai-coding-windows.ps1`：Windows AI Coding 工具安装脚本。
- `tools/install-font-macos.sh`：macOS 字体安装脚本。
- `tools/install-font-windows.ps1`：Windows 字体安装脚本。

## 设计原则

- 宿主机只安装通用工具；项目运行时和依赖优先由项目配置管理。
- 正式项目按需使用 Dev Containers；简单临时脚本不强制容器化。
- 项目语言版本由 `mise.toml`、`pyproject.toml` 等项目配置固定。
- Redis、数据库等服务默认随项目使用 Docker Compose 隔离；确实需要共享时再单独配置。
- Codex、Claude Code、微信开发者工具按需安装并登录，不把账号认证写进初始化脚本。
- 不提交访问令牌、SSH 私钥、密码或生产环境密钥。

## 说明

初始化脚本不会自动登录 GitHub、Gitee、Codex 或 Claude Code。Git 配置脚本只在本机生成密钥、设置 Git，并显示需要手动添加到平台的公钥。
