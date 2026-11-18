[[ -d "$HOME/.codeium/windsurf/bin" ]] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# eza
export EZA_CONFIG_DIR="$HOME/.config/eza"

# k9s
export K9S_CONFIG_DIR="$HOME/.config/k9s"

# load zsh config files
for file in "${ZDOTDIR:-$HOME/.config/zsh}"/*.zsh; do
  [ -r "$file" ] && source "$file"
done
