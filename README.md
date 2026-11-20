# Dotfiles

Per-app configs for macOS and Ubuntu (including WSL2), symlinked into `~/.config` with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is one app; paths inside mirror their path under `~/.config`. `aerospace`, `ghostty`, `homebrew` and `sketchybar` are macOS only; `bash` is Ubuntu only. `--packages` installs each platform's packages (Homebrew on macOS; apt and mise on Ubuntu).

| Folder     | Installed to                                   |
| ---------- | ---------------------------------------------- |
| `zsh`      | `~/.config/zsh` (via `ZDOTDIR`)                |
| `bash`     | `~/.config/bash/env.bash`, sourced from the bash startup files (Ubuntu) |
| `nvim`     | `~/.config/nvim`                               |
| `starship` | `~/.config/starship/starship.toml`             |
| `aerospace`| `~/.config/aerospace/aerospace.toml`          |
| `fastfetch`| `~/.config/fastfetch/config.jsonc`            |
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

`setup.sh` detects macOS or Ubuntu, installs what it needs to run (stow via Homebrew on macOS; git, curl, stow and zsh via apt on Ubuntu), moves any conflicting existing file into `~/.dotfiles-backup/<timestamp>/`, runs `stow`, writes `~/.zshenv` (sets `ZDOTDIR` and sources `zsh/.zshenv`) if missing, and links the apps that do not read `~/.config`. On Ubuntu it also adds one line that sources `~/.config/bash/env.bash` to `~/.profile`, `~/.bashrc` and, if they exist, `~/.bash_profile` and `~/.bash_login`, so bash finds `~/.local/bin` and the mise shims. It is safe to re-run.

- `--packages` installs the platform's packages, followed by `mise install --locked`. On macOS that is `homebrew/Brewfile` (and `~/.corp/Brewfile`, if present); Homebrew itself is not installed for you, get it from <https://brew.sh> first. On Ubuntu it installs apt packages, enables and installs mise via `extrepo`, and installs the locked mise tools.
- `--skills` installs the agent skills listed in `agents/skills.txt` into `~/.agents/skills`, linked for Claude Code. Skills are not vendored, and each manifest line must be pinned to a tag or commit.

On WSL2 clone inside the Ubuntu instance (not under `/mnt/c`), where symlinks behave. zsh drops the `/mnt/c/...` Windows directories from `PATH` (`zsh/.zshenv`), because scanning them over the 9P mount added ~40 ms to every new shell; `zsh/aliases.zsh` keeps `explorer.exe`, `clip.exe` and `powershell.exe` reachable by full path. WezTerm on the Windows side is not managed by this repo.

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

Anything private or specific to one machine stays out of this repo. `zsh/core.zsh` silently sources `~/.corp/env.zsh` if it exists; put local environment variables, certificates and PATH entries there. Dotfiles commits are unsigned (`git/personal` sets `commit.gpgsign = false`); corporate repositories keep signing through `~/.corp/gitconfig`.

The Proton Pass SSH agent is opt-in per machine: `touch ~/.config/proton-pass-agent.enabled` makes `zsh/.zshenv` export `SSH_AUTH_SOCK` and `zsh/tools.zsh` start `pass-cli ssh-agent daemon start` in the background when it is not running. Keep SSH keys as Proton Pass SSH Key items (`pass-cli item create ssh-key generate --title <name> --vault-name <vault>`) and only the public halves on disk. Start the daemon from a login shell: under systemd, pass-cli cannot read its key from the kernel keyring and forces a logout. A machine without the marker (a work laptop) keeps its own agent.

`git/config` sets only the name and `user.useConfigOnly`, so a fresh machine needs a `user.email` before git will commit: set it in `~/.gitconfig`, or in `~/.corp/gitconfig` on a work machine. Git reads `~/.gitconfig` after `git/config`, so an email there also applies in this repo and overrides the address from `git/personal`; use the same noreply address in both if you want them identical. Signing is per machine as well: a personal machine signs with an SSH key by setting `gpg.format = ssh`, `user.signingkey` (the `.pub` path), `commit.gpgsign` and `tag.gpgSign` in `~/.gitconfig` (which also overrides the `gpgsign = false` in `git/personal`), plus `gpg.ssh.allowedSignersFile` so `git log --show-signature` can verify locally. Add the public key to GitHub as a Signing Key (`gh ssh-key add <key>.pub --type signing`, which needs `gh auth refresh -s admin:ssh_signing_key`), and keep the commit email set to the noreply address so GitHub marks the commits verified.

## macOS System Defaults

`macos/macos.sh` configures developer-friendly macOS defaults (fast key repeat rate, press-and-hold disabled for Vim hjkl, instant Dock autohide, smart dashes/quotes disabled, hidden files visible in Finder, clean screenshot shadows).

```bash
./macos/macos.sh         # apply settings
./macos/macos-revert.sh  # restore factory defaults anytime
```

## Checks

`.pre-commit-config.yaml` defines every check (secret scanning, shell and Lua linting, `zsh -n`, a stow simulation for both platforms, workflow linting). `setup.sh` installs it as the git hook, and `./check.sh` runs it on all files.

CI (`lint.yml`, "Lint & Security") runs the same config with pinned, least-privilege actions. `install.yml` ("Install Smoke Test") runs `setup.sh` twice on clean macOS and Ubuntu runners to prove it works and is idempotent. Hook and action versions are pinned to commit SHAs and updated by Dependabot.
