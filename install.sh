#!/bin/bash
# Install script for git-worktree-helpers

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine config directory
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/gwt"
SCRIPT_NAME="git-worktree-helpers.sh"
INSTALL_PATH="$CONFIG_DIR/$SCRIPT_NAME"
GITHUB_RAW_URL="https://raw.githubusercontent.com/magidandrew/gwt/main/git-worktree-helpers.sh"

echo -e "${BLUE}Installing git-worktree-helpers...${NC}"
echo ""

# Create config directory if it doesn't exist
if [[ ! -d "$CONFIG_DIR" ]]; then
  echo "Creating directory: $CONFIG_DIR"
  mkdir -p "$CONFIG_DIR"
fi

# Check if we're in the repo directory (local install) or need to download (remote install)
if [[ -f "$SCRIPT_NAME" ]]; then
  # Local install - copy from current directory
  echo "Copying $SCRIPT_NAME to $INSTALL_PATH"
  cp "$SCRIPT_NAME" "$INSTALL_PATH"
else
  # Remote install - download from GitHub
  echo "Downloading $SCRIPT_NAME to $INSTALL_PATH"
  if command -v curl &> /dev/null; then
    curl -fsSL "$GITHUB_RAW_URL" -o "$INSTALL_PATH"
  elif command -v wget &> /dev/null; then
    wget -qO "$INSTALL_PATH" "$GITHUB_RAW_URL"
  else
    echo "Error: Neither curl nor wget found. Please install one of them."
    exit 1
  fi
fi

chmod +x "$INSTALL_PATH"

echo ""
echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo -e "${YELLOW}Next step:${NC} Add this line to your ~/.zshrc (or ~/.bashrc):"
echo ""
echo -e "${BLUE}source \"$INSTALL_PATH\"${NC}"
echo ""
echo "Quick command to add it:"
echo ""
echo -e "${BLUE}echo 'source \"$INSTALL_PATH\"' >> ~/.zshrc && source ~/.zshrc${NC}"
echo ""
echo "Or manually add it to your shell config and run: source ~/.zshrc"
echo ""
echo -e "${YELLOW}Usage:${NC}"
echo "  gwt <base> <name>            Create new worktree"
echo "  gwt checkout <branch> <name>  Checkout existing branch"
echo "  gwt rm <name>                 Remove worktree"
echo "  gwt ls                        List worktrees"
echo "  gwt help                      Show help"
echo ""
echo -e "${YELLOW}To update in the future:${NC} Just run this install script again!"
