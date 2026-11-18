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
