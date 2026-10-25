# 字体与编辑器显示

统一使用 **Maple Mono NF CN**，兼顾中英文代码、中文注释，以及终端里的 Nerd Font 图标。

- 官方项目与下载说明：[Maple Mono](https://github.com/subframe7536/maple-font)
- 官方下载页面：[Maple Mono 下载](https://font.subf.dev/zh-cn/download/)

## 为什么选 NF CN？

- `CN`：包含中文、日文等字形，中英文宽度按 2:1 对齐。
- `NF`：包含 Nerd Font 图标，适合终端提示符和开发工具图标。
- 统一使用 `Maple Mono NF CN`，避免编辑器和终端因字体不同而产生视觉差异。

## 安装

在 `dev-env` 仓库根目录执行对应脚本。

### macOS

安装 [Homebrew](https://brew.sh/) 后运行：

```bash
bash tools/install-font-macos.sh
```

### Windows

先安装 [Scoop](https://scoop.sh/)，再运行本仓库脚本：

```powershell
.\tools\install-font-windows.ps1
```

脚本会添加 Nerd Fonts bucket 并安装 Maple Mono NF CN。安装后如应用没有识别新字体，请重启 VS Code 和终端。

## VS Code 字体设置

打开命令面板，选择 **Preferences: Open User Settings (JSON)**，加入或合并以下配置。放在用户设置中，不要放进项目的 `.vscode/settings.json`，这样所有项目都统一使用。

```json
{
  "editor.fontFamily": "'Maple Mono NF CN', 'SF Mono', Menlo, Consolas, monospace",
  "editor.fontSize": 17,
  "editor.fontWeight": "400",
  "editor.fontLigatures": true,
  "editor.lineHeight": 28,
  "editor.letterSpacing": 0.3,
  "terminal.integrated.fontFamily": "'Maple Mono NF CN'",
  "terminal.integrated.fontSize": 16,
  "terminal.integrated.lineHeight": 1.2
}
```

如果你使用 VS Code Settings Sync，它可以同步这些设置，但**不会替你在新电脑安装字体**；每台电脑都需要安装一次字体。

## 终端

- macOS：iTerm2 或系统终端都可以将字体设为 `Maple Mono NF CN`。
- Windows：Windows Terminal 的配置文件中将字体设为 `Maple Mono NF CN`。
- 终端主题、Shell 和提示符可以独立选择，不需要为了使用这款字体强制更换终端。

如果终端图标显示为方框，检查是否选择了 NF CN 版本，并确认应用已经重启。

## 注意

- CN 字体包体积较大，安装和首次加载需要一些时间。
- 高分辨率屏幕可优先使用官方提供的常规 NF CN 字体；低分辨率屏幕可根据官方说明尝试 hinted 版本。
- 字体设置只影响显示，不会改变项目文件或容器内的开发环境。
