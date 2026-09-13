# 环境状态

## 2026-09-13

- Host used for initial validation: Ubuntu 24.04 on WSL2, x86_64.
- Pinned BSC: `083dcb67143e9e912fb1d2d7a7755d8bd094d92d` (`2026.07`).
- Toolchain: GHC 9.4.7 from Ubuntu packages; `strict-concurrency` 0.2.4.3 from Hackage; Icarus Verilog 12.0.
- BSC installation: `build/bsc`.

Validation commands:

```text
make build   PASS
make counter PASS (Bluesim == Icarus Verilog)
make smoke   PASS (upstream BSC smoke test)
```

The generated counter logs are in `build/examples/01_counter/bluesim/bluesim.out` and `build/examples/01_counter/verilog/iverilog.out`. Generated files are intentionally ignored; the expected result is kept beside the source in `examples/01_counter/expected.out`.

## Next update template

When adding a case, record:

1. the learning objective;
2. the exact command used;
3. Bluesim and Verilog output (or explain why only one is applicable);
4. the BSC commit and host/tool versions;
5. the next question to investigate.
