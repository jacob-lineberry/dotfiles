#!/usr/bin/env bash
# Every formula and cask in homebrew/Brewfile must still resolve in Homebrew and not be disabled, so a renamed
# cask or a dropped tap fails CI instead of the next `./setup.sh --packages` on a Mac. Needs Homebrew (the macOS
# CI job); it does not install anything. The weekly full install in install.yml is the complete test.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
BREWFILE=homebrew/Brewfile
for cmd in brew jq; do
  command -v "$cmd" >/dev/null || { echo "$cmd not found: this check needs Homebrew and jq (macOS CI job)" >&2; exit 1; }
done

# Read the Brewfile directly: `brew bundle list` drops the tap from a cask name (nikitabobko/tap/aerospace -> aerospace)
formulae=() casks=() trusted=()
while IFS= read -r name; do formulae+=("$name"); done < <(sed -n -E 's/^brew "([^"]*)".*/\1/p' "$BREWFILE")
while IFS= read -r name; do casks+=("$name"); done < <(sed -n -E 's/^cask "([^"]*)".*/\1/p' "$BREWFILE")
while IFS= read -r name; do trusted+=("$name"); done < <(sed -n -E 's/^(brew|cask) "([^"]*)".*trusted: true.*/\2/p' "$BREWFILE")

# Third-party entries are named in full (user/repo/name): tap user/repo first, and trust it only where the Brewfile
# says trusted: true, as brew bundle does (Homebrew refuses to load from an untrusted tap)
for name in ${formulae[@]+"${formulae[@]}"} ${casks[@]+"${casks[@]}"}; do
  [[ $name == */*/* ]] && brew tap "${name%/*}" >/dev/null
done
for name in ${trusted[@]+"${trusted[@]}"}; do
  [[ $name == */*/* ]] && brew trust "${name%/*}" >/dev/null
done

failed=0
check() {
  local kind=$1 name=$2 json
  if ! json=$(brew info --json=v2 "--$kind" "$name" 2>&1); then
    echo "$kind not found in Homebrew: $name" >&2
    printf '%s\n' "$json" >&2
    failed=1
    return
  fi
  if jq -e '[.formulae[]?, .casks[]?] | any(.disabled == true)' <<<"$json" >/dev/null; then
    echo "$kind is disabled upstream and will not install: $name" >&2
    failed=1
  elif jq -e '[.formulae[]?, .casks[]?] | any(.deprecated == true)' <<<"$json" >/dev/null; then
    echo "warning: $kind is deprecated upstream: $name" >&2
  fi
}
for name in ${formulae[@]+"${formulae[@]}"}; do check formula "$name"; done
for name in ${casks[@]+"${casks[@]}"}; do check cask "$name"; done

echo "Brewfile: ${#formulae[@]} formulae and ${#casks[@]} casks checked"
exit "$failed"
