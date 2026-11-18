# fzf (Ctrl-R history, Ctrl-T files, Alt-C cd) and zoxide (z, zi)

if (( $+commands[fzf] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

  # Catppuccin Mocha; bg:-1 keeps the (transparent) terminal background
  export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded \
--color=bg:-1,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,hl:#f38ba8,hl+:#f38ba8 \
--color=info:#cba6f7,prompt:#f5c2e7,pointer:#f5c2e7,marker:#b4befe,spinner:#f5e0dc \
--color=header:#f38ba8,border:#6c7086,selected-bg:#45475a"
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"
fi

# The init scripts need a terminal (they error under `zsh -i -c` without a tty)
if [[ -t 0 ]]; then
  (( $+commands[fzf] )) && source <(fzf --zsh)
  (( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"
fi
