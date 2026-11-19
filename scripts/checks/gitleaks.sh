#!/usr/bin/env bash
# Staged changes at commit time, the working tree otherwise (check.sh)
set -euo pipefail

command -v gitleaks >/dev/null || { echo "gitleaks not found (brew install gitleaks)" >&2; exit 1; }
cd "$(git rev-parse --show-toplevel)"
if git diff --cached --quiet; then
  exec gitleaks dir . --redact --no-banner
fi
exec gitleaks git --pre-commit --staged --redact --no-banner
