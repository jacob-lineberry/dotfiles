# History settings. Debian/Ubuntu's global zshrc sets no HISTFILE (macOS's does), so without this nothing is saved on
# Ubuntu. Same default as macOS. HISTSIZE exceeds SAVEHIST so HIST_EXPIRE_DUPS_FIRST has duplicates to drop first.
: ${HISTFILE:=${ZDOTDIR:-$HOME}/.zsh_history}
HISTSIZE=110000
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

# _init_cache <name> <command...>: source the output of an init command from a cache instead of forking it in every
# shell (a mise shim costs ~16 ms per call, so three tools add ~50 ms to each new pane). The cache regenerates when
# the tool's mise install dir (its init script can embed the versioned binary path), the mise lockfile, the tool's own
# config under ~/.config/<name>/ (atuin's init reads its config) or the calling file is newer; `rm ~/.cache/zsh/init-*`
# forces it. A failing command leaves no cache behind, so the shell starts
# without that tool's init.
_init_cache() {
  local name=$1 caller=${funcfiletrace[1]%:*}
  local cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init-$name.zsh
  local lock=${XDG_CONFIG_HOME:-$HOME/.config}/mise/mise.lock
  local installs=${XDG_DATA_HOME:-$HOME/.local/share}/mise/installs/$name
  local cfg stale=0
  shift
  for cfg in ${XDG_CONFIG_HOME:-$HOME/.config}/$name/*(N-.); do [[ $cfg -nt $cache ]] && stale=1; done
  if [[ ! -s $cache || $stale == 1 || $installs -nt $cache || $lock -nt $cache || $caller -nt $cache ]]; then
    mkdir -p ${cache:h}
    if "$@" >| $cache.tmp 2>/dev/null; then
      mv -f $cache.tmp $cache
    else
      rm -f $cache.tmp
      return 1
    fi
  fi
  source $cache
}

# load direnv
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# GPG pinentry needs the current tty ($TTY is set by zsh, so no `tty` fork)
if (( $+commands[gpg] )) && [[ -n $TTY ]]; then export GPG_TTY=$TTY; fi

# Corporate/local environment overrides (loaded silently if present)
[[ -r "$HOME/.corp/env.zsh" ]] && source "$HOME/.corp/env.zsh"

# Directory colors: Tokyo Night Magenta (#bb9af7)
export LS_COLORS="di=38;2;187;154;247:${LS_COLORS}"
export LSCOLORS="fxfxcxdxbxegedabagacad"


