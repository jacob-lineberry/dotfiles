#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
[[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims ]] && export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"
command -v pre-commit >/dev/null || { echo "pre-commit not found (brew install pre-commit)" >&2; exit 1; }
exec pre-commit run --all-files --show-diff-on-failure "$@"
