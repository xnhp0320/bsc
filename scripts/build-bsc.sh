#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BSC_SRC="${ROOT_DIR}/vendor/bsc"
BSC_PREFIX="${BSC_PREFIX:-${ROOT_DIR}/build/bsc}"
GHCJOBS="${GHCJOBS:-2}"

# macOS ships BSD make as `make`; BSC's upstream build requires GNU Make.
if [[ "$(uname -s)" == Darwin ]] && command -v gmake >/dev/null; then
  MAKE_CMD="gmake"
else
  MAKE_CMD="make"
fi

# Cabal 3's `install --lib` puts packages in a project-local package store,
# while the upstream Makefile checks packages through ghc-pkg. Make that
# package database visible when the project-local Cabal flow is used.
if command -v ghc >/dev/null && [[ -d "${ROOT_DIR}/build/cabal/store/ghc-$(ghc --numeric-version)/package.db" ]]; then
  export GHC_PACKAGE_PATH="${ROOT_DIR}/build/cabal/store/ghc-$(ghc --numeric-version)/package.db:/usr/lib/ghc/lib/package.conf.d${GHC_PACKAGE_PATH:+:${GHC_PACKAGE_PATH}}"
fi

if [[ ! -f "${BSC_SRC}/GNUmakefile" ]]; then
  echo "BSC source is missing; run make bootstrap first" >&2
  exit 1
fi

if [[ -x "${BSC_PREFIX}/bin/bsc" && "${FORCE_BSC_BUILD:-0}" != 1 ]]; then
  echo "[build] using existing installation: ${BSC_PREFIX}"
  exit 0
fi

mkdir -p "${ROOT_DIR}/build"
echo "[build] compiling BSC into ${BSC_PREFIX}"

# Building both SMT backends is useful later when learning scheduling and
# typechecking. NO_DEPS_CHECKS is intentionally not used: it catches a
# missing compiler dependency early on a new machine.
"${MAKE_CMD}" -C "${BSC_SRC}" install-src PREFIX="${BSC_PREFIX}" GHCJOBS="${GHCJOBS}"

"${BSC_PREFIX}/bin/bsc" -help >/dev/null
echo "[build] BSC executable is ready"
