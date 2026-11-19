# shellcheck shell=bash
# Shared helpers, sourced by setup.sh and scripts/platform/*.sh. Not meant to run on its own.

BACKUP=${BACKUP:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}

have() { command -v "$1" >/dev/null 2>&1; }
step() { printf '\033[1m\033[34m==> %s\033[0m\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

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
