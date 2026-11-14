#!/bin/sh
# terminal-dotfiles bootstrap — macOS & Linux.
#
# Fresh machine:
#   sh -c "$(curl -fsLS https://raw.githubusercontent.com/habbababbai/terminal-dotfiles/main/install.sh)"
# From a local clone:
#   ./install.sh
#
# Installs chezmoi (to ~/.local/bin) if needed, then `chezmoi init --apply`,
# which prompts for git name/email, installs packages, clones oh-my-zsh +
# plugins, installs the font and writes every config file.
set -eu

REPO="habbababbai/terminal-dotfiles"
BIN_DIR="$HOME/.local/bin"

if command -v chezmoi >/dev/null 2>&1; then
  chezmoi=chezmoi
else
  echo "→ Installing chezmoi to $BIN_DIR"
  mkdir -p "$BIN_DIR"
  sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b "$BIN_DIR"
  chezmoi="$BIN_DIR/chezmoi"
fi

# Running from inside a clone? Use it as the source instead of re-cloning.
script_dir="$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)"
if [ -n "$script_dir" ] && [ -f "$script_dir/.chezmoiroot" ]; then
  echo "→ Applying from local clone: $script_dir"
  exec "$chezmoi" init --apply --source="$script_dir"
else
  echo "→ Applying from github.com/$REPO"
  exec "$chezmoi" init --apply "$REPO"
fi
