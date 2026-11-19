# Zsh plugins (Homebrew, apt): autosuggestions, then syntax highlighting last

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

() {
  local p file
  for p in zsh-autosuggestions zsh-syntax-highlighting; do
    for file in ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/share/$p/$p.zsh"} "/usr/share/$p/$p.zsh"; do
      if [[ -n $file && -r $file ]]; then
        source "$file"
        break
      fi
    done
  done
}
