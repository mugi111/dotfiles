if command -v nodenv >/dev/null 2>&1; then
  eval "$(nodenv init - zsh)"
fi

export NVM_DIR="$HOME/.nvm"

if command -v brew >/dev/null 2>&1; then
  typeset nvm_script
  nvm_script="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
  [[ -s "$nvm_script" ]] && source "$nvm_script"
fi
