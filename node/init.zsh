if command -v nodenv >/dev/null 2>&1; then
  _dotfiles_init_nodenv() {
    unset -f _dotfiles_init_nodenv nodenv
    eval "$(command nodenv init - zsh)"
  }

  nodenv() {
    _dotfiles_init_nodenv
    nodenv "$@"
  }
fi

export NVM_DIR="$HOME/.nvm"

if command -v brew >/dev/null 2>&1; then
  typeset nvm_script
  nvm_script="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
  [[ -s "$nvm_script" ]] && source "$nvm_script"
fi
