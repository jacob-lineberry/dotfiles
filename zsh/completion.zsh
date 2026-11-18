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
    compinit -C -d $dump
  else
    mkdir -p ${dump:h}
    compinit -d $dump
    touch $dump
    { zcompile $dump } &!
  fi
}

zmodload -i zsh/complist

# Menu selection, case-insensitive / partial-word matching
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' accept-exact '*(N)'

# Colors (Catppuccin Mocha): file colors from LS_COLORS, selected item Mauve (#cba6f7) on Surface1 (#45475a)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" "ma=38;2;203;166;247;48;2;69;71;90;1"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#cba6f7}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{#f9e2af}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format '%F{#89b4fa}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{#f38ba8}-- no matches found --%f'

# Cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
