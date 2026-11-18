#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
DOTFILES=$PWD
TARGET="$HOME/.config"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

command -v stow >/dev/null || { echo "stow not found (brew install stow)" >&2; exit 1; }
mkdir -p "$TARGET"

# Move anything at $2 that is not already $1 into the backup dir.
backup_unless_linked() {
  local src=$1 dst=$2
  [[ -e $dst || -L $dst ]] || return 0
  [[ $dst -ef $src ]] && return 0
  mkdir -p "$BACKUP/$(dirname "${dst#"$HOME"/}")"
  mv "$dst" "$BACKUP/${dst#"$HOME"/}"
  echo "backed up $dst -> $BACKUP"
}

link() {
  mkdir -p "$(dirname "$2")"
  backup_unless_linked "$1" "$2"
  ln -sfn "$1" "$2"
}

# zsh finds its config via ZDOTDIR, which has to be set from $HOME/.zshenv
# shellcheck disable=SC2016
[[ -e $HOME/.zshenv ]] || printf 'export ZDOTDIR="$HOME/.config/zsh"\n' > "$HOME/.zshenv"
# shellcheck disable=SC2016
grep -q 'ZDOTDIR/.zshenv' "$HOME/.zshenv" || printf '[[ -r $ZDOTDIR/.zshenv ]] && source $ZDOTDIR/.zshenv\n' >> "$HOME/.zshenv"

# Stowed packages: every top-level folder except those ignored in .stowrc
while IFS= read -r -d '' src; do
  rel=${src#./}
  backup_unless_linked "$DOTFILES/$rel" "$TARGET/$rel"
done < <(find . -mindepth 2 -type f -not -path './.git/*' -not -path './tuios/*' -not -path './pi/*' -print0)
stow .

# tuios does not read ~/.config on macOS
if [[ $(uname) == Darwin ]]; then TUIOS="$HOME/Library/Application Support/tuios"; else TUIOS="$TARGET/tuios"; fi
link "$DOTFILES/tuios/config.toml" "$TUIOS/config.toml"
for theme in "$DOTFILES"/tuios/themes/*; do link "$theme" "$TUIOS/themes/$(basename "$theme")"; done

# pi rewrites its settings and keeps private provider config in them: seed only
if [[ ! -e $HOME/.pi/agent/settings.json ]]; then
  mkdir -p "$HOME/.pi/agent"
  cp "$DOTFILES/pi/agent/settings.json" "$HOME/.pi/agent/settings.json"
fi

# Packages are opt-in: ./setup.sh --brew
if [[ ${1:-} == --brew ]]; then
  brew bundle --file="$DOTFILES/homebrew/Brewfile"
  if [[ -r $HOME/.corp/Brewfile ]]; then brew bundle --file="$HOME/.corp/Brewfile"; fi
fi

# Rebuild bat theme cache if bat is installed
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null 2>&1 || true
fi

# Install git pre-commit hook if inside git repo
if [[ -d "$DOTFILES/.git" ]]; then
  mkdir -p "$DOTFILES/.git/hooks"
  ln -sf "../../check.sh" "$DOTFILES/.git/hooks/pre-commit"
fi
