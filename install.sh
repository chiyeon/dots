#!/usr/bin/env bash

# Dotfiles Installation Script
# This script will DESTRUCTIVELY copy dotfiles from this repo to your home directory
# Files in your home directory will be overwritten!

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${SCRIPT_DIR}/home"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║         Dotfiles Installation Script                      ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${RED}⚠️  WARNING: This will OVERWRITE existing dotfiles in your home directory!${NC}"
echo ""
echo -e "Source: ${GREEN}${DOTFILES_DIR}${NC}"
echo -e "Target: ${GREEN}${HOME}${NC}"
echo ""

# Show what will be copied
echo "The following files and directories will be installed:"
echo ""
(cd "${DOTFILES_DIR}" && find . -maxdepth 2 -type f -o -type d | grep -v "^\.$" | head -20)
echo "... (and more)"
echo ""

# Ask for confirmation
read -p "Do you want to create backups of existing files? (y/n): " -n 1 -r BACKUP
echo ""

read -p "Are you sure you want to proceed? (yes/no): " -r CONFIRM
echo ""

if [[ ! $CONFIRM =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${YELLOW}Installation cancelled.${NC}"
    exit 0
fi

# Create backup if requested
if [[ $BACKUP =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Creating backup at: ${BACKUP_DIR}${NC}"
    mkdir -p "${BACKUP_DIR}"

    # Backup files that will be overwritten
    cd "${DOTFILES_DIR}"
    for file in $(find . -type f); do
        file="${file#./}"  # Remove leading ./
        if [[ -f "${HOME}/${file}" ]]; then
            mkdir -p "${BACKUP_DIR}/$(dirname "${file}")"
            cp -a "${HOME}/${file}" "${BACKUP_DIR}/${file}"
        fi
    done
    echo -e "${GREEN}✓ Backup created${NC}"
fi

# Install dotfiles
echo -e "${GREEN}Installing dotfiles...${NC}"

# Use rsync if available, otherwise use cp
if command -v rsync &> /dev/null; then
    rsync -av --no-perms "${DOTFILES_DIR}/" "${HOME}/"
else
    cp -r "${DOTFILES_DIR}/"* "${HOME}/"
    cp -r "${DOTFILES_DIR}/".* "${HOME}/" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ Installation complete!                                 ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"

if [[ $BACKUP =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "Backup location: ${YELLOW}${BACKUP_DIR}${NC}"
fi

echo ""
echo "You may need to:"
echo "  - Restart your shell or run: source ~/.bashrc (or ~/.config/fish/config.fish)"
echo "  - Restart your window manager/compositor"
echo "  - Log out and log back in"
