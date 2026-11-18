# non-login shells (e.g. spawned by a multiplexer) do not run .zprofile
[[ -z $HOMEBREW_PREFIX && -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv zsh)"
[[ -d "$HOME/.codeium/windsurf/bin" ]] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# load zsh config files in order: core (sources ~/.corp/env.zsh) first; completion
# before tools and plugins; plugins last
for file in core functions paths aliases completion tools prompt plugins; do
  [[ -r $ZDOTDIR/$file.zsh ]] && source $ZDOTDIR/$file.zsh
done
unset file

# string assignments to PATH (brew, goenv, ~/.corp) can leave duplicates; dedupe once, keeping order
typeset -U path
