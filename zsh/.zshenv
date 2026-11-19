export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"

skip_global_compinit=1

# mise shims (available to all interactive and non-interactive shells)
[[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims ]] && export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"
