# fzf (Ctrl-R history, Ctrl-T files, Alt-C cd) and zoxide (z, zi)

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
  (( $+commands[fzf] )) && source <(fzf --zsh)
  (( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"
fi
