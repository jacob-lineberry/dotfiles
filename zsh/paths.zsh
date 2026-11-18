# mise shims (go); `mise activate zsh` is the alternative if per-project [env] is ever needed
[[ -d ${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims ]] && export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"
export PATH="$PATH:$HOME/go/bin"
