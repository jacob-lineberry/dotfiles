#!/usr/bin/env bash
# zsh -n only checks its first file argument, so loop
set -euo pipefail

for f in "$@"; do
  zsh -n "$f"
done
