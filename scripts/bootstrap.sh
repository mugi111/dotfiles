#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$HOME/.zsh/cache"

ln -snf "$ROOT_DIR/.zshrc" "$HOME/.zshrc"

echo "Bootstrapped dotfiles from: $ROOT_DIR"
echo "Linked: $HOME/.zshrc -> $ROOT_DIR/.zshrc"
