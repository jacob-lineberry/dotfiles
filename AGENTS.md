# Dotfiles

Dotfiles for macOS and Ubuntu (WSL2 is plain Ubuntu), linked into `~/.config` with GNU Stow. Public repo: no secrets, hostnames or employer details.

## Commands

- `./check.sh`: every pre-commit hook on all files; `pre-commit run --files <file>...` for a few.
- `./setup.sh`: idempotent; re-run it after adding, moving or removing linked files.
- `scripts/checks/stow.sh`: simulates stow for both platforms against an empty target.
- `zsh -lic exit`: must print nothing to stderr (CI checks this).

## Boundaries

- Never track files that tools rewrite at runtime or that hold local state: `~/.claude/settings.json`, `~/.codex/config.toml`, auth and OAuth files, session databases. Seed a minimal file instead (see the `pi` block in `setup.sh`).
- Never `npm install -g` a tool that mise manages (e.g. `openspec`): it shadows the pinned version and skips the release-age check. Add it to `mise/config.toml`, then `mise install` and `mise lock --global`; `mise which <tool>` shows which binary wins.
- Never name `~/.corp/` anywhere new. Private or employer-specific config (`env.zsh`, `gitconfig`, `Brewfile`) lives there, and only the three files that read it mention it.
- Ask first before `./setup.sh --packages` (sudo, apt or Homebrew, system config) and before touching `~/.corp/` or `~/.dotfiles-backup/`.

## Layout

- Each config package is a top-level folder mirroring `~/.config/<app>/` (`.stowrc`: `--target=~/.config --no-folding`). Packages are listed only in `scripts/lib/platform.sh`: `COMMON_PACKAGES`, `MACOS_PACKAGES`, `UBUNTU_PACKAGES`.
- A new config package goes in `platform.sh`; any other new top-level file or folder needs an ignore line in `.stowrc`. `--ignore` is a suffix regex on the file name, so anchor it (`^agents$`).
- Not stowed: `tuios` (linked per platform), `pi` (settings seeded if absent), `macos` (defaults scripts).
- `bash/env.bash` (Ubuntu only) is sourced from `~/.profile`, which dash also reads, so it must stay POSIX sh.
- `install.sh` only fetches the repo and runs `setup.sh`. `scripts/platform/{macos,ubuntu}.sh` implement the same functions (`platform_prerequisites`, `platform_install_packages`, `platform_tuios_dir`); `DOTFILES_PLATFORM=macos|ubuntu` overrides detection.
- Machine-specific git ignore patterns go in that repo's `.git/info/exclude`, not `git/ignore`.

## CLI tools

mise owns dev CLIs and runtimes (`mise/config.toml`, locked in `mise/mise.lock` for all four platforms). A tool stays with the OS package manager (Homebrew on macOS, which `setup.sh` never installs; apt on Ubuntu) if mise has no checksum-verified upstream build on all four platforms or the tool must work outside zsh (`eza`, `btop`, `gh`, `direnv`). Exceptions worth knowing:

- `git-delta`: no macOS Intel build. Homebrew on macOS, apt on Ubuntu.
- `jless`: no Linux ARM build and not in apt. macOS only.
- `gcloud`: mise has only a vfox plugin with a same-bucket, optional checksum, and gcloud updates itself. `gcloud-cli` cask on macOS, extrepo `google_cloud` (a `non-free` policy repo) on Ubuntu.

Dependabot does not cover mise. Bump by hand with `mise outdated`, `mise upgrade --bump`, `mise lock --global`; `minimum_release_age = "7d"` holds back brand-new releases.

## Checks and commits

- `.pre-commit-config.yaml` is the single source of truth: the git hook, `./check.sh` and CI (`lint.yml`) all run it. `install.yml` runs `setup.sh` twice on clean macOS and Ubuntu runners.
- Hooks and actions are pinned to full commit SHAs with the version in a comment (`pre-commit autoupdate --freeze`).
- Hooks must not download at install time (a TLS-intercepting proxy breaks Python's strict verification): use PyPI wheels via `additional_dependencies`, `language_version: system` for Go, or system tools.
- If a hook fails on a stale environment (old `GOROOT`), run `./check.sh` from a fresh login shell.
- Commit style: `type(scope): lowercase summary`, e.g. `feat(lazygit): add config`. No tool attribution in commit messages or PR descriptions: no `Co-authored-by` for bots or agents, no "Generated with" lines.
