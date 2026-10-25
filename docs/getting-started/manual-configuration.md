# 手动配置清单

[返回入口](../../README.md) · [脚本清单](scripts.md) · [验收与排查](validation.md)

脚本负责安装与部分本地配置。下面按执行阶段列出需要自己处理的事项；可选功能只有使用时才需配置。

## 运行脚本前

- [ ] macOS：安装 Homebrew；Windows 原生：安装或更新 App Installer / winget。
- [ ] 获取完整仓库并进入根目录。没有 Git 时先下载 ZIP，操作见[初始化指南](new-computer-setup.md#1-获取仓库)。
- [ ] Windows 字体脚本需要 Scoop，基础安装脚本不会安装它。
- [ ] 选择实际开发环境：Windows 原生、WSL2 或容器。WSL2 没有本仓库的一键安装脚本，按 [WSL2 指南](../development/windows-wsl-devcontainers.md)配置，不运行 macOS 脚本。

## 基础脚本执行后

- [ ] 重新打开终端，回到仓库根目录；完成 VS Code、Docker Desktop 等应用的首次启动提示。
- [ ] 启动 Docker Desktop，运行 `docker version` 确认客户端能连接服务端。
- [ ] 如 `code` 不可用，macOS 在 VS Code 命令面板执行 **Shell Command: Install 'code' command in PATH**；Windows 检查安装时的 PATH 集成，然后重开终端。

## Git 身份、平台认证与签名

- [ ] 执行 Git 脚本时输入昵称和已在平台验证的提交邮箱，按提示选择密钥 passphrase 和是否启用签名。
- [ ] 把 `id_ed25519_git.pub` 登记到需要使用的 GitHub / Gitee 账号，操作见 [SSH 指南](../git/github-ssh.md)。只上传公钥。
- [ ] 首次 SSH 连接核实主机指纹，再分别执行 `ssh -T git@github.com`、`ssh -T git@gitee.com`，以平台返回的认证消息判断成功。两条命令单独执行。
- [ ] 若启用签名，将 `id_ed25519_signing.pub` 单独登记为 GitHub Signing Key，并在测试提交后确认 Verified，见[签名指南](../git/signed-commits.md)。
- [ ] 若需要双平台同步，在平台创建仓库并为具体项目配置远程地址，见[双平台同步](../git/github-gitee-sync.md)。初始化脚本不会创建远程仓库。

## AI CLI（可选）

- [ ] 安装后重开终端，检查 `codex --version`、`claude --version`，分别启动并按提示登录。
- [ ] 在实际运行 CLI 的 Windows、WSL2 或容器环境内完成安装和登录；各环境不自动共享安装和认证。
- [ ] 个人偏好在用户配置中维护；项目协作规则放入项目的 `AGENTS.md` / `CLAUDE.md`，见 [AI Coding 指南](../ai/ai-coding.md)。

## 编辑器、字体与终端

- [ ] 字体安装后重启 VS Code 和终端。
- [ ] 在 VS Code 打开 **Preferences: Open User Settings (JSON)**，按 [VS Code 与终端指南](../editor/vscode-terminal.md#2-vs-code-用户设置)合并主题、字体及格式化设置；该文档是用户设置示例的统一维护位置。
- [ ] 在 iTerm2 或 Windows Terminal 的外观设置中选择 `Maple Mono NF CN`，按需设置终端配色。
- [ ] 如需同步，登录 VS Code Settings Sync 并选择同步项；字体仍需在每台电脑安装，远程扩展另行确认。
- [ ] 若安装 Starship，重开终端生效；已有 `starship.toml` 会保留，需采用仓库配置时先备份再手动替换，见 [Starship 指南](../editor/starship.md)。

## WSL2 与项目环境（按需）

- [ ] Windows 使用 WSL2 时，安装 WSL / Ubuntu、重启并完成用户初始化；在 Docker Desktop 启用 WSL2 后端及目标发行版集成，见 [WSL2 指南](../development/windows-wsl-devcontainers.md)。
- [ ] 在实际操作 Git 的环境中配置身份和 SSH；WSL2 内按教程手动配置。
- [ ] 在目标项目中依据 `mise.toml`、`pyproject.toml` 等安装运行时及依赖。本仓库不会安装所有项目的语言版本。
- [ ] 项目提供 Dev Container 配置后，在 VS Code 执行 **Dev Containers: Reopen in Container**；数据库等服务按项目 Compose 配置启动。
- [ ] 微信开发者工具等 GUI 软件按需在宿主机另行安装。

## 完成后

运行[脚本清单](scripts.md)最后一项 `check`，再按[验收指南](validation.md)测试 SSH、容器、字体及实际项目。可选项未启用时，对应 `[检查]` 提示可按实际用途判断。
