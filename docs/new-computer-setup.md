# 新电脑初始化

目标：用尽量少的手工操作，准备好 Git、VS Code、Docker、mise 和 uv；项目运行时再按项目配置安装语言版本与依赖。

## 1. 获取仓库

先安装 Git，或先从 GitHub 下载仓库 ZIP。已有 Git 时执行：

```bash
git clone https://github.com/asher-tian/dev-env.git
cd dev-env
```

## 2. 运行初始化脚本

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

## 3. 自动配置 Git

### macOS

```bash
bash git-config/setup-macos.sh
```

### Windows（PowerShell）

```powershell
.\git-config\setup-windows.ps1
```

脚本会设置 Git 提交身份、生成 SSH 认证密钥，并询问是否启用 GitHub Verified 签名提交。按脚本最后显示的链接，将公钥添加到 GitHub / Gitee。不要上传私钥。

详细说明：[Git 配置指南](../git-config/README.md)。

## 4. 使用项目模板

`dev-env` 负责电脑和通用工具；项目模板单独维护在 [dev-templates](https://github.com/asher-tian/dev-templates)。

```bash
git clone https://github.com/asher-tian/dev-templates.git
copier copy ./dev-templates/python-cli ./my-cli
```

Copier 官方资料：[文档](https://copier.readthedocs.io/) · [GitHub](https://github.com/copier-org/copier)。

## 5. 开发原则

- 项目语言版本由项目配置决定，不在初始化脚本里安装所有 Python、Node.js、Go 版本。
- 优先使用 Dev Containers 固定复杂项目的 Linux 开发环境；简单的一次性脚本不强制容器化。
- Redis、数据库等依赖由项目的 Docker Compose 管理，除非确实需要共享服务。
- Codex、Claude Code 和微信开发者工具按实际使用需求单独安装并登录。
