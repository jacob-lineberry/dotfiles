# go test coverage report in the browser; the profile is removed even when tests fail or the run is interrupted
cover() {
    local t; t=$(mktemp -t go-cover.XXXXXX) || return
    { go test -coverprofile="$t" "$@" && go tool cover -html="$t"; } always { command rm -f -- "$t"; }
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
