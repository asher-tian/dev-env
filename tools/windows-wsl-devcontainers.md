# Windows WSL2 与 Dev Containers

目标：Windows 负责桌面应用，WSL2 提供 Linux 开发入口，Dev Container 固定项目工具链。不要把 Windows、WSL2 和容器当成同一个环境；它们的 PATH、SSH 配置、运行时和用户目录相互独立。

## 推荐架构

```text
Windows
├── VS Code（桌面 UI）
├── Docker Desktop（WSL2 backend）
├── Windows Terminal
└── 微信开发者工具（GUI）
    │
    └── WSL2：Ubuntu（源码放在 Linux 文件系统）
        ├── Git / SSH（WSL 用户配置）
        ├── VS Code Remote - WSL
        └── Dev Containers
            └── 项目工具链：Python / Node.js / Go / CLI agents（按项目需要）
```

所有代码仓库统一放在 `~/code` 下。Windows + WSL2 开发时，这里指 **WSL2 Ubuntu 内部的 `~/code`**，例如 `~/code/myapp`。不要把频繁编译的 Linux 项目长期放在 `/mnt/c/...`。通过 VS Code 的 WSL / Dev Containers 扩展打开项目，不需要手工把目录复制进容器。

## 1. Windows 宿主机

安装并启动：

- [WSL 安装说明](https://learn.microsoft.com/windows/wsl/install)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/)
- [Windows Terminal](https://aka.ms/terminal)

在管理员 PowerShell 执行一次：

```powershell
wsl --install
```

按提示重启电脑，并完成 Ubuntu 首次初始化。查看 WSL 状态：

```powershell
wsl --status
wsl -l -v
```

确认 Ubuntu 使用 WSL 2。Docker Desktop → Settings → General 启用 **Use the WSL 2 based engine**；Settings → Resources → WSL Integration 中启用对应的 Ubuntu 发行版。菜单名称可能随版本略有变化。

不要同时在 WSL 内另装一套 Docker Engine，除非你明确要维护独立的 Docker daemon。

## 2. 在 Ubuntu（WSL2）中配置开发入口

从 Windows Terminal 打开 Ubuntu，然后执行：

```bash
sudo apt update
sudo apt install -y git curl ca-certificates
mkdir -p ~/code
cd ~/code
```

安装完成后，建议在 WSL 终端中运行仓库的 Linux 初始化流程。该流程目前以 macOS 为主要脚本目标，因此 **不要在 WSL 中照搬 macOS 的 Homebrew 脚本**；先按官方说明安装 mise、uv，以及需要的 CLI 工具：

- [mise 安装](https://mise.jdx.dev/getting-started.html)
- [uv 安装](https://docs.astral.sh/uv/getting-started/installation/)
- [VS Code WSL 教程](https://code.visualstudio.com/docs/remote/wsl)

从 WSL 项目目录运行：

```bash
code .
```

VS Code 桌面窗口会连接到 WSL。首次按提示安装 **WSL** 扩展。打开 Extensions 时注意区分本地扩展与 “WSL: Ubuntu” 远程扩展。

## 3. Git 和 SSH：只配置你实际使用的那一层

若项目位于 WSL 的 `~/code` 中，并从 WSL / Dev Container 执行 Git，推荐把 Git 身份和 SSH 认证配置在 WSL 用户环境中。Windows PowerShell 的 `C:\Users\...\.ssh` 与 WSL 的 `~/.ssh` 不是同一个目录。

在 WSL 运行：

```bash
git config --global user.name
git config --global user.email
ssh -T git@github.com
```

若还没有密钥，按本仓库 [Git 配置指南](../git-config/README.md)的步骤生成并将公钥添加到 GitHub。不要将私钥复制进镜像、提交到仓库或放进 Docker build context。

如果只在 Windows PowerShell 中开发，才使用 Windows 的 Git/SSH 配置。两边不必都配置，除非两边都会独立操作仓库。

## 4. Dev Container 的代码和依赖

项目需要提供 `.devcontainer/devcontainer.json`，通常搭配 Dockerfile 或 Compose。VS Code 执行 **Dev Containers: Reopen in Container** 后会按配置构建/启动容器，并将工作区挂载进去；工作区源文件仍保存在 WSL 的 `~/code/project-name` 中，不是每次创建容器都复制一份代码。

- 代码、Git 历史：WSL 的项目目录（通过工作区挂载进入容器）。
- 编译器、语言运行时、项目依赖：容器内。
- Redis、数据库等开发服务：项目的 Docker Compose 服务。
- Windows GUI 应用：宿主机，例如微信开发者工具。
- 用户级凭据：只放在使用它们的执行环境中，并通过安全登录或明确的本机挂载持久化。

容器重建后，容器可写层中的临时内容可能丢失。项目依赖应通过 Dockerfile、Dev Container Features、锁文件和初始化命令重建，不要靠手动安装后忘记记录。

## 5. Codex 与 Claude Code 放在哪里？

先区分两个使用方式：

### 方式 A：在 WSL 终端运行 CLI（适合从 WSL 操作项目）

在 WSL 中安装并登录 Codex / Claude Code。CLI 直接访问 WSL 工作区；需要执行项目工具时，再按项目说明运行命令或进入容器。

- CLI 程序和登录状态在 WSL 用户目录。
- 项目依赖可以仍然只安装在 Dev Container。
- 如果 agent 需要在容器内执行测试，项目应提供明确的命令，例如 `docker compose exec app pytest`，或改用方式 B。

### 方式 B：在 Dev Container 内运行 CLI（工具链边界最一致）

在项目的 Dev Container 配置中声明所需 CLI 的安装步骤，并在容器终端中运行。不要在 Dockerfile 中写入 API Key、访问令牌或个人登录缓存。

容器重建后，登录状态可能消失。要持久化认证，需要设计安全的配置目录挂载或使用工具支持的重新登录流程；**不要直接挂载整个宿主机用户目录，也不要把认证目录提交到 Git**。共享容器配置前先检查 agent 的信任和权限模型。

Codex / Claude Code 的安装和认证方式可能随版本变化，应以各自官方文档为准：

- [Codex 文档](https://developers.openai.com/codex/)
- [Claude Code 文档](https://docs.anthropic.com/en/docs/claude-code/overview)

注意：在 Windows PowerShell 安装的 CLI，不会自动出现在 WSL 或 Linux Dev Container 里；安装在 WSL 的 CLI，也不会自动出现在容器里。VS Code 扩展和 CLI 是两种不同的安装目标。

## 6. 常见问题

- **容器里看不到代码**：确认 VS Code 左下角显示的是正确的 WSL / Dev Container 远程目标，检查工作区是否打开了预期目录。
- **容器里找不到 GitHub SSH key**：确认 Git 操作实际在哪一层执行；不要假设 Windows、WSL 和容器共享 `~/.ssh`。
- **Docker 命令连接失败**：先在 Windows 启动 Docker Desktop，再检查 WSL Integration；不要立刻安装第二套 Docker daemon。
- **文件操作慢**：把项目放在 WSL 的 `~/code`，避免在 `/mnt/c` 下频繁构建 Linux 项目。
- **容器重建后依赖消失**：把依赖安装步骤写入项目的 Dev Container 配置或锁文件，不要只在容器里手工安装。
- **微信小程序开发**：微信开发者工具保留在 Windows 宿主机。若它需要读取项目源码，可从 Windows 侧通过 `\\wsl$\Ubuntu\home\<用户名>\code\...` 访问，但文件监听/性能行为需要在实际项目中验证；不要为了它默认把所有代码搬到 `/mnt/c`。

## 官方资料

- [WSL 安装](https://learn.microsoft.com/windows/wsl/install)
- [Docker Desktop WSL 2 backend](https://docs.docker.com/desktop/features/wsl/)
- [VS Code WSL](https://code.visualstudio.com/docs/remote/wsl)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
