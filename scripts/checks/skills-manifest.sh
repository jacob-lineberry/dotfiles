#!/usr/bin/env bash
# agents/skills.txt: "<owner/repo@ref> <skill>" per line, every source pinned
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
BAD=$(awk '!/^[[:space:]]*(#|$)/ && (NF != 2 || $1 !~ /@/)' agents/skills.txt)
[[ -z $BAD ]] || { echo "agents/skills.txt needs '<source>@<ref> <skill>' per line:" >&2; echo "$BAD" >&2; exit 1; }
