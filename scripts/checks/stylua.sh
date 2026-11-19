#!/usr/bin/env bash
set -euo pipefail

STYLUA=$(command -v stylua || ls "$HOME/.local/share/nvim/mason/bin/stylua" 2>/dev/null || true)
[[ -n $STYLUA && -x $STYLUA ]] || { echo "stylua not found (install via Mason or brew)" >&2; exit 1; }
exec "$STYLUA" --check --config-path nvim/stylua.toml "$@"
