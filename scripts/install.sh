#!/usr/bin/env bash

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install Homebrew first."
  exit 1
fi

packages=(
  direnv
  fzf
  nodenv
  pyenv
  zoxide
)

for package in "${packages[@]}"; do
  brew list "$package" >/dev/null 2>&1 || brew install "$package"
done

echo "Installed packages: ${packages[*]}"
