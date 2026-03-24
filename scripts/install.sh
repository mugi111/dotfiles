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
  yq
  zoxide
  zsh-autosuggestions
  zsh-syntax-highlighting
)
cask_packages=(
  font-meslo-lg-nerd-font
)

should_install_kubernetes_cli() {
  if ! command -v kubectl >/dev/null 2>&1; then
    return 0
  fi

  local kubectl_path brew_prefix
  kubectl_path="$(command -v kubectl)"
  brew_prefix="$(brew --prefix)"

  [[ "$kubectl_path" == "$brew_prefix/bin/kubectl" ]]
}

should_install_cask() {
  local cask="$1"

  if brew list --cask "$cask" >/dev/null 2>&1; then
    return 1
  fi

  case "$cask" in
    font-meslo-lg-nerd-font)
      if compgen -G "$HOME/Library/Fonts/MesloLG*NerdFont*.ttf" >/dev/null; then
        echo "Skipping $cask because Meslo Nerd Font files already exist in $HOME/Library/Fonts"
        return 1
      fi
      ;;
  esac

  return 0
}

if [[ -f "$MODULES_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$MODULES_FILE"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Install Homebrew first."
  exit 1
fi

packages=("${base_packages[@]}")

if ! should_install_kubernetes_cli; then
  filtered_packages=()
  for package in "${packages[@]}"; do
    if [[ "$package" != "kubernetes-cli" ]]; then
      filtered_packages+=("$package")
    fi
  done
  packages=("${filtered_packages[@]}")
  echo "Skipping kubernetes-cli because kubectl is already provided by: $(command -v kubectl)"
fi

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
  should_install_cask "$cask" && brew install --cask "$cask"
done

echo "Installed packages: ${packages[*]}"
echo "Installed casks: ${cask_packages[*]}"
