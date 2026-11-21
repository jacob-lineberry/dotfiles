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

formulae=() casks=()
while IFS= read -r name; do formulae+=("$name"); done < <(brew bundle list --file="$BREWFILE" --formula)
while IFS= read -r name; do casks+=("$name"); done < <(brew bundle list --file="$BREWFILE" --cask)

# Third-party entries are named in full (user/repo/name): tap user/repo first, as brew bundle does
for name in ${formulae[@]+"${formulae[@]}"} ${casks[@]+"${casks[@]}"}; do
  if [[ $name == */*/* ]]; then brew tap "${name%/*}" >/dev/null; fi
done

failed=0
check() {
  local kind=$1 name=$2 json
  if ! json=$(brew info --json=v2 "--$kind" "$name" 2>&1); then
    echo "$kind not found in Homebrew: $name" >&2
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
