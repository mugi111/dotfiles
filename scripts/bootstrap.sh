#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_ZSHRC="$HOME/.zshrc"
SOURCE_ZSHRC="$ROOT_DIR/.zshrc"

backup_existing_zshrc() {
  if [[ ! -e "$TARGET_ZSHRC" && ! -L "$TARGET_ZSHRC" ]]; then
    return
  fi

  if [[ -L "$TARGET_ZSHRC" ]] && [[ "$(readlink "$TARGET_ZSHRC")" == "$SOURCE_ZSHRC" ]]; then
    return
  fi

  local backup_path="$HOME/.zshrc.bak"
  if [[ -e "$backup_path" || -L "$backup_path" ]]; then
    backup_path="$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"
  fi

  mv "$TARGET_ZSHRC" "$backup_path"
  echo "Backed up existing .zshrc: $TARGET_ZSHRC -> $backup_path"

  if command -v diff >/dev/null 2>&1; then
    echo "Diff: $backup_path vs $SOURCE_ZSHRC"
    diff -u "$backup_path" "$SOURCE_ZSHRC" || true
  fi
}

mkdir -p "$HOME/.zsh/cache"
mkdir -p "$HOME/.config"

backup_existing_zshrc

ln -snf "$SOURCE_ZSHRC" "$TARGET_ZSHRC"
ln -snf "$ROOT_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

echo "Bootstrapped dotfiles from: $ROOT_DIR"
echo "Linked: $TARGET_ZSHRC -> $SOURCE_ZSHRC"
echo "Linked: $HOME/.config/starship.toml -> $ROOT_DIR/starship/starship.toml"
