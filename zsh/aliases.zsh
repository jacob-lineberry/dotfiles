alias ls="eza --icons"
alias ll="eza -lah --icons --git"
alias tree="eza --tree --icons"

alias diff="diff --color=auto"
alias b="bat"
alias k="kubectl"

alias -s json="jless"

# config & source files open in bat (syntax-highlighted, auto-paged)
alias -s {conf,config,cfg,ini,env,yaml,yml,toml,properties}="bat"
# alias -s {sh,bash,zsh}="bat"  # disabled: intercepts executable script paths like ./scripts/build.sh
alias -s {py,go,rs,ts,tsx,js,lua}="bat"
alias -s {tf,tfvars,hcl}="bat"
alias -s {css,html,xml,md,txt,log,csv,tsv}="bat"
