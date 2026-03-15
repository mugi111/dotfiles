#!/usr/bin/env bash

set -euo pipefail

MODULES_FILE="$HOME/.dotfiles.modules.sh"
base_packages=(
  bat
  direnv
  eza
  fd
  fzf
  jq
  kubectx
  kubernetes-cli
  lazydocker
  k9s
  ripgrep
  starship
  yq
  zoxide
  zsh-autosuggestions
  zsh-syntax-highlighting
)
cask_packages=(
  font-meslo-lg-nerd-font
)

if [[ -f "$MODULES_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$MODULES_FILE"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install Homebrew first."
  exit 1
fi

packages=("${base_packages[@]}")

if [[ "${DOTFILES_ENABLE_NODE:-1}" == "1" ]]; then
  packages+=(nodenv pnpm)
fi

if [[ "${DOTFILES_ENABLE_PYTHON:-1}" == "1" ]]; then
  packages+=(pyenv uv)
fi

for package in "${packages[@]}"; do
  brew list "$package" >/dev/null 2>&1 || brew install "$package"
done

for cask in "${cask_packages[@]}"; do
  brew list --cask "$cask" >/dev/null 2>&1 || brew install --cask "$cask"
done

echo "Installed packages: ${packages[*]}"
echo "Installed casks: ${cask_packages[*]}"
