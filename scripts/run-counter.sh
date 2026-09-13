#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BSC_PREFIX="${BSC_PREFIX:-${ROOT_DIR}/build/bsc}"
CASE_DIR="${ROOT_DIR}/examples/01_counter"
OUT_DIR="${ROOT_DIR}/build/examples/01_counter"

export PATH="${BSC_PREFIX}/bin:${PATH}"
command -v bsc >/dev/null || { echo "BSC is not built; run make build" >&2; exit 1; }
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}/bluesim" "${OUT_DIR}/verilog"

echo "[counter] Bluesim"
( cd "${OUT_DIR}/bluesim"
  bsc -sim -bdir . -simdir . -g mkCounter "${CASE_DIR}/Counter.bsv"
  bsc -sim -o counter.bexe -e mkCounter mkCounter.ba
  ./counter.bexe | tee bluesim.out
)

echo "[counter] Icarus Verilog"
( cd "${OUT_DIR}/verilog"
  bsc -verilog -vdir . -g mkCounter "${CASE_DIR}/Counter.bsv"
  bsc -verilog -vsim iverilog -o counter.vexe -e mkCounter mkCounter.v
  ./counter.vexe | tee iverilog.out
)

diff -u "${CASE_DIR}/expected.out" "${OUT_DIR}/bluesim/bluesim.out"
diff -u "${CASE_DIR}/expected.out" "${OUT_DIR}/verilog/iverilog.out"
echo "[counter] PASS: Bluesim and Icarus Verilog agree"
