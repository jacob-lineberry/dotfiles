# Dotfiles

Per-app configs, symlinked into `~/.config` with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is one app; paths inside mirror their path under `~/.config`.

| Folder     | Installed to                                   |
| ---------- | ---------------------------------------------- |
| `zsh`      | `~/.config/zsh` (via `ZDOTDIR`)                |
| `nvim`     | `~/.config/nvim`                               |
| `starship` | `~/.config/starship/starship.toml`             |
| `ghostty`  | `~/.config/ghostty`                            |
| `bat`      | `~/.config/bat`                                |
| `eza`      | `~/.config/eza`                                |
| `k9s`      | `~/.config/k9s`                                |
| `homebrew` | `~/.config/homebrew/Brewfile`                  |
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
