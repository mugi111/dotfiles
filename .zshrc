#!/usr/bin/env zsh

setopt EXTENDED_GLOB

DOTFILES_DIR="${${(%):-%N}:A:h}"
DOTFILES_MODULES_FILE="${HOME}/.dotfiles.modules.sh"

[[ -f "$DOTFILES_MODULES_FILE" ]] && source "$DOTFILES_MODULES_FILE"

module_enabled() {
  local module_name="$1"
  local var_name="DOTFILES_ENABLE_${(U)module_name}"
  local value="${(P)var_name:-1}"
  [[ "$value" == "1" ]]
}

for file in \
  "$DOTFILES_DIR/zsh/homebrew.zsh" \
  "$DOTFILES_DIR/zsh/exports.zsh" \
  "$DOTFILES_DIR/zsh/path.zsh" \
  "$DOTFILES_DIR/zsh/history.zsh" \
  "$DOTFILES_DIR/zsh/completion.zsh" \
  "$DOTFILES_DIR/zsh/options.zsh" \
  "$DOTFILES_DIR/zsh/keybindings.zsh" \
  "$DOTFILES_DIR/zsh/aliases.zsh" \
  "$DOTFILES_DIR/zsh/functions.zsh" \
  "$DOTFILES_DIR/zsh/prompt.zsh" \
  "$DOTFILES_DIR/zsh/integrations.zsh" \
  "$DOTFILES_DIR/zsh/local.zsh"
do
  [[ -f "$file" ]] && source "$file"
done

if module_enabled git; then
  source "$DOTFILES_DIR/git/aliases.zsh"
fi

if module_enabled go; then
  source "$DOTFILES_DIR/go/path.zsh"
fi

if module_enabled python; then
  source "$DOTFILES_DIR/python/aliases.zsh"
  source "$DOTFILES_DIR/python/path.zsh"
  source "$DOTFILES_DIR/python/init.zsh"
fi

if module_enabled node; then
  source "$DOTFILES_DIR/node/aliases.zsh"
  source "$DOTFILES_DIR/node/path.zsh"
  source "$DOTFILES_DIR/node/init.zsh"
fi

if module_enabled rust; then
  source "$DOTFILES_DIR/rust/path.zsh"
  source "$DOTFILES_DIR/rust/init.zsh"
fi

if module_enabled macos; then
  source "$DOTFILES_DIR/macos/aliases.zsh"
  source "$DOTFILES_DIR/macos/functions.zsh"
fi
