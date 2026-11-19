# Completion setup and styling for zsh

# fpath: deduplicated, Homebrew completions ahead of the defaults, set before compinit
typeset -U fpath
fpath=("${HOMEBREW_PREFIX:-/opt/homebrew}"/share/zsh-completions(N-/) $fpath)

# Cached compinit: full fpath scan at most once every 24h, compinit -C otherwise
() {
  local dump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump" mtime
  zmodload -F zsh/stat b:zstat
  zmodload -F zsh/datetime p:EPOCHSECONDS
  autoload -Uz compinit
  [[ -s $dump ]] && zstat -A mtime +mtime -- $dump

  if (( EPOCHSECONDS - ${mtime[1]:-0} < 86400 )); then
    compinit -u -C -d $dump
  else
    mkdir -p ${dump:h}
    compinit -u -d $dump
    touch $dump
    { zcompile $dump } &!
  fi
}

zmodload -i zsh/complist

# Menu selection, case-insensitive / partial-word matching
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' accept-exact '*(N)'

# Colors (Tokyo Night Storm): file colors from LS_COLORS, selected item Magenta (#bb9af7) on Visual (#2e3c64)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" "ma=38;2;187;154;247;48;2;46;60;100;1"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#bb9af7}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{#e0af68}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format '%F{#7dcfff}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{#f7768e}-- no matches found --%f'

# Cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
