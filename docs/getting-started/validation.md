# 开发环境验收

初始化脚本执行后，用一条命令快速检查工具和配置。**检查脚本只读取当前环境，不安装软件、不修改配置、不读取私钥内容。**

执行前先完成[手动配置清单](manual-configuration.md)。

## 运行

在 `dev-env` 仓库根目录执行：

**macOS**

```bash
bash scripts/macos/check.sh
```

**Windows PowerShell**

```powershell
.\scripts\windows\check.ps1
```

`[OK]` 表示检查通过；`[检查]` 表示可能缺少配置、软件未安装或没有加入 PATH。可选工具缺失不一定是问题。

## 首次使用必须手动确认

1. **Docker**：启动 Docker Desktop，执行 `docker version`；创建一个 Dev Container 项目，确认 VS Code 可以执行 **Dev Containers: Reopen in Container**。
2. **Git SSH**：添加认证公钥到 GitHub / Gitee 后，分别执行 `ssh -T git@github.com` 和 `ssh -T git@gitee.com`。首次连接先核实主机指纹。
3. **Git 签名（可选）**：确认公钥已添加为 GitHub Signing Key，再从测试仓库提交并验证 Verified 状态。
4. **AI Coding（可选）**：`codex --version`、`claude --version`；首次启动按官方流程登录。验证能在目标项目目录读取代码并运行测试。
5. **VS Code**：打开项目并检查 Catppuccin Mocha、扩展、终端字体；字体应正确显示中文与 Nerd Font 图标。
6. **项目模板**：生成一个 `python-cli` 项目，运行 `uv sync`、`uv run pytest` 和 Ruff 检查，进入 Dev Container 后再运行一次。

## 排查顺序

- **找不到命令**：安装后重新打开终端；确认 PATH。
- **Docker 连接失败**：检查 Docker Desktop 是否已经启动，以及 Windows 的 WSL2 后端。
- **VS Code 没有连接容器**：确认已安装 Dev Containers 扩展、工作区中包含 `.devcontainer/devcontainer.json`。
- **GitHub SSH 失败**：检查本地公钥是否已添加到 GitHub，SSH config 是否引用正确密钥；不要上传私钥。
- **签名失败**：确认 Git 提交邮箱与 GitHub 验证邮箱匹配，签名公钥已登记为 Signing Key。
- **字体方框或缺字**：确认安装的是 **Maple Mono NF CN**，然后重启 VS Code / 终端。

Windows 原生和 WSL2 的工具链、Shell、Git/SSH 配置可能是两套独立环境。当前脚本检查的是 **Windows PowerShell 原生环境**，不等于 WSL2 内环境已经配置完成。

## 测试范围

脚本用于日常自检，不等同于 Windows / macOS 实机端到端验证。需在实际设备上运行并依据输出修复问题。
