if (( $+commands[eza] )); then
  alias ls="eza --icons"
  alias ll="eza -lah --icons --git"
  alias tree="eza --tree --icons"
fi

alias c="clear"
alias diff="diff --color=auto"
(( $+commands[duf] )) && alias df="duf"
(( $+commands[dust] )) && alias du="dust"
(( $+commands[bat] )) && alias b="bat"
(( $+commands[kubectl] )) && alias k="kubectl"
(( $+commands[tuios] )) && alias t="tuios attach"
(( $+commands[lazygit] )) && alias lg="lazygit"

(( $+commands[jless] )) && alias -s json="jless"

# config & source files open in bat (syntax-highlighted, auto-paged)
if (( $+commands[bat] )); then
  alias -s {conf,config,cfg,ini,env,yaml,yml,toml,properties}="bat"
  # alias -s {sh,bash,zsh}="bat"  # disabled: intercepts executable script paths like ./scripts/build.sh
  alias -s {py,go,rs,ts,tsx,js,lua}="bat"
  alias -s {tf,tfvars,hcl}="bat"
  alias -s {css,html,xml,md,txt,log,csv,tsv}="bat"
fi
