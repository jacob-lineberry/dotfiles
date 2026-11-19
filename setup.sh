#!/usr/bin/env bash
# Link the dotfiles with stow; --packages and --skills opt in to packages and agent skills.
# Platforms: macOS and Ubuntu (WSL2 included). Usage: ./setup.sh [--packages] [--skills]
set -euo pipefail

cd "$(dirname "$0")"
DOTFILES=$PWD
TARGET="$HOME/.config"

# shellcheck source=scripts/lib/common.sh
source "$DOTFILES/scripts/lib/common.sh"
# shellcheck source=scripts/lib/platform.sh
source "$DOTFILES/scripts/lib/platform.sh"

PACKAGES=0
SKILLS=0
for arg in "$@"; do
  case $arg in
    --packages) PACKAGES=1 ;;
    --skills) SKILLS=1 ;;
    *) die "usage: setup.sh [--packages] [--skills]" ;;
  esac
done

PLATFORM=$(detect_platform)
# shellcheck source=/dev/null # scripts/platform/{macos,ubuntu}.sh
source "$DOTFILES/scripts/platform/$PLATFORM.sh"

# zsh finds its config via ZDOTDIR, which has to be set from $HOME/.zshenv
bootstrap_zsh() {
  # shellcheck disable=SC2016
  [[ -e $HOME/.zshenv ]] || printf 'export ZDOTDIR="$HOME/.config/zsh"\n' > "$HOME/.zshenv"
  # shellcheck disable=SC2016
  grep -q 'ZDOTDIR/.zshenv' "$HOME/.zshenv" || printf '[[ -r $ZDOTDIR/.zshenv ]] && source $ZDOTDIR/.zshenv\n' >> "$HOME/.zshenv"
}

# Stowed packages: the folders listed in scripts/lib/platform.sh, minus the ones other platforms skip
link_configs() {
  local pkg src ignore ignores=()
  while IFS= read -r pkg; do
    while IFS= read -r -d '' src; do
      backup_unless_linked "$DOTFILES/${src#./}" "$TARGET/${src#./}"
    done < <(find "./$pkg" -type f -print0)
  done < <(platform_packages "$PLATFORM")
  while IFS= read -r ignore; do ignores+=("$ignore"); done < <(platform_stow_ignores "$PLATFORM")
  stow ${ignores[@]+"${ignores[@]}"} .
}

link_extras() {
  # Some machine configs set core.excludesFile to this path, which shadows ~/.config/git/ignore
  link "$DOTFILES/git/ignore" "$HOME/.gitignore_global"

  # tuios does not read ~/.config on macOS
  local tuios theme
  tuios=$(platform_tuios_dir)
  link "$DOTFILES/tuios/config.toml" "$tuios/config.toml"
  for theme in "$DOTFILES"/tuios/themes/*; do link "$theme" "$tuios/themes/$(basename "$theme")"; done

  # pi rewrites its settings and keeps private provider config in them: seed only
  if [[ ! -e $HOME/.pi/agent/settings.json ]]; then
    mkdir -p "$HOME/.pi/agent"
    cp "$DOTFILES/pi/agent/settings.json" "$HOME/.pi/agent/settings.json"
  fi
}

# Skills run third-party content: each manifest line is "<source> <skill>", pinned to a tag or commit
install_skills() {
  have npx || die "npx not found (mise install)"
  local source skill
  while read -r source skill; do
    [[ -z $source || $source == \#* ]] && continue
    npx --yes skills@1.8.1 add "$source" --skill "$skill" -g -a universal -a claude-code -y </dev/null
  done < "$DOTFILES/agents/skills.txt"
}

# Git hooks run through pre-commit (.pre-commit-config.yaml); drop the old check.sh symlink hook first
install_hooks() {
  [[ -d $DOTFILES/.git ]] || return 0
  [[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims ]] && export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"
  [[ ! -L $DOTFILES/.git/hooks/pre-commit ]] || rm -f "$DOTFILES/.git/hooks/pre-commit"
  if have pre-commit; then
    pre-commit install >/dev/null
  else
    echo "pre-commit not found, git hook not installed" >&2
  fi
}

step "Platform: $PLATFORM"
if [[ $DOTFILES != "$HOME/dotfiles" ]]; then
  echo "Warning: repo is at $DOTFILES, not $HOME/dotfiles; git identity and signing override will not apply" >&2
fi
platform_prerequisites
mkdir -p "$TARGET"
bootstrap_zsh
link_configs
link_extras
if [[ $PACKAGES -eq 1 ]]; then platform_install_packages; fi
if [[ $SKILLS -eq 1 ]]; then install_skills; fi

# Rebuild bat theme cache if bat is installed
if have bat; then bat cache --build >/dev/null 2>&1 || true; fi
install_hooks
