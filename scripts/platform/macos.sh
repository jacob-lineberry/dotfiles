# shellcheck shell=bash
# macOS side of the platform contract (the same functions exist in ubuntu.sh):
#   platform_prerequisites     commands setup.sh needs before it can link anything
#   platform_install_packages  --packages: install the platform's package list
#   platform_tuios_dir         where tuios reads its config

ensure_brew() {
  have brew || die "Homebrew not found: install it from https://brew.sh, then re-run"
}

platform_prerequisites() {
  have git || die "git not found (xcode-select --install)"
  have stow && return 0
  ensure_brew
  brew install stow
}

platform_install_packages() {
  ensure_brew
  brew bundle --file="$DOTFILES/homebrew/Brewfile"
  if [[ -r $HOME/.corp/Brewfile ]]; then brew bundle --file="$HOME/.corp/Brewfile"; fi
}

platform_tuios_dir() { printf '%s\n' "$HOME/Library/Application Support/tuios"; }
