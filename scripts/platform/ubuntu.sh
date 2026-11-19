# shellcheck shell=bash
# Ubuntu side of the platform contract (see macos.sh), also used on WSL2. Packages come from apt, not Homebrew.

# apt-get install the packages whose commands are missing: ensure_commands command:package ...
ensure_commands() {
  local pair pkgs=() sudo_cmd=()
  for pair in "$@"; do
    have "${pair%%:*}" || pkgs+=("${pair#*:}")
  done
  [[ ${#pkgs[@]} -eq 0 ]] && return 0
  have apt-get || die "apt-get not found, install manually: ${pkgs[*]}"
  if [[ $EUID -ne 0 ]]; then
    have sudo || die "need root or sudo to install: ${pkgs[*]}"
    sudo_cmd=(sudo)
  fi
  step "apt: ${pkgs[*]}"
  "${sudo_cmd[@]+"${sudo_cmd[@]}"}" apt-get update -qq
  "${sudo_cmd[@]+"${sudo_cmd[@]}"}" apt-get install -y -qq "${pkgs[@]}"
}

platform_prerequisites() {
  ensure_commands git:git curl:curl stow:stow zsh:zsh
}

platform_install_packages() {
  die "Ubuntu packages are not set up yet (they will come from apt): install what you need with apt"
}

platform_tuios_dir() { printf '%s\n' "$HOME/.config/tuios"; }
