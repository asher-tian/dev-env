# mise

mise 用于按项目固定和安装 Node.js、Go 等运行时版本。安装 mise 本身由新电脑初始化脚本完成；项目版本由项目自己的 `mise.toml` 管理。

## 常用命令

进入已有项目后：

```bash
mise install
mise ls
mise exec node@22 -- node --version
mise exec go@1.24 -- go version
```

在项目中固定版本时，使用项目目录下的 `mise.toml`，并将其提交到 Git。不要依赖某台电脑上未记录的全局版本。

## Python 与 uv

Python 项目优先使用 uv 管理 Python 解释器、虚拟环境和依赖。不要为了统一而强制用 mise 管理 uv；只有确实需要固定 uv 自身版本时，才额外纳入版本管理。

官方资料：[mise 文档](https://mise.jdx.dev/)。
