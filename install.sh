#!/usr/bin/env bash
# Fetch the dotfiles, then hand over to setup.sh (all logic lives in the clone). To bootstrap a new machine:
#   curl -fsSL https://raw.githubusercontent.com/jacob-lineberry/dotfiles/main/install.sh | bash -s -- --packages
set -euo pipefail

REPO=${DOTFILES_REPO:-https://github.com/jacob-lineberry/dotfiles}
DEST=${DOTFILES_DIR:-$HOME/dotfiles}

if ! command -v git >/dev/null; then
  if [[ $(uname -s) == Darwin ]]; then
    echo "git not found (xcode-select --install)" >&2
    exit 1
  fi
  command -v apt-get >/dev/null || { echo "git not found" >&2; exit 1; }
  sudo_cmd=()
  [[ $EUID -eq 0 ]] || sudo_cmd=(sudo)
  "${sudo_cmd[@]+"${sudo_cmd[@]}"}" apt-get update -qq
  "${sudo_cmd[@]+"${sudo_cmd[@]}"}" apt-get install -y -qq git
fi

if [[ -d $DEST/.git ]]; then
  git -C "$DEST" pull --ff-only
else
  git clone "$REPO" "$DEST"
fi
exec "$DEST/setup.sh" "$@"
