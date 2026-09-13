# Bluespec / BSC 学习环境

这是一个以理解 Bluespec、FPGA 和最终的 Bluespec RISC-V 实现为目标的个人实验项目。仓库不复制 BSC 源码，而是用 `versions.env` 固定官方 BSC 的 commit；`vendor/bsc/` 是脚本下载的本地工作树，构建产物放在 `build/`，两者都不应提交到自己的 GitHub 仓库。

## 当前完成的最小闭环

```text
官方 BSC commit
        │
        ▼
   make build
        │
        ├── Bluesim (`make counter`)
        └── Verilog + Icarus (`make counter`)
```

`examples/01_counter/Counter.bsv` 是第一个 case：一个 8-bit register 每个时钟规则加一，在 0 到 9 输出后结束。`make counter` 会同时运行 Bluesim 和 Icarus Verilog，并比较两份输出；这个 case 用来观察寄存器、rule、旧值语义、`$display` 和 `$finish`。

## Linux / WSL 快速开始

```bash
make bootstrap
make deps
cabal v1-install --user strict-concurrency
make build
make counter
make smoke
```

如果机器上已经有依赖，可以跳过 `make deps`。BSC 官方推荐 GHC 9.6.7；Ubuntu 24.04 的系统包通常是较旧版本，若出现 GHC 兼容性错误，应改用 GHCup 安装 9.6.7。

## macOS M5 快速开始

先安装 Xcode Command Line Tools 和 Homebrew：

```bash
xcode-select --install
make bootstrap
make deps
ghcup install ghc 9.6.7
cabal v1-install --user regex-compat syb old-time split strict-concurrency
make build
make counter
make smoke
```

BSC 官方当前测试 macOS arm64，因此 Apple Silicon 不需要 Rosetta。若 Homebrew 的 Tcl 头文件未被找到，可在构建前设置 `CPPFLAGS` / `LDFLAGS`，或参考 `vendor/bsc/INSTALL.md`。

## 项目约定

- `versions.env`：上游 BSC 来源和不可变 commit。
- `scripts/`：安装、构建、运行和验证入口；尽量只使用 POSIX shell、Git、Make。
- `examples/`：按学习主题递增编号；每个 case 应有源码、期望输出和可重复命令。
- `build/`：本机生成物，不提交。
- `vendor/bsc/`：官方源码工作树，不提交；通过 `make bootstrap` 重建。

建议每完成一个学习主题就提交一次，例如 `case: understand rule scheduling`。之后加入 FPGA 时，再单独增加板卡工具链和约束文件，不把板卡 SDK 强耦合到 BSC 基础环境。

## Vim / LSP

项目包含可复现的 Vim 配置，优先使用 BSC 官方自带的 BSV 文件类型、语法高亮和基础缩进：

```bash
make bootstrap
vim -Nu .vimrc examples/01_counter/Counter.bsv
```

完整说明见 [`editor/vim/README.md`](editor/vim/README.md)。其中也记录了可选的社区 `blues-lsp` 接入方式；LSP 只负责编辑器能力，编译和仿真仍以 `bsc`、`make counter` 为准。

## 后续路线

1. rule 与 method：寄存器冲突、guard、schedule report。
2. interface 与 FIFO：把 counter 改成可读写模块。
3. Verilog 端口与 FPGA：导出顶层、时钟/复位、接 LED 或 UART。
4. RISC-V：阅读并运行 Piccolo/Flute，先理解 generated Verilog，再回到 BSV pipeline、CSR、memory interface 和 bus。

## GitHub 跟踪

当前 Codex 工作区的 `.git` 元数据是只读的，因此本次不能代替你创建远程仓库或推送 commit。把目录复制/打开到可写 Git 工作区后执行：

```bash
git init
git add .
git commit -m "build reproducible Bluespec learning environment"
git branch -M main
git remote add origin git@github.com:<your-account>/<your-repo>.git
git push -u origin main
```

后续在另一台 Mac 上只需 clone 自己的仓库并执行上面的 macOS 命令；不需要把 322 MB 的 BSC 源码提交进去。
