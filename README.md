# Dotfiles

Per-app configs for macOS and Ubuntu (including WSL2), symlinked into `~/.config` with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is one app; paths inside mirror their path under `~/.config`. `aerospace`, `ghostty`, `homebrew` and `sketchybar` are macOS only; `bash` is Ubuntu only.

| Folder     | Installed to                                   |
| ---------- | ---------------------------------------------- |
| `zsh`      | `~/.config/zsh` (via `ZDOTDIR`)                |
| `bash`     | `~/.config/bash/env.bash`, sourced from the bash startup files (Ubuntu) |
| `nvim`     | `~/.config/nvim`                               |
| `starship` | `~/.config/starship/starship.toml`             |
| `aerospace`| `~/.config/aerospace/aerospace.toml`          |
| `fastfetch`| `~/.config/fastfetch/config.jsonc`            |
| `git`      | `~/.config/git`                                |
| `ghostty`  | `~/.config/ghostty`                            |
| `atuin`    | `~/.config/atuin/config.toml` (local-only shell history, Ctrl-R) |
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

## Install

```bash
git clone https://github.com/jacob-lineberry/dotfiles ~/dotfiles
cd ~/dotfiles && ./setup.sh
```

Or bootstrap a fresh machine in one line (`install.sh` only clones the repo, installing git on Ubuntu if missing, and runs `setup.sh`, so read it first):

```bash
curl -fsSL https://raw.githubusercontent.com/jacob-lineberry/dotfiles/main/install.sh | bash -s -- --packages
```

`setup.sh` is safe to re-run. It:

- detects macOS or Ubuntu and installs what it needs (stow via Homebrew on macOS; git, curl, stow and zsh via apt on Ubuntu),
- moves any conflicting file into `~/.dotfiles-backup/<timestamp>/`,
- runs `stow`, writes `~/.zshenv` if missing (sets `ZDOTDIR`), and links the apps that do not read `~/.config`,
- on Ubuntu, makes bash load `~/.config/bash/env.bash` so it finds `~/.local/bin` and the mise shims.

Optional flags:

- `--packages` installs the platform's packages, then `mise install --locked`. On macOS: `homebrew/Brewfile` (and `~/.corp/Brewfile`, if present); install Homebrew from <https://brew.sh> first. On Ubuntu: apt packages, plus mise and the Google Cloud CLI via `extrepo` (which turns on its `non-free` policy for Google's repo).

To update: `git pull && ./setup.sh`. To unlink one app: `stow -D <folder>` from the repo.

On WSL2, clone inside the Ubuntu instance (not under `/mnt/c`), where symlinks behave. zsh drops the `/mnt/c/...` Windows directories from `PATH` to keep startup fast; `zsh/aliases.zsh` keeps `explorer.exe`, `clip.exe` and `powershell.exe` reachable by full path. WezTerm on the Windows side is not managed by this repo.

## Machine-specific config

Anything private or specific to one machine stays out of this repo. `zsh/core.zsh` silently sources `~/.corp/env.zsh` if it exists; put local environment variables, certificates and PATH entries there. Corporate repositories sign through `~/.corp/gitconfig`.

The Proton Pass SSH agent is opt-in per machine: `touch ~/.config/proton-pass-agent.enabled` makes zsh export `SSH_AUTH_SOCK` and start `pass-cli ssh-agent daemon start` if it is not running. Keep SSH keys as Proton Pass SSH Key items (`pass-cli item create ssh-key generate --title <name> --vault-name <vault>`), with only the public halves on disk. Start the daemon from a login shell: under systemd, pass-cli cannot read its key from the kernel keyring and forces a logout. Without the marker (a work laptop), the machine keeps its own agent.

Git identity and signing on a new machine:

1. `git/config` sets only the name and `user.useConfigOnly`, so git refuses to commit until `user.email` is set: in `~/.gitconfig`, or in `~/.corp/gitconfig` on a work machine. In this repo `git/personal` supplies the noreply address, but an email in `~/.gitconfig` overrides it, so use the same address in both.
2. Dotfiles commits are unsigned (`git/personal` sets `commit.gpgsign = false`) unless `~/.gitconfig` turns signing on. To sign with SSH, set `gpg.format = ssh`, `user.signingkey` (the `.pub` path), `commit.gpgsign`, `tag.gpgSign` and `gpg.ssh.allowedSignersFile` there.
3. Add the key to GitHub as a signing key (`gh auth refresh -s admin:ssh_signing_key`, then `gh ssh-key add <key>.pub --type signing`) and commit with the noreply address so GitHub marks commits verified.

## macOS System Defaults

`macos/macos.sh` configures developer-friendly macOS defaults (fast key repeat rate, press-and-hold disabled for Vim hjkl, instant Dock autohide, smart dashes/quotes disabled, hidden files visible in Finder, clean screenshot shadows).

```bash
./macos/macos.sh         # apply settings
./macos/macos-revert.sh  # restore factory defaults anytime
```

## Checks

`.pre-commit-config.yaml` defines every check (secret scanning, shell and Lua linting, `zsh -n`, a stow simulation for both platforms, workflow linting). `setup.sh` installs it as the git hook, `./check.sh` runs it on all files, and CI (`lint.yml`) runs the same config. `install.yml` runs `setup.sh` twice on clean macOS and Ubuntu runners to prove it works and is idempotent, and installs every locked mise tool on both. The full package installs (`./setup.sh --packages`, apt and Homebrew) run there weekly and on demand. Hooks and actions are pinned to commit SHAs and updated by Dependabot.
