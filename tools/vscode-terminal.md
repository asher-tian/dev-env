# VS Code 与终端配置

目标：Windows / macOS 使用相同的编辑器主题、字体和常用扩展，尽量少做手工配置。

## 推荐组合

- VS Code 主题：Catppuccin Mocha（深色）。
- 字体：Maple Mono NF CN，见[字体指南](./fonts.md)。
- macOS 终端：iTerm2。
- Windows 终端：Windows Terminal。
- VS Code 设置同步：使用内置 Settings Sync 同步设置、扩展和快捷键。

主题官方项目：[Catppuccin for VS Code](https://github.com/catppuccin/vscode)。

## 1. 安装常用 VS Code 扩展

在仓库根目录执行对应脚本。

macOS：

```bash
bash tools/setup-vscode-macos.sh
```

Windows PowerShell：

```powershell
.\tools\setup-vscode-windows.ps1
```

脚本安装 Catppuccin 主题，以及 Vue、Go、Python、Ruff、Docker、Dev Containers 扩展。微信小程序项目继续使用微信开发者工具；如果项目需要专用 VS Code 扩展，再按需添加。

如果提示找不到 `code` 命令：
- macOS：在 VS Code 命令面板运行 **Shell Command: Install 'code' command in PATH**，再重新打开终端。
- Windows：重新打开终端；仍找不到时，在安装 VS Code 时确认启用了 PATH 集成。

## 2. VS Code 用户设置

在 VS Code 中打开命令面板，运行 **Preferences: Open User Settings (JSON)**，合并以下配置。不要覆盖已有设置；如果文件里已有同名键，保留一份并合并。

```json
{
  "workbench.colorTheme": "Catppuccin Mocha",
  "editor.fontFamily": "'Maple Mono NF CN', 'SF Mono', Menlo, Consolas, monospace",
  "editor.fontSize": 17,
  "editor.fontWeight": "400",
  "editor.fontLigatures": true,
  "editor.lineHeight": 28,
  "editor.letterSpacing": 0.3,
  "editor.minimap.enabled": false,
  "editor.formatOnSave": true,
  "terminal.integrated.fontFamily": "'Maple Mono NF CN'",
  "terminal.integrated.fontSize": 16,
  "terminal.integrated.lineHeight": 1.2,
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff"
  },
  "[go]": {
    "editor.defaultFormatter": "golang.go"
  },
  "[vue]": {
    "editor.defaultFormatter": "Vue.volar"
  }
}
```

如果 VS Code 没有找到字体，请先安装 [Maple Mono NF CN](./fonts.md)，然后重启 VS Code。

## 3. 启用设置同步

在 VS Code 左下角管理菜单或账户菜单中选择 **Backup and Sync Settings...**，登录 Microsoft 或 GitHub 账号，然后选择同步设置、扩展、快捷键和配置文件。

官方文档：[VS Code Settings Sync](https://code.visualstudio.com/docs/configure/settings-sync)。

注意：Settings Sync 不会安装操作系统字体，也不会同步 Dev Container / WSL / SSH 远程环境里的扩展。连接容器后，按项目提示安装容器内需要的扩展。

## 4. 终端主题与字体

### macOS / iTerm2

1. 打开 iTerm2 → Settings → Profiles → Text，将字体设为 `Maple Mono NF CN`。
2. 在 Profiles → Colors 中选择或导入配色。
3. 建议先使用 iTerm2 内置配色；想与 VS Code 统一时，可从 [Catppuccin 官方主题仓库](https://github.com/catppuccin/iterm)下载对应的 iTerm2 配色。

### Windows / Windows Terminal

1. 打开 Windows Terminal → Settings → Profiles → Defaults → Appearance。
2. Font face 设为 `Maple Mono NF CN`。
3. Color scheme 可以先选内置的 `One Half Dark`；如需与 VS Code 一致，再按 [Catppuccin Windows Terminal 主题](https://github.com/catppuccin/windows-terminal)的官方说明导入配色。

Windows Terminal 官方配置：[外观设置](https://learn.microsoft.com/windows/terminal/customize-settings/profile-appearance) · [配色方案](https://learn.microsoft.com/windows/terminal/customize-settings/color-schemes)。

## 5. 保持简单

- 先使用同一套字体和深色主题，不急着折腾复杂的 Shell 插件。
- iTerm2 / Windows Terminal 是宿主机终端；进入 Dev Container 后，VS Code 会使用容器里的 Shell。
- 终端外观与项目配置分开管理，不要把个人主题和字体写进项目仓库。
