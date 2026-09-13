#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BSC_VIM_DIR="${ROOT_DIR}/vendor/bsc/util/vim"
VIM_CONFIG_DIR="${VIM_CONFIG_DIR:-${HOME}/.vim}"

if [[ ! -d "${BSC_VIM_DIR}" ]]; then
  echo "BSC Vim files are missing; run 'make bootstrap' first" >&2
  exit 1
fi

mkdir -p "${VIM_CONFIG_DIR}/ftdetect" "${VIM_CONFIG_DIR}/indent" "${VIM_CONFIG_DIR}/syntax"
cp "${BSC_VIM_DIR}/ftdetect/bsv.vim" "${VIM_CONFIG_DIR}/ftdetect/bsv.vim"
cp "${BSC_VIM_DIR}/indent/bsv.vim" "${VIM_CONFIG_DIR}/indent/bsv.vim"
cp "${BSC_VIM_DIR}/syntax/bsv.vim" "${VIM_CONFIG_DIR}/syntax/bsv.vim"

echo "Installed BSV Vim support into ${VIM_CONFIG_DIR}"
