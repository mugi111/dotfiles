#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$HOME/.zsh/cache"
mkdir -p "$HOME/.config"

ln -snf "$ROOT_DIR/.zshrc" "$HOME/.zshrc"
ln -snf "$ROOT_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

echo "Bootstrapped dotfiles from: $ROOT_DIR"
echo "Linked: $HOME/.zshrc -> $ROOT_DIR/.zshrc"
echo "Linked: $HOME/.config/starship.toml -> $ROOT_DIR/starship/starship.toml"
