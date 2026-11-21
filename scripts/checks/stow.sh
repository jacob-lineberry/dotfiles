#!/usr/bin/env bash
# On every supported platform stow must link exactly the files of the config packages in scripts/lib/platform.sh.
# It is simulated against an empty target and compared file by file with git, so a new top-level file or folder
# that is not ignored in .stowrc fails here instead of silently landing in ~/.config, and so does an --ignore
# rule that is loose enough to drop a nested file (stow matches each rule against the end of the whole path).
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
# shellcheck source=../lib/platform.sh
source scripts/lib/platform.sh
command -v stow >/dev/null || { echo "stow not found (brew install stow or apt install stow)" >&2; exit 1; }

SCRATCH=$(mktemp -d)
trap 'rm -rf "$SCRATCH"' EXIT

for platform in macos ubuntu; do
  ignores=() pkgs=()
  while IFS= read -r ignore; do ignores+=("$ignore"); done < <(platform_stow_ignores "$platform")
  while IFS= read -r pkg; do pkgs+=("$pkg"); done < <(platform_packages "$platform")
  mkdir -p "$SCRATCH/$platform"
  if ! OUT=$(stow -n -v -t "$SCRATCH/$platform" ${ignores[@]+"${ignores[@]}"} . 2>&1); then
    echo "$OUT" >&2
    exit 1
  fi
  linked=$(sed -n 's/^LINK: \(.*\) => .*/\1/p' <<<"$OUT" | sort -u)
  # tracked files plus new ones git would add, i.e. what the commit will contain
  expected=$(git ls-files --cached --others --exclude-standard -- "${pkgs[@]}" | sort -u)
  stray=$(comm -23 <(printf '%s\n' "$linked") <(printf '%s\n' "$expected"))
  missing=$(comm -13 <(printf '%s\n' "$linked") <(printf '%s\n' "$expected"))
  if [[ -n $stray ]]; then
    echo "$platform: stow would link paths that are not files of a config package (ignore them in .stowrc, or add the package to scripts/lib/platform.sh):" >&2
    echo "$stray" >&2
    exit 1
  fi
  if [[ -n $missing ]]; then
    echo "$platform: files of a config package that stow does not link (an --ignore rule in .stowrc is probably too loose; anchor it with ^ and \$):" >&2
    echo "$missing" >&2
    exit 1
  fi
done
