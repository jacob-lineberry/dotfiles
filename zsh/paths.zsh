# Go (goenv)
if [ -d "$HOME/.goenv" ] ; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$PATH:$GOENV_ROOT/bin"
  eval "$(goenv init -)"
  export PATH="$PATH:$GOROOT/bin"
  export PATH="$PATH:$GOPATH/bin"
fi
