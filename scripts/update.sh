#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REMOTE="${DOTFILES_REMOTE:-origin}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
  printf "%b\n" "$1"
}

run_step() {
  local description="$1"
  shift

  log "${YELLOW}${description}...${NC}"
  if "$@"; then
    log "${GREEN}✓ ${description}${NC}"
  else
    log "${RED}✗ ${description}${NC}"
  fi
}

log "${GREEN}Updating system and dotfiles...${NC}"

if [[ -d "$DOTFILES_DIR/.git" ]]; then
  cd "$DOTFILES_DIR"
  run_step "Updating dotfiles repository" git pull --ff-only "$DOTFILES_REMOTE" "$DOTFILES_BRANCH"

  if command -v brew >/dev/null 2>&1 && [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    run_step "Syncing Brewfile packages" brew bundle --file="$DOTFILES_DIR/Brewfile"
  fi
else
  log "${RED}Dotfiles repository not found at $DOTFILES_DIR${NC}"
fi

if command -v brew >/dev/null 2>&1; then
  run_step "Updating Homebrew formula metadata" brew update
  run_step "Upgrading Homebrew packages" brew upgrade
  run_step "Cleaning Homebrew cache" brew cleanup --prune=all
else
  log "${YELLOW}Homebrew not found, skipping...${NC}"
fi

if command -v nvim >/dev/null 2>&1; then
  run_step "Updating Neovim plugins" nvim --headless "+Lazy! sync" +qa
else
  log "${YELLOW}Neovim not found, skipping...${NC}"
fi

if command -v softwareupdate >/dev/null 2>&1; then
  log "${YELLOW}Checking for macOS updates...${NC}"
  softwareupdate -l || true
  log "${YELLOW}Run 'sudo softwareupdate -i -a' to install available updates${NC}"
fi

if command -v rustup >/dev/null 2>&1; then
  run_step "Updating Rust toolchains" rustup update
fi

log "${GREEN}Update complete!${NC}"
log "${YELLOW}System information:${NC}"
sw_vers -productVersion | sed 's/^/macOS: /'

if command -v brew >/dev/null 2>&1; then
  brew --version | head -1 | sed 's/^/Homebrew: /'
fi

if command -v nvim >/dev/null 2>&1; then
  nvim --version | head -1 | sed 's/^/Neovim: /'
fi

if command -v git >/dev/null 2>&1; then
  git --version | sed 's/^/Git: /'
fi

if command -v node >/dev/null 2>&1; then
  node --version | sed 's/^/Node.js: /'
fi

if command -v python3 >/dev/null 2>&1; then
  python3 --version | sed 's/^/Python: /'
fi
