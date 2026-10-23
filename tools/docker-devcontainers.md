# Docker 与 Dev Containers

## 职责划分

- 宿主机：Docker Desktop、VS Code、微信开发者工具，以及需要访问桌面或设备的应用。
- 项目目录：所有仓库统一放在 `~/code` 下；Windows 原生使用 `$HOME\code`，WSL2 使用 WSL 内部的 `~/code`。
- Windows + Linux 开发：推荐使用 Docker Desktop 的 WSL2 backend，并把项目源码放在 WSL2 的 Linux 文件系统中。
- 项目容器：项目需要的 Linux 工具链、语言运行时和依赖。
- Docker Compose：启动项目依赖的 Redis、数据库和其他微服务。
- 项目仓库：保存 `.devcontainer/`、Dockerfile、Compose 和锁文件，保证换电脑后可重建。

## 推荐方式

- macOS：Docker Desktop + VS Code + Dev Containers。
- Windows：Docker Desktop（WSL2 backend）+ Ubuntu on WSL2 + VS Code Remote - WSL / Dev Containers。完整步骤见 [Windows WSL2 指南](./windows-wsl-devcontainers.md)。
- 正式项目：优先考虑 Dev Container。
- 简单的一次性脚本：直接使用本机工具即可，不强制容器化。
- 微服务：每个系统用自己的 Compose 网络和依赖；跨项目共享服务时再显式配置共享网络。
- 不要将 SSH 私钥、访问令牌或生产凭据写入镜像或提交到仓库。

## 工作区挂载

在 VS Code 中打开 `~/code/project-name` 后，执行 **Dev Containers: Reopen in Container**。如果项目提供有效的 `.devcontainer/devcontainer.json`，VS Code 会按项目配置构建/启动容器并挂载工作区。

代码通常保存在宿主机工作区中，通过 bind mount 供容器使用；容器不是每次都复制一份源代码。Windows + WSL2 时，工作区应位于 WSL 的 Linux 文件系统中。容器内创建的环境和依赖应通过 Dockerfile、Dev Container Features、锁文件及初始化命令重建。不要只在容器里手工安装依赖后就认为环境可复现。

## 多环境边界

Windows PowerShell、WSL2 和 Dev Container 的 PATH、用户目录、Git/SSH 配置与 CLI 安装相互独立。一个环境里的 `codex`、`claude` 或 SSH key 不会自动出现在另一个环境。先决定在哪里运行 Git 和 AI CLI，再只配置需要的那一层。

不要将 SSH 私钥、访问令牌或生产凭据写入镜像、提交到仓库，或为图方便挂载整个宿主机用户目录。

官方资料：[Dev Containers 文档](https://code.visualstudio.com/docs/devcontainers/containers) · [Docker Desktop WSL2 backend](https://docs.docker.com/desktop/features/wsl/) · [Docker Compose](https://docs.docker.com/compose/)。
