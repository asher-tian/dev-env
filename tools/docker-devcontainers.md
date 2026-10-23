# Docker 与 Dev Containers

## 职责划分

- 宿主机：Docker Desktop、VS Code、微信开发者工具，以及需要访问桌面或设备的应用。
- 项目容器：项目需要的 Linux 工具链、语言运行时和依赖。
- Docker Compose：启动项目依赖的 Redis、数据库和其他微服务。
- 项目仓库：保存 `.devcontainer/`、Dockerfile、Compose 和锁文件，保证换电脑后可重建。

## 推荐方式

- 正式项目：优先考虑 Dev Container。
- 简单的一次性脚本：直接使用本机工具即可，不强制容器化。
- 微服务：每个系统用自己的 Compose 网络和依赖；跨项目共享服务时再显式配置共享网络。
- 不要将 SSH 私钥、访问令牌或生产凭据写入镜像或提交到仓库。

在 VS Code 中打开项目后，执行 **Dev Containers: Reopen in Container**。如果项目提供了有效的 `.devcontainer/devcontainer.json`，VS Code 会按项目配置构建/启动容器并挂载工作区。

官方资料：[Dev Containers 文档](https://code.visualstudio.com/docs/devcontainers/containers) · [Docker Compose](https://docs.docker.com/compose/)。
