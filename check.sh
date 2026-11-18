#!/usr/bin/env bash
set -euo pipefail

# Resolve repository root even if called through a symlink (e.g. .git/hooks/pre-commit)
TARGET="${BASH_SOURCE[0]}"
while [ -L "$TARGET" ]; do
  DIR="$(cd -P "$(dirname "$TARGET")" && pwd)"
  TARGET="$(readlink "$TARGET")"
  [[ $TARGET != /* ]] && TARGET="$DIR/$TARGET"
done
REPO_ROOT="$(cd -P "$(dirname "$TARGET")" && pwd)"
cd "$REPO_ROOT"

echo "==> Running dotfiles health & safety checks..."

# 1. Gitleaks secrets detection
if command -v gitleaks >/dev/null 2>&1; then
  echo "  [1/5] Checking for secrets (gitleaks)..."
  if git rev-parse --verify HEAD >/dev/null 2>&1 && ! git diff --cached --quiet 2>/dev/null; then
    gitleaks protect --staged --no-banner --redact
  else
    gitleaks detect --source . --no-git --no-banner --redact
  fi
else
  echo "  [1/5] Warning: gitleaks not installed, skipping secrets scan" >&2
fi

# 2. Shellcheck
if command -v shellcheck >/dev/null 2>&1; then
  echo "  [2/5] Linting shell scripts (shellcheck)..."
  shellcheck setup.sh check.sh
else
  echo "  [2/5] Warning: shellcheck not installed, skipping shell lint" >&2
fi

# 3. Zsh syntax check
echo "  [3/5] Validating Zsh syntax..."
for f in zsh/.zshenv zsh/.zshrc zsh/*.zsh; do
  [[ -f "$f" ]] && zsh -n "$f"
done

# 4. Stylua (Lua formatting)
STYLUA=$(command -v stylua || ls "$HOME/.local/share/nvim/mason/bin/stylua" 2>/dev/null || true)
if [[ -n "$STYLUA" && -x "$STYLUA" ]]; then
  echo "  [4/5] Checking Neovim Lua formatting (stylua)..."
  "$STYLUA" --check --config-path nvim/stylua.toml nvim/lua nvim/init.lua
else
  echo "  [4/5] Warning: stylua not found, skipping Lua formatting check" >&2
fi

# 5. Stow dry-run check
echo "  [5/5] Checking Stow symlinks..."
stow -n -v . 2>&1 | grep -v "simulation mode" || true

echo "==> All checks passed!"
