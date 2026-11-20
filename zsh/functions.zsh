cover() {
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

# yazi wrapper: exiting with 'q' changes directory to last visited; 'Q' exits without changing directory
y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    command rm -f -- "$tmp"
}

# Omarchy-style Dev Cockpit: editor (left 70%), agent (right 30%), terminal (bottom 15%)
# Usage: dev [agent_command] (defaults to claude, or pass opencode / $AI_AGENT)
dev() {
    local ai="${1:-${AI_AGENT:-claude}}"
    local current_dir="${PWD}"
    local session_name
    session_name="$(basename "$current_dir" | tr '.:' '--')"

    if [[ -z "$TMUX" ]]; then
        if tmux has-session -t "$session_name" 2>/dev/null; then
            tmux attach-session -t "$session_name"
            return 0
        fi
        tmux new-session -d -s "$session_name" -c "$current_dir"
        tmux rename-window -t "$session_name:1" "$session_name"
        tmux split-window -v -p 15 -t "$session_name:1.1" -c "$current_dir"
        tmux split-window -h -p 30 -t "$session_name:1.1" -c "$current_dir"
        tmux send-keys -t "$session_name:1.2" "$ai" C-m
        tmux send-keys -t "$session_name:1.1" "${EDITOR:-nvim} ." C-m
        tmux select-pane -t "$session_name:1.1"
        tmux attach-session -t "$session_name"
    else
        local editor_pane="$TMUX_PANE"
        tmux rename-window -t "$editor_pane" "$session_name"
        tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
        local ai_pane
        ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
        tmux send-keys -t "$ai_pane" "$ai" C-m
        tmux send-keys -t "$editor_pane" "${EDITOR:-nvim} ." C-m
        tmux select-pane -t "$editor_pane"
    fi
}
alias tdl="dev"
