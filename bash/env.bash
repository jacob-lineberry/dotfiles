# shellcheck shell=sh
# PATH for bash on Ubuntu, sourced from ~/.profile and the top of ~/.bashrc by setup.sh (bootstrap_bash).
# zsh is the interactive shell here; this only puts ~/.local/bin and the mise shims on PATH for login shells,
# tmux panes and scripts that run under bash. zsh/.zshenv and zsh/.zshrc do the same for zsh.
# Written in POSIX sh because ~/.profile is also read by sh (dash), and idempotent because a login bash reads
# this twice (~/.profile sources ~/.bashrc).

_dotfiles_path_prepend() {
  case ":$PATH:" in
    *":$1:"*) return 0 ;;
  esac
  if [ -d "$1" ]; then PATH="$1:$PATH"; fi
  return 0
}

_dotfiles_path_prepend "$HOME/.local/bin"
_dotfiles_path_prepend "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"
export PATH
unset -f _dotfiles_path_prepend
