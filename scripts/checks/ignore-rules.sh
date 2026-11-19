#!/usr/bin/env bash
# git/ignore alone must cover credentials, and .gitignore must cover them in this repo
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
REPO_ROOT=$PWD
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE # set when run as a hook; the scratch repo must not inherit them

SCRATCH=$(mktemp -d)
trap 'rm -rf "$SCRATCH"' EXIT
git -C "$SCRATCH" init -q

for f in auth.json oauth_creds.json google_accounts.json .env AGENTS.local.md state.sqlite-wal; do
  git -C "$SCRATCH" -c core.excludesFile="$REPO_ROOT/git/ignore" check-ignore -q --no-index "$f" \
    || { echo "git/ignore does not ignore $f" >&2; exit 1; }
done
for f in auth.json oauth_creds.json google_accounts.json .env state.sqlite-wal; do
  git -c core.excludesFile=/dev/null check-ignore -q --no-index "$f" \
    || { echo ".gitignore does not ignore $f" >&2; exit 1; }
done
if git -C "$SCRATCH" -c core.excludesFile="$REPO_ROOT/git/ignore" check-ignore -q --no-index .env.example; then
  echo "git/ignore must not ignore .env.example" >&2
  exit 1
fi
