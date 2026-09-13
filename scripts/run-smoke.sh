#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BSC_SRC="${ROOT_DIR}/vendor/bsc"
BSC_PREFIX="${BSC_PREFIX:-${ROOT_DIR}/build/bsc}"

export PATH="${BSC_PREFIX}/bin:${PATH}"
make -C "${BSC_SRC}" PREFIX="${BSC_PREFIX}" check-smoke
