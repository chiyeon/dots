#!/usr/bin/env bash

# Dotfiles Save Script
# This script copies dotfiles from your home directory back to this repo
# so you can commit your changes

set -e

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${SCRIPT_DIR}/home"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Dotfiles Save Script                              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "This script will copy dotfiles from your home directory"
echo "back to this repository so you can commit changes."
echo ""
echo -e "Source: ${GREEN}${HOME}${NC}"
echo -e "Target: ${GREEN}${DOTFILES_DIR}${NC}"
echo ""

# Check what files exist in the repo to know what to save
if [[ ! -d "${DOTFILES_DIR}" ]]; then
    echo -e "${YELLOW}Warning: ${DOTFILES_DIR} does not exist!${NC}"
    exit 1
fi

echo "Copying files from home directory to repository..."
echo ""

# Counter for tracking
copied=0
skipped=0

# Walk through the repo structure and copy matching files from home
cd "${DOTFILES_DIR}"
for file in $(find . -type f); do
    file="${file#./}"  # Remove leading ./
    src="${HOME}/${file}"
    dst="${DOTFILES_DIR}/${file}"

    if [[ -f "${src}" ]]; then
        # Create directory if needed
        mkdir -p "$(dirname "${dst}")"

        # Copy the file
        cp -a "${src}" "${dst}"
        echo -e "${GREEN}✓${NC} ${file}"
        copied=$((copied + 1))
    else
        echo -e "${YELLOW}⊘${NC} ${file} (not found in home directory)"
        skipped=$((skipped + 1))
    fi
done

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ Save complete!                                         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Summary:"
echo -e "  Copied: ${GREEN}${copied}${NC} files"
echo -e "  Skipped: ${YELLOW}${skipped}${NC} files (not found in home)"
echo ""
echo "Next steps:"
echo "  1. Review changes: git status"
echo "  2. See differences: git diff"
echo "  3. Commit changes: git add -A && git commit -m 'Update dotfiles'"
echo "  4. Push to remote: git push"
