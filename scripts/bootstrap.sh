#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
source "${ROOT_DIR}/versions.env"

mkdir -p "${ROOT_DIR}/vendor"

if [[ ! -d "${ROOT_DIR}/vendor/bsc/.git" ]]; then
  echo "[bootstrap] cloning BSC source"
  git clone --filter=blob:none --no-checkout "${BSC_REPO}" "${ROOT_DIR}/vendor/bsc"
fi

if ! git -C "${ROOT_DIR}/vendor/bsc" cat-file -e "${BSC_REF}^{commit}" 2>/dev/null; then
  git -C "${ROOT_DIR}/vendor/bsc" fetch --depth 1 origin "${BSC_REF}"
fi
git -C "${ROOT_DIR}/vendor/bsc" checkout --force "${BSC_REF}"
git -C "${ROOT_DIR}/vendor/bsc" submodule update --init --recursive

actual_ref="$(git -C "${ROOT_DIR}/vendor/bsc" rev-parse HEAD)"
if [[ "${actual_ref}" != "${BSC_REF}" ]]; then
  echo "[bootstrap] unexpected BSC revision: ${actual_ref}" >&2
  exit 1
fi
echo "[bootstrap] BSC ${BSC_VERSION} @ ${actual_ref}"
