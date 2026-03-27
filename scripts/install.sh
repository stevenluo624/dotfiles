#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

mkdir -p "$HOME/.config"

ln -sf "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"

ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"

ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"

ln -sfn "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "Dotfiles installed."
