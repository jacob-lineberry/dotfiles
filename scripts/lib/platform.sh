# shellcheck shell=bash
# Platform detection and the one list of config packages (top-level folders stowed into ~/.config).
# Sourced by setup.sh and scripts/checks/stow.sh. Supported platforms: macos, ubuntu (WSL2 is plain Ubuntu).

# shellcheck disable=SC2034 # read by setup.sh and scripts/checks/stow.sh
COMMON_PACKAGES=(bat btop eza fastfetch git k9s lazygit mise nvim starship yazi zsh)
# shellcheck disable=SC2034 # GUI tools and Homebrew config: macOS only, skipped on ubuntu
MACOS_PACKAGES=(aerospace ghostty homebrew sketchybar)

# DOTFILES_PLATFORM overrides detection (used by checks and to test one platform from another)
detect_platform() {
  if [[ -n ${DOTFILES_PLATFORM:-} ]]; then
    printf '%s\n' "$DOTFILES_PLATFORM"
    return 0
  fi
  [[ $(uname -s) == Darwin ]] && { printf 'macos\n'; return 0; }
  local id=
  if [[ -r /etc/os-release ]]; then
    # shellcheck source=/dev/null
    id=$(. /etc/os-release && printf '%s' "${ID:-}")
  fi
  [[ $id == ubuntu ]] && { printf 'ubuntu\n'; return 0; }
  printf 'Error: unsupported platform (%s %s): only macOS and Ubuntu are supported\n' "$(uname -s)" "${id:-unknown}" >&2
  return 1
}

# Package names for platform $1, one per line
platform_packages() {
  printf '%s\n' "${COMMON_PACKAGES[@]}"
  if [[ $1 == macos ]]; then printf '%s\n' "${MACOS_PACKAGES[@]}"; fi
}

# Extra stow arguments for platform $1, one per line: skip the macOS-only packages elsewhere
platform_stow_ignores() {
  [[ $1 == macos ]] && return 0
  local IFS='|'
  printf '%s\n' "--ignore=^(${MACOS_PACKAGES[*]})\$"
}
