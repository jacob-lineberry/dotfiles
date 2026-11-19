# Dotfiles

Per-app configs, symlinked into `~/.config` with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is one app; paths inside mirror their path under `~/.config`.

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
| `homebrew` | `~/.config/homebrew/Brewfile`                  |
| `lazygit`  | `~/.config/lazygit/config.yml`                |
| `mise`     | `~/.config/mise/config.toml`                   |
| `sketchybar`| `~/.config/sketchybar`                        |
| `yazi`     | `~/.config/yazi`                               |
| `tuios`    | `~/Library/Application Support/tuios` (macOS)  |
| `pi`       | `~/.pi/agent/settings.json` (seeded if absent) |

## Install

```bash
brew install stow
git clone https://github.com/jacob-lineberry/dotfiles ~/dotfiles
cd ~/dotfiles && ./setup.sh
```

`setup.sh` moves any conflicting existing file into `~/.dotfiles-backup/<timestamp>/`, runs `stow .`, writes `~/.zshenv` (sets `ZDOTDIR` and sources `zsh/.zshenv`) if missing, and links the apps that do not read `~/.config`. It is safe to re-run. Pass `--brew` to also install the packages in `homebrew/Brewfile` (and `~/.corp/Brewfile`, if present).

`.stowrc` uses `--no-folding`, so only individual files are linked and runtime files (shell history, k9s state) stay out of the repo.

## Machine-specific config

Anything private or specific to one machine stays out of this repo. `zsh/core.zsh` silently sources `~/.corp/env.zsh` if it exists; put local environment variables, certificates and PATH entries there.

## macOS System Defaults

`macos/macos.sh` configures developer-friendly macOS defaults (fast key repeat rate, press-and-hold disabled for Vim hjkl, instant Dock autohide, smart dashes/quotes disabled, hidden files visible in Finder, clean screenshot shadows).

```bash
./macos/macos.sh         # apply settings
./macos/macos-revert.sh  # restore factory defaults anytime
```

## Quality & Safety Checks

Run `./check.sh` locally to validate dotfiles integrity:

```bash
./check.sh
```

It checks:
- **Secrets**: `gitleaks` scans working tree or staged changes
- **Shell**: `shellcheck` lints all shell scripts
- **Zsh syntax**: `zsh -n` verifies all shell configs
- **Lua formatting**: `stylua --check` validates Neovim configurations
- **Stow health**: verifies clean symlinking without conflicts

`setup.sh` automatically installs `./check.sh` as a Git `pre-commit` hook. The same checks run in CI via GitHub Actions.
