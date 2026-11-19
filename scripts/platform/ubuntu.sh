# shellcheck shell=bash
# Ubuntu side of the platform contract (see macos.sh), also used on WSL2. Packages come from apt, not Homebrew.

apt_sudo() {
  if [[ $EUID -ne 0 ]]; then
    have sudo || die "need root or sudo: $*"
    sudo "$@"
  else
    "$@"
  fi
}

apt_update() {
  [[ -n ${APT_UPDATED:-} ]] && return 0
  apt_sudo apt-get update -qq
  APT_UPDATED=1
}

apt_install() {
  have apt-get || die "apt-get not found, install manually: $*"
  step "apt: $*"
  apt_update
  apt_sudo apt-get install -y -qq "$@"
}

# apt-get install the packages whose commands are missing: ensure_commands command:package ...
ensure_commands() {
  local pair pkgs=()
  for pair in "$@"; do
    have "${pair%%:*}" || pkgs+=("${pair#*:}")
  done
  [[ ${#pkgs[@]} -eq 0 ]] && return 0
  apt_install "${pkgs[@]}"
}

ensure_login_shell() {
  have zsh || return 0
  local shell zsh_path
  shell=$(getent passwd "${USER:-$(id -un)}" 2>/dev/null | cut -d: -f7 || true)
  [[ $shell == *"zsh"* ]] && return 0
  zsh_path=$(command -v zsh)
  if [[ -t 0 ]]; then
    step "Changing login shell to $zsh_path"
    chsh -s "$zsh_path" || true
  else
    echo "To set zsh as your login shell: chsh -s $zsh_path"
  fi
}

platform_prerequisites() {
  ensure_commands git:git curl:curl stow:stow zsh:zsh
  ensure_login_shell
}

platform_install_packages() {
  apt_install \
    build-essential \
    curl \
    git \
    git-lfs \
    gnupg \
    stow \
    zsh \
    unzip \
    extrepo \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    eza \
    btop \
    gh \
    direnv \
    tmux \
    tree

  if ! have mise; then
    step "extrepo: enable mise"
    apt_sudo extrepo enable mise
    apt_sudo apt-get update -qq
    apt_sudo apt-get install -y -qq mise
  fi

  install_mise_tools
}

platform_tuios_dir() { printf '%s\n' "$HOME/.config/tuios"; }
