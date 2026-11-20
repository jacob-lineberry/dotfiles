# non-login shells (e.g. spawned by a multiplexer) do not run .zprofile
if [[ -z $HOMEBREW_PREFIX ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv zsh)"
  fi
fi
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims ]] && export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

# load zsh config files in order: core (sources ~/.corp/env.zsh) first; completion
# before tools and plugins; plugins last
for file in core functions aliases completion tools prompt plugins; do
  [[ -r $ZDOTDIR/$file.zsh ]] && source $ZDOTDIR/$file.zsh
done
unset file

# core.zsh needs the shims early (_init_cache resolves tools through them); re-assert them here so nothing the
# config files prepend (brew, goenv, ~/.corp) can shadow mise-pinned tools
[[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims ]] && export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

# string assignments to PATH (brew, goenv, ~/.corp) can leave duplicates; dedupe once, keeping order
typeset -U path
