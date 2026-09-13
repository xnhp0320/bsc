#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
  Darwin)
    command -v brew >/dev/null || {
      echo "Install Homebrew first: https://brew.sh" >&2
      exit 1
    }
    brew install autoconf gmp gperf icarus-verilog pkg-config tcl-tk
    echo "Install GHC 9.6.7 with GHCup, then install Haskell packages:"
    echo "  ghcup install ghc 9.6.7"
    echo "  cabal v1-install --user regex-compat syb old-time split strict-concurrency"
    ;;
  Linux)
    if command -v apt-get >/dev/null; then
      sudo apt-get install -y \
        build-essential tcl-dev libgmp-dev pkg-config autoconf gperf flex bison \
        iverilog ghc cabal-install libghc-regex-compat-dev libghc-syb-dev \
        libghc-old-time-dev libghc-split-dev
      echo "Ubuntu's GHC package is supported as a quick start; GHCup 9.6.7 is the upstream-tested choice."
      echo "Install the remaining Haskell package with:"
      echo "  cabal v1-install --user strict-concurrency"
    else
      echo "Unsupported Linux package manager; see vendor/bsc/INSTALL.md" >&2
      exit 1
    fi
    ;;
  *)
    echo "Unsupported host: $(uname -s). See vendor/bsc/INSTALL.md" >&2
    exit 1
    ;;
esac
