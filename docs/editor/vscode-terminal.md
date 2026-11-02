# VS Code 与终端配置

目标：Windows / macOS 使用相同的编辑器主题、字体和常用扩展，尽量少做手工配置。

## 推荐组合

- 统一主题：Catppuccin Mocha（Windows Terminal、VS Code、Starship）。
- 强调色：Mauve。
- 字体：Maple Mono NF CN，见[字体指南](fonts.md)。
- Python：Python 扩展 + Pylance 负责语言服务，Ruff 负责格式化、Lint 和导入排序。
- macOS 终端：iTerm2。
- Windows 终端：Windows Terminal。
- VS Code 设置同步：使用内置 Settings Sync 同步设置、扩展和快捷键。

主题官方项目：[Catppuccin for VS Code](https://github.com/catppuccin/vscode)。

## 1. 安装常用 VS Code 扩展

扩展清单统一维护在 `configs/vscode/extensions.txt`，Windows 和 macOS 安装脚本都读取这份清单，不再分别维护插件 ID。清单包含：

| 类别 | 扩展 |
| --- | --- |
| 主题 | Catppuccin |
| 前端 | Vue - Official |
| 后端 | Go |
| Python | Python、Pylance、Ruff |
| 容器 | Docker、Dev Containers |
| AI Coding | GitHub Copilot、Claude Code |

在仓库根目录执行对应脚本，安装或更新清单中的扩展。

macOS：

```bash
bash scripts/macos/setup-vscode.sh
```

Windows PowerShell：

```powershell
.\\scripts\\windows\\setup-vscode.ps1
```

脚本会继续处理其他扩展，并在结束时汇总安装失败项；网络恢复后重新运行即可重试。GitHub Copilot 和 Claude Code 需要分别完成账号登录。Copilot Chat 会随 GitHub Copilot 扩展安装，无需重复列入清单。

微信小程序项目继续使用微信开发者工具；如果某个项目确实需要额外的 VS Code 扩展，再按项目需求安装，不将临时或项目专用扩展加入全局基础清单。

如果提示找不到 `code` 命令：
- macOS：在 VS Code 命令面板运行 **Shell Command: Install 'code' command in PATH**，再重新打开终端。
- Windows：重新打开终端；仍找不到时，在安装 VS Code 时确认启用了 PATH 集成。

## 2. VS Code 用户设置

在 VS Code 中打开命令面板，运行 **Preferences: Open User Settings (JSON)**，合并以下配置。仓库也提供片段 `configs/vscode/settings.fragment.jsonc`。不要覆盖已有设置；如果文件里已有同名键，保留一份并合并。

```json
{
  "workbench.colorTheme": "Catppuccin Mocha",
  "catppuccin.accentColor": "mauve",
  "editor.fontFamily": "'Maple Mono NF CN', 'SF Mono', Menlo, Consolas, monospace",
  "editor.fontSize": 17,
  "editor.fontWeight": "400",
  "editor.fontLigatures": true,
  "editor.lineHeight": 28,
  "editor.letterSpacing": 0.3,
  "editor.minimap.enabled": false,

  "editor.smoothScrolling": true,
  "workbench.list.smoothScrolling": true,
  "editor.cursorSmoothCaretAnimation": "on",
  "editor.cursorBlinking": "smooth",

  "editor.formatOnSave": true,

  "terminal.integrated.fontFamily": "'Maple Mono NF CN'",
  "terminal.integrated.fontSize": 16,
  "terminal.integrated.lineHeight": 1.2,

  "python.analysis.typeCheckingMode": "basic",

  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.codeActionsOnSave": {
      "source.fixAll.ruff": "explicit",
      "source.organizeImports.ruff": "explicit"
    }
  },
  "[go]": {
    "editor.defaultFormatter": "golang.go"
  },
  "[vue]": {
    "editor.defaultFormatter": "Vue.volar"
  }
}
```

说明：

- `editor.formatOnSave`：保存时自动格式化。Python 使用 Ruff，Go 使用 Go 扩展提供的格式化能力；Vue 格式化器应根据项目实际工具链确认。
- `source.fixAll.ruff`：保存时应用 Ruff 可自动修复的问题。默认不会应用 Ruff 标记为不安全的自动修复。
- `source.organizeImports.ruff`：保存时整理 Python 导入语句。若要让命令行 Ruff 与编辑器行为一致，需要在项目的 `pyproject.toml` 或 Ruff 配置中启用相应的导入排序规则（通常为 `I`）。
- `python.analysis.typeCheckingMode: basic`：启用 Pylance 基础类型检查。它与 Ruff 的 lint 检查职责不同；若某个项目需要更严格或更宽松的检查，应由项目单独配置。
- 以上代码动作只针对 Python，并明确指定 Ruff，避免其他扩展重复执行 Fix All 或导入整理。
- 项目需要统一的工具版本和格式化规则时，应在项目配置中维护，例如使用 `pyproject.toml` 配置 Ruff；不要依赖个人 User Settings 来代替项目规范。

如果 VS Code 没有找到字体，请先安装 [Maple Mono NF CN](fonts.md)，然后重启 VS Code。

## 3. Python 工具职责

为避免重复检查或保存时互相修改代码，统一采用以下分工：

| 工具 | 职责 | 不负责 |
| --- | --- | --- |
| Python 扩展 | 解释器选择、运行与调试、测试集成 | 代码格式化和主要 lint 规则 |
| Pylance | IntelliSense、跳转、补全、类型分析 | Ruff 格式化和 Ruff lint |
| Ruff Formatter | 统一代码排版 | 类型检查 |
| Ruff Linter | 代码规则检查及安全的自动修复 | 替代 Pylance 的语言服务 |
| Ruff import sorting | 整理导入顺序、分组 | 管理项目依赖 |

约定：

- 不再额外安装 Black 或 isort 来做同一项工作，除非某个项目明确要求。
- Ruff 格式化、Lint 和导入排序规则以项目的 `pyproject.toml` 或 Ruff 配置文件为准。
- 自动修复可能改变代码，应先在项目中确认 Ruff 规则；Ruff 默认不会在 Fix All 中应用不安全修复。
- 若项目使用不同的工具链，可以通过项目级配置覆盖个人设置。

## 4. 启用设置同步

在 VS Code 左下角管理菜单或账户菜单中选择 **Backup and Sync Settings...**，登录 Microsoft 或 GitHub 账号，然后选择同步设置、扩展、快捷键和配置文件。

官方文档：[VS Code Settings Sync](https://code.visualstudio.com/docs/configure/settings-sync)。

注意：Settings Sync 不会安装操作系统字体，也不会同步 Dev Container / WSL / SSH 远程环境里的扩展。连接容器后，按项目提示安装容器内需要的扩展。

## 5. 终端主题与字体

### macOS / iTerm2

1. 打开 iTerm2 → Settings → Profiles → Text，将字体设为 `Maple Mono NF CN`。
2. 在 Profiles → Colors 中导入 [Catppuccin Mocha for iTerm2](https://github.com/catppuccin/iterm) 的配色。
3. 将该配色设为当前 Profile 的默认颜色方案。

### Windows / Windows Terminal

仓库提供可合并的配置片段：`configs/windows-terminal/settings.fragment.jsonc`。它不是完整的 `settings.json`，不要用它覆盖 Windows Terminal 原配置。

1. 打开 Windows Terminal → Settings → Open JSON file。
2. 将片段中的 `schemes` 数组内容合并到原文件的 `schemes` 数组。
3. 将 `themes` 数组内容合并到原文件的 `themes` 数组。
4. 将 `profiles.defaults` 中的设置合并到原文件的 `profiles.defaults`。
5. 合并根节点的 `launchMode`、`initialCols`、`initialRows`。
6. 将 `keybindings` 数组中的项目合并到原文件的 `keybindings` 数组；如果某个快捷键已存在，先删除旧绑定，避免冲突。

默认参数：Catppuccin Mocha、Maple Mono NF CN、14 号字体、14 内边距、160 列 × 40 行、最大化启动。最大化启动时，初始列数和行数不会决定最终窗口尺寸。

#### Windows Terminal 快捷键

本仓库使用普通 Windows Terminal 窗口，不启用 Quake Mode，也不依赖 Winguake 等额外窗口管理工具。

| 快捷键 | 动作 | 说明 |
| --- | --- | --- |
| `Ctrl + D` | Split Pane Right | 在当前终端右侧创建一个新分屏 |
| `Ctrl + W` | Close Pane | 关闭当前焦点分屏；关闭最后一个分屏时会关闭当前标签页 |
| `Ctrl + C` | Copy to Clipboard | 有选区时复制；没有选区时将 Ctrl+C 传给 Shell，可中断当前命令 |
| `Ctrl + V` | Paste from Clipboard | 粘贴剪贴板内容 |

使用说明：

- 正常启动和使用 Windows Terminal，不需要先打开 Quake 窗口，也不需要额外安装窗口管理工具。
- `Ctrl + D` 在当前分屏右侧创建新分屏；连续按下可以逐个增加左右分屏。
- `Ctrl + W` 绑定 `Terminal.ClosePane`，只关闭当前焦点分屏，不会一次关闭同一标签页中的所有分屏。
- `Ctrl + C` 绑定 Windows Terminal 的 Copy 动作：有文本选区时复制，没有选区时快捷键会直接传给 Shell，因此仍可用于中断当前命令。
- `Ctrl + V` 保持粘贴行为。

官方主题：[Catppuccin Windows Terminal](https://github.com/catppuccin/windows-terminal)。仓库配置片段基于其 Mocha 色板和 UI 主题。

Windows Terminal 官方配置：[启动设置](https://learn.microsoft.com/windows/terminal/customize-settings/startup) · [快捷键与动作](https://learn.microsoft.com/windows/terminal/customize-settings/actions) · [外观设置](https://learn.microsoft.com/windows/terminal/customize-settings/profile-appearance) · [配色方案](https://learn.microsoft.com/windows/terminal/customize-settings/color-schemes)。

## 6. 主题统一约定

Windows Terminal、VS Code 和 Starship 统一使用 Catppuccin Mocha；Starship 的颜色定义在 `configs/starship.toml`，Windows Terminal 与 VS Code 的配置片段分别位于 `configs/windows-terminal/` 和 `configs/vscode/`。颜色主题统一，字体大小可根据编辑器和终端的阅读距离分别调整。

## 7. 保持简单

- 先使用同一套字体和深色主题，不急着折腾复杂的 Shell 插件。
- iTerm2 / Windows Terminal 是宿主机终端；进入 Dev Container 后，VS Code 会使用容器里的 Shell。
- 终端外观与项目配置分开管理，不要把个人主题和字体写进项目仓库。
