# Zsh plugins (Homebrew): autosuggestions, then syntax highlighting last

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

() {
  local share="${HOMEBREW_PREFIX:-/opt/homebrew}/share"
  [[ -r $share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
    source $share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [[ -r $share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] &&
    source $share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
}
