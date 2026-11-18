[[ -d "$HOME/.codeium/windsurf/bin" ]] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# eza
export EZA_CONFIG_DIR="$HOME/.config/eza"

# k9s
export K9S_CONFIG_DIR="$HOME/.config/k9s"

# load zsh config files in order: core (sources ~/.corp/env.zsh) before paths
# (dedupe_path runs last there); completion before plugins; plugins last
for file in core functions paths aliases completion prompt plugins; do
  [[ -r $ZDOTDIR/$file.zsh ]] && source $ZDOTDIR/$file.zsh
done
unset file
