#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles_backup}"
TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
BACKUP_PATH="$BACKUP_DIR/backup_$TIMESTAMP"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
  printf "%b\n" "$1"
}

log "${GREEN}Creating backup of current dotfiles...${NC}"
mkdir -p "$BACKUP_PATH/.config"

files=(
  ".zshrc"
  ".zshenv"
  ".zprofile"
  ".gitconfig"
  ".gitignore_global"
  ".tmux.conf"
)

dirs=(
  ".config/nvim"
)

log "${YELLOW}Backing up files...${NC}"
for file in "${files[@]}"; do
  if [[ -f "$HOME/$file" ]]; then
    cp "$HOME/$file" "$BACKUP_PATH/"
    log "${GREEN}✓ Backed up $file${NC}"
  fi
done

log "${YELLOW}Backing up directories...${NC}"
for dir in "${dirs[@]}"; do
  if [[ -d "$HOME/$dir" ]]; then
    mkdir -p "$BACKUP_PATH/$(dirname "$dir")"
    cp -R "$HOME/$dir" "$BACKUP_PATH/$dir"
    log "${GREEN}✓ Backed up $dir${NC}"
  fi
done

cat >"$BACKUP_PATH/restore.sh" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Restoring dotfiles from backup..."

for file in .zshrc .zshenv .zprofile .gitconfig .gitignore_global .tmux.conf; do
  if [[ -f "$BACKUP_DIR/$file" ]]; then
    cp "$BACKUP_DIR/$file" "$HOME/"
    echo "✓ Restored $file"
  fi
done

if [[ -d "$BACKUP_DIR/.config/nvim" ]]; then
  rm -rf "$HOME/.config/nvim"
  mkdir -p "$HOME/.config"
  cp -R "$BACKUP_DIR/.config/nvim" "$HOME/.config/"
  echo "✓ Restored .config/nvim"
fi

echo "Restore complete!"
EOF

chmod +x "$BACKUP_PATH/restore.sh"

log "${GREEN}Backup complete!${NC}"
log "${YELLOW}Backup location: $BACKUP_PATH${NC}"
log "${YELLOW}To restore: $BACKUP_PATH/restore.sh${NC}"

log "${YELLOW}Cleaning up old backups...${NC}"
if [[ -d "$BACKUP_DIR" ]]; then
  mapfile -t old_backups < <(find "$BACKUP_DIR" -maxdepth 1 -type d -name 'backup_*' | sort -r | tail -n +6)
  if [[ ${#old_backups[@]} -gt 0 ]]; then
    rm -rf "${old_backups[@]}"
  fi
fi

log "${GREEN}Done!${NC}"
