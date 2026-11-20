# fzf (Ctrl-T files, Alt-C cd), zoxide (z, zi) and atuin (Ctrl-R history)

if (( $+commands[fzf] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

  # Tokyo Night Storm; bg:-1 keeps the (transparent) terminal background
  export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded \
--color=bg:-1,bg+:#292e42,fg:#c0caf5,fg+:#c0caf5,hl:#f7768e,hl+:#f7768e \
--color=info:#bb9af7,prompt:#7aa2f7,pointer:#7aa2f7,marker:#7dcfff,spinner:#7dcfff \
--color=header:#f7768e,border:#565f89,selected-bg:#2e3c64"
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"
fi

# The init scripts need a terminal (they error under `zsh -i -c` without a tty)
if [[ -t 0 ]]; then
  (( $+commands[fzf] )) && _init_cache fzf fzf --zsh
  (( $+commands[zoxide] )) && _init_cache zoxide zoxide init zsh --cmd cd
  # after fzf: atuin takes over Ctrl-R (fzf keeps Ctrl-T and Alt-C); the up arrow stays plain history
  (( $+commands[atuin] )) && _init_cache atuin atuin init zsh --disable-up-arrow
fi

# Proton Pass SSH agent autostart, opt-in per machine (touch ~/.config/proton-pass-agent.enabled). The common path costs
# two file reads and a `kill -0`, no process spawn. When the daemon is dead it starts again in the background, under a
# mkdir lock held 10 s, because `daemon start` returns before the daemon is visible (without it, panes opening
# together start duplicate daemons). `daemon stop` and crashes leave the socket behind, so liveness comes from the pid
# file, not the socket. Start it from a login shell, never systemd: pass-cli keeps its key in the kernel keyring, which
# services cannot see, so they force a logout.
if [[ -f $XDG_CONFIG_HOME/proton-pass-agent.enabled ]] && (( $+commands[pass-cli] )); then
  () {
    local pidfile=$HOME/.ssh/proton-pass-agent.pid pid lock=${XDG_STATE_HOME:-$HOME/.local/state}/proton-pass-agent.lock
    [[ -r $pidfile && $(<$pidfile) =~ '"pid": *([0-9]+)' ]] && pid=$match[1]
    [[ -n $pid ]] && kill -0 $pid 2>/dev/null && return
    zmodload -F zsh/datetime p:EPOCHSECONDS && zmodload -F zsh/stat b:zstat
    # a lock older than 30 s was left by a shell that died mid-start
    [[ -d $lock ]] && (( EPOCHSECONDS - $(zstat +mtime $lock) > 30 )) && rmdir $lock
    mkdir -p ${lock:h} && mkdir $lock 2>/dev/null || return
    { pass-cli ssh-agent daemon start; sleep 10; rmdir $lock } >/dev/null 2>&1 &!
  }
fi
