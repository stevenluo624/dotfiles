# Dotfiles

Personal macOS-focused dotfiles for shell, Git, tmux, Neovim, and Homebrew-managed tools.

## First-Time Setup

On a fresh machine, the basic order is:

1. Install Homebrew.
2. Clone this repo to `~/.dotfiles`.
3. Symlink the config files into `$HOME`.
4. Run `brew bundle --file=~/.dotfiles/Brewfile`.
5. Run `bash ~/.dotfiles/mac/defaults.sh`.
6. Open a new shell session.
7. Run `bash ~/.dotfiles/scripts/update.sh` once to sync packages and Neovim plugins.

Minimal bootstrap commands:

```bash
git clone <your-dotfiles-repo> ~/.dotfiles
mkdir -p ~/.config
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/zsh/.zshenv ~/.zshenv
ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/git/.gitignore_global ~/.gitignore_global
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sfn ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/starship.toml ~/.config/starship.toml
brew bundle --file=~/.dotfiles/Brewfile
bash ~/.dotfiles/mac/defaults.sh
bash ~/.dotfiles/scripts/update.sh
```

## Repo Layout

- `zsh/`: Zsh config files
- `git/`: Git config and global ignore rules
- `tmux/`: tmux config
- `nvim/`: Neovim config
- `mac/`: macOS defaults
- `scripts/backup.sh`: back up current live dotfiles from `$HOME`
- `scripts/update.sh`: update the repo, Brewfile packages, and editor/tooling

## Expected Paths

This repo is meant to live at:

```bash
~/.dotfiles
```

The scripts assume that location unless you override values explicitly.

## Applying the Config

This repo does not currently use a bootstrap installer. Apply files manually or symlink the ones you want in `$HOME`.

Current expected live paths:

- `~/.zshrc` -> `~/.dotfiles/zsh/.zshrc`
- `~/.zshenv` -> `~/.dotfiles/zsh/.zshenv`
- `~/.zprofile` -> `~/.dotfiles/zsh/.zprofile`
- `~/.gitconfig` -> `~/.dotfiles/git/.gitconfig`
- `~/.gitignore_global` -> `~/.dotfiles/git/.gitignore_global`
- `~/.tmux.conf` -> `~/.dotfiles/tmux/.tmux.conf`
- `~/.config/nvim` -> `~/.dotfiles/nvim`
- `~/.config/starship.toml` -> `~/.dotfiles/starship.toml`

Example:

```bash
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/zsh/.zshenv ~/.zshenv
ln -sf ~/.dotfiles/zsh/.zprofile ~/.zprofile
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/git/.gitignore_global ~/.gitignore_global
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
mkdir -p ~/.config
ln -sfn ~/.dotfiles/nvim ~/.config/nvim
ln -sf ~/.dotfiles/starship.toml ~/.config/starship.toml
```

## Scripts

### `scripts/backup.sh`

Backs up the current live config from `$HOME` into timestamped directories under:

```bash
~/.dotfiles_backup
```

It currently backs up:

- `.zshrc`
- `.zshenv`
- `.zprofile`
- `.gitconfig`
- `.gitignore_global`
- `.tmux.conf`
- `.config/nvim`

Run it with:

```bash
bash ~/.dotfiles/scripts/backup.sh
```

You can override the destination:

```bash
BACKUP_DIR=/path/to/backups bash ~/.dotfiles/scripts/backup.sh
```

Each backup includes a generated `restore.sh`.

### `scripts/update.sh`

Updates:

- the `~/.dotfiles` git repo
- Homebrew metadata and installed packages
- packages declared in `Brewfile`
- Neovim plugins through `lazy.nvim`
- Rust toolchains if `rustup` is installed

Run it with:

```bash
bash ~/.dotfiles/scripts/update.sh
```

Optional overrides:

```bash
DOTFILES_REMOTE=origin DOTFILES_BRANCH=main bash ~/.dotfiles/scripts/update.sh
```

## Brewfile

The `Brewfile` is part of the repo and is applied by `scripts/update.sh` when Homebrew is installed.

To sync it manually:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

## macOS Defaults

macOS tweaks live in `mac/defaults.sh`.

Run manually if needed:

```bash
bash ~/.dotfiles/mac/defaults.sh
```
