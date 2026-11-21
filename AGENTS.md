# Dotfiles

Dotfiles for macOS and Ubuntu (WSL2 is plain Ubuntu), linked into `~/.config` with GNU Stow. Public repo: no secrets, hostnames or employer details.

## Commands

- `./check.sh`: every pre-commit hook on all files, including the stow simulation; `pre-commit run --files <file>...` for a few. `.pre-commit-config.yaml` is the single source of truth for the git hook, `./check.sh` and CI.
- `./setup.sh`: idempotent; re-run it after adding, moving or removing linked files (it prunes dead links).
- `zsh -lic exit`: must print nothing to stderr (CI checks this; the hooks only run `zsh -n`).

## Boundaries

- Never track files that tools rewrite at runtime or that hold local state: `~/.claude/settings.json`, `~/.codex/config.toml`, auth and OAuth files, session databases. Seed a minimal file instead (see the `pi` block in `setup.sh`).
- Never install a tool that mise manages with `npm install -g`, pip or brew: it shadows the pinned version and skips the release-age check. Add it to `mise/config.toml`, then `mise install` and `mise lock --global`; `mise which <tool>` shows which binary wins. No `npm:` tools in mise: they need sidecar lockfiles (`mise/.mise/locks/`) without per-platform checksums, so install those per project.
- Never name `~/.corp/` anywhere new. Private or employer-specific config (`env.zsh`, `gitconfig`, `Brewfile`) lives there, and only the files that read it (`zsh/core.zsh`, `git/config`, `scripts/platform/macos.sh`) and `README.md`, which documents it, mention it.
- Ask first before `./setup.sh --packages` (sudo, apt or Homebrew, system config) and before touching `~/.corp/` or `~/.dotfiles-backup/`.

## Layout

- A new config package is a top-level folder mirroring `~/.config/<app>/`, listed in `scripts/lib/platform.sh` (the only list). Any other new top-level file or folder needs an anchored ignore line in `.stowrc` (`--ignore` is a regex on the end of the path, so write `^name$`); `scripts/checks/stow.sh` says what is wrong.
- Machine-specific git ignore patterns go in that repo's `.git/info/exclude`, not `git/ignore`.

## CLI tools

mise owns dev CLIs and runtimes (`mise/config.toml`, locked in `mise/mise.lock`). A tool stays with the OS package manager (Homebrew on macOS, which `setup.sh` never installs; apt on Ubuntu) if mise has no checksum-verified upstream build on all four platforms or the tool must work outside zsh (`eza`, `btop`, `gh`, `direnv`). Known exceptions: `git-delta` (no macOS Intel build: Homebrew and apt), `jless` (no Linux ARM build, not in apt: macOS only), `gcloud` (mise has only a vfox plugin with an optional checksum, and gcloud updates itself: `gcloud-cli` cask, extrepo `google_cloud`).

Dependabot does not cover mise. Bump by hand: `mise outdated`, `mise upgrade --bump`, `mise lock --global`.

## Checks and commits

- The full package installs (`./setup.sh --packages` on macOS and Ubuntu) run weekly in CI, not on pull requests: after editing a package list (`homebrew/Brewfile`, the apt list in `scripts/platform/ubuntu.sh`), run `gh workflow run install.yml --ref <branch>` before merging.
- Pin hooks and actions to full commit SHAs with the version in a comment (`pre-commit autoupdate --freeze`).
- Hooks must not download at install time (a TLS-intercepting proxy breaks Python's strict verification): use PyPI wheels via `additional_dependencies`, `language_version: system` for Go, or system tools.
- If a hook fails on a stale environment (old `GOROOT`), run `./check.sh` from a fresh login shell.
- Commit style: `type(scope): lowercase summary`, e.g. `feat(lazygit): add config`. No tool attribution in commit messages or PR descriptions: no `Co-authored-by` for bots or agents, no "Generated with" lines.
