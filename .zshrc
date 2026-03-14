#!/usr/bin/env zsh

setopt EXTENDED_GLOB

DOTFILES_DIR="${${(%):-%N}:A:h}"

for file in \
  "$DOTFILES_DIR/zsh/homebrew.zsh" \
  "$DOTFILES_DIR/zsh/exports.zsh" \
  "$DOTFILES_DIR/zsh/path.zsh" \
  "$DOTFILES_DIR/zsh/history.zsh" \
  "$DOTFILES_DIR/zsh/completion.zsh" \
  "$DOTFILES_DIR/zsh/options.zsh" \
  "$DOTFILES_DIR/zsh/keybindings.zsh" \
  "$DOTFILES_DIR/zsh/aliases.zsh" \
  "$DOTFILES_DIR/git/aliases.zsh" \
  "$DOTFILES_DIR/go/path.zsh" \
  "$DOTFILES_DIR/python/aliases.zsh" \
  "$DOTFILES_DIR/python/path.zsh" \
  "$DOTFILES_DIR/python/init.zsh" \
  "$DOTFILES_DIR/node/aliases.zsh" \
  "$DOTFILES_DIR/node/path.zsh" \
  "$DOTFILES_DIR/node/init.zsh" \
  "$DOTFILES_DIR/rust/path.zsh" \
  "$DOTFILES_DIR/rust/init.zsh" \
  "$DOTFILES_DIR/macos/aliases.zsh" \
  "$DOTFILES_DIR/macos/functions.zsh" \
  "$DOTFILES_DIR/zsh/functions.zsh" \
  "$DOTFILES_DIR/zsh/prompt.zsh" \
  "$DOTFILES_DIR/zsh/integrations.zsh" \
  "$DOTFILES_DIR/zsh/local.zsh"
do
  [[ -f "$file" ]] && source "$file"
done
