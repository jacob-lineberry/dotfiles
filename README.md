# Dotfiles

Per-app configs for macOS and Ubuntu (including WSL2), symlinked into `~/.config` with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is one app; paths inside mirror their path under `~/.config`. `aerospace`, `ghostty`, `homebrew` and `sketchybar` are macOS only. macOS is the complete setup; Ubuntu currently gets prerequisites and the shared configs only (package installation will use apt).

| Folder     | Installed to                                   |
| ---------- | ---------------------------------------------- |
| `zsh`      | `~/.config/zsh` (via `ZDOTDIR`)                |
| `nvim`     | `~/.config/nvim`                               |
| `starship` | `~/.config/starship/starship.toml`             |
| `aerospace`| `~/.config/aerospace/aerospace.toml`          |
| `fastfetch`| `~/.config/fastfetch/config.jsonc`            |
| `ghostty`  | `~/.config/ghostty`                            |
| `bat`      | `~/.config/bat`                                |
| `btop`     | `~/.config/btop`                               |
| `eza`      | `~/.config/eza`                                |
| `k9s`      | `~/.config/k9s`                                |
| `homebrew` | `~/.config/homebrew/Brewfile` (macOS)          |
| `lazygit`  | `~/.config/lazygit/config.yml`                |
| `mise`     | `~/.config/mise/config.toml`                   |
| `sketchybar`| `~/.config/sketchybar`                        |
| `yazi`     | `~/.config/yazi`                               |
| `tuios`    | `~/Library/Application Support/tuios` (macOS), `~/.config/tuios` (Ubuntu) |
| `pi`       | `~/.pi/agent/settings.json` (seeded if absent) |
| `agents`   | `agents/skills.txt`, installed by `--skills`   |

## Install

```bash
git clone https://github.com/jacob-lineberry/dotfiles ~/dotfiles
cd ~/dotfiles && ./setup.sh
```

Or bootstrap a fresh machine in one line (`install.sh` only clones the repo, installing git on Ubuntu if missing, and runs `setup.sh`, so read it first):

```bash
curl -fsSL https://raw.githubusercontent.com/jacob-lineberry/dotfiles/main/install.sh | bash -s -- --packages
```

`setup.sh` detects macOS or Ubuntu, installs what it needs to run (stow via Homebrew on macOS; git, curl, stow and zsh via apt on Ubuntu), moves any conflicting existing file into `~/.dotfiles-backup/<timestamp>/`, runs `stow`, writes `~/.zshenv` (sets `ZDOTDIR` and sources `zsh/.zshenv`) if missing, and links the apps that do not read `~/.config`. It is safe to re-run.

- `--packages` installs the platform's packages. On macOS that is `homebrew/Brewfile` (and `~/.corp/Brewfile`, if present); Homebrew itself is not installed for you, get it from <https://brew.sh> first. On Ubuntu it is not set up yet and exits with a message; packages will come from apt, not Homebrew.
- `--skills` installs the agent skills listed in `agents/skills.txt` into `~/.agents/skills`, linked for Claude Code. Skills are not vendored, and each manifest line must be pinned to a tag or commit.

On WSL2 clone inside the Ubuntu instance (not under `/mnt/c`), where symlinks behave. WezTerm on the Windows side is not managed by this repo.

`setup.sh` also links `git/ignore` to `~/.gitignore_global`, because a machine-specific git config can point `core.excludesFile` there and shadow `~/.config/git/ignore`.

`.stowrc` uses `--no-folding`, so only individual files are linked and runtime files (shell history, k9s state) stay out of the repo.

### Scripts

| Path | Role |
| --- | --- |
| `install.sh` | fetch the repo, then run `setup.sh` |
| `setup.sh` | orchestrator: platform, prerequisites, link, `--packages`, `--skills`, git hook |
| `scripts/lib/` | sourced helpers and the package list (`platform.sh`) |
| `scripts/platform/` | `macos.sh` and `ubuntu.sh`, the same functions per platform |
| `scripts/checks/` | what pre-commit and CI run |

## Machine-specific config

Anything private or specific to one machine stays out of this repo. `zsh/core.zsh` silently sources `~/.corp/env.zsh` if it exists; put local environment variables, certificates and PATH entries there.

## macOS System Defaults

`macos/macos.sh` configures developer-friendly macOS defaults (fast key repeat rate, press-and-hold disabled for Vim hjkl, instant Dock autohide, smart dashes/quotes disabled, hidden files visible in Finder, clean screenshot shadows).

```bash
./macos/macos.sh         # apply settings
./macos/macos-revert.sh  # restore factory defaults anytime
```

## Quality & Safety Checks

`.pre-commit-config.yaml` drives everything, locally and in CI:

```bash
./check.sh   # pre-commit run --all-files
```

- **Secrets**: `gitleaks` on staged changes (working tree via `check.sh`); CI also scans full history
- **Hygiene**: large files, merge conflicts, private keys, YAML/TOML syntax, symlinks
- **Shell**: `shellcheck` on setup, check, install and the helper scripts
- **Zsh syntax**: `zsh -n` verifies all shell configs
- **Lua formatting**: `stylua --check` validates Neovim configurations
- **Workflows**: `actionlint` and `zizmor` lint `.github/`
- **Stow health**: simulates stow for macOS and Ubuntu and fails on conflicts or unexpected links
- **Ignore rules**: credential files stay ignored by both `git/ignore` and `.gitignore`
- **Skills manifest**: every `agents/skills.txt` entry is pinned

`setup.sh` installs the pre-commit hook. CI (`lint.yml`, "Lint & Security") runs the same config with pinned, least-privilege actions; `install.yml` ("Install Smoke Test") runs `setup.sh` twice on clean macOS and Ubuntu 24.04 and 26.04 runners to prove it works and is idempotent. Hook and action versions are pinned to commit SHAs and updated by Dependabot.
