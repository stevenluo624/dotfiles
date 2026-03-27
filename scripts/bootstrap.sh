#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="git@github.com:YOUR_USERNAME/dotfiles.git"
OBSIDIAN_REPO="git@github.com:YOUR_USERNAME/obsidian-vault.git"

if ! command -v brew >/dev/null 2>&1; then
  echo "Install Homebrew first."
  exit 1
fi

if [ ! -d "$HOME/.dotfiles" ]; then
  git clone "$DOTFILES_REPO" "$HOME/.dotfiles"
fi

cd "$HOME/.dotfiles"

brew bundle --file="$HOME/.dotfiles/Brewfile"

"$HOME/.dotfiles/scripts/install.sh"

"$HOME/.dotfiles/mac/defaults.sh" || true

mkdir -p "$HOME/Documents/Obsidian"
if [ ! -d "$HOME/Documents/Obsidian/MyVault" ]; then
  git clone "$OBSIDIAN_REPO" "$HOME/Documents/'Obsidian Vault'"
fi

echo "Setup complete."
