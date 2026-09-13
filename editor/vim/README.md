# Vim support

本项目优先使用 BSC 官方仓库自带的 Vim 支持。它提供 BSV 的文件类型识别、语法高亮和基础缩进；官方目前没有随 BSC 发布的 LSP 服务。

## 项目内立即使用

在仓库根目录执行：

```bash
make bootstrap
vim -Nu .vimrc examples/01_counter/Counter.bsv
```

Neovim 也可以使用同一个配置：

```bash
nvim -u .vimrc examples/01_counter/Counter.bsv
```

打开 BSV 后，按 `<leader>c` 会执行 `make counter`，用于验证 Bluesim 和 Icarus Verilog 输出是否一致。

## 安装到用户 Vim

如果希望普通 `vim` 直接识别 `.bsv`，执行：

```bash
./scripts/install-vim-support.sh
```

脚本只复制官方的 `ftdetect`、`indent` 和 `syntax` 文件到 `${VIM_CONFIG_DIR:-$HOME/.vim}`，不会修改 Vim 插件管理器配置。

## 可选 LSP

社区项目 [blues-lsp](https://gitlab.com/runtimetantrum/blues-lsp) 可以通过 Cargo 安装：

```bash
cargo install blues-lsp
```

它仍处于早期阶段，适合尝试跳转定义、引用查找和诊断；不能替代 BSC 编译器。项目根目录已经准备了 `blues_compdb.json`，供支持该协议的编辑器插件读取。

建议先使用本目录的官方语法支持，等需要跨文件跳转/诊断时再接入 `blues-lsp`。在 Vim 中可通过 `vim-lsp` 接入；Neovim 也可以使用内置 LSP 客户端。
