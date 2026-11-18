# History settings
HISTSIZE=100000
SAVEHIST=100000

# History options
setopt HIST_IGNORE_DUPS       # Don't save duplicate commands
setopt HIST_IGNORE_SPACE      # Don't save commands starting with space
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY          # Share history between all sessions

setopt AUTOCD
setopt NOBEEP

# load direnv
eval "$(direnv hook zsh)"

# GPG pinentry needs the current tty (only when gpg exists and stdin is a terminal)
if (( $+commands[gpg] )) && [[ -t 0 ]]; then export GPG_TTY=$(tty); fi

# Corporate/local environment overrides (loaded silently if present)
[[ -r "$HOME/.corp/env.zsh" ]] && source "$HOME/.corp/env.zsh"

# Directory colors: Catppuccin Mocha Pink (#f5c2e7)
export LS_COLORS="di=38;2;245;194;231:${LS_COLORS}"
export LSCOLORS="fxfxcxdxbxegedabagacad"


