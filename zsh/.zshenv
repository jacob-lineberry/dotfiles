export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"

skip_global_compinit=1

# WSL appends ~14 Windows directories (/mnt/c/...) to PATH. zsh scans all of them when it first builds its command
# table (~40 ms in every new shell over the 9P mount), so drop them; aliases.zsh reaches the few Windows tools by full path,
# and bin/xdg-open (first on PATH) opens links in the Windows browser for tuios, gh and anything else that calls it.
if [[ -n $WSL_DISTRO_NAME ]]; then
  path=(${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/bin ${path:#/mnt/[a-z]/*})
fi

# mise shims (available to all interactive and non-interactive shells)
[[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims ]] && export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

# Proton Pass SSH agent: opt in per machine with `touch ~/.config/proton-pass-agent.enabled` (zsh/tools.zsh starts the
# daemon). A machine without the marker or a running daemon keeps its own agent; the private env file can still override.
[[ -f $XDG_CONFIG_HOME/proton-pass-agent.enabled || -S $HOME/.ssh/proton-pass-agent.sock ]] &&
  export SSH_AUTH_SOCK="$HOME/.ssh/proton-pass-agent.sock"
