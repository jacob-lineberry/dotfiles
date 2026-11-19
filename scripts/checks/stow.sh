#!/usr/bin/env bash
# On every supported platform stow must link exactly the config packages in scripts/lib/platform.sh. It is
# simulated against an empty target, so a new top-level file or folder that is not ignored in .stowrc
# fails here instead of silently landing in ~/.config.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
# shellcheck source=../lib/platform.sh
source scripts/lib/platform.sh
command -v stow >/dev/null || { echo "stow not found (brew install stow or apt install stow)" >&2; exit 1; }

SCRATCH=$(mktemp -d)
trap 'rm -rf "$SCRATCH"' EXIT

for platform in macos ubuntu; do
  ignores=()
  while IFS= read -r ignore; do ignores+=("$ignore"); done < <(platform_stow_ignores "$platform")
  mkdir -p "$SCRATCH/$platform"
  if ! OUT=$(stow -n -v -t "$SCRATCH/$platform" ${ignores[@]+"${ignores[@]}"} . 2>&1); then
    echo "$OUT" >&2
    exit 1
  fi
  linked=$(awk '/^LINK: /{print $2}' <<<"$OUT" | cut -d/ -f1 | sort -u)
  expected=$(platform_packages "$platform" | sort)
  stray=$(comm -23 <(printf '%s\n' "$linked") <(printf '%s\n' "$expected"))
  missing=$(comm -13 <(printf '%s\n' "$linked") <(printf '%s\n' "$expected"))
  if [[ -n $stray ]]; then
    echo "$platform: stow would link paths that are not config packages (ignore them in .stowrc, or add them to scripts/lib/platform.sh):" >&2
    echo "$stray" >&2
    exit 1
  fi
  if [[ -n $missing ]]; then
    echo "$platform: packages in scripts/lib/platform.sh that stow does not link:" >&2
    echo "$missing" >&2
    exit 1
  fi
done
