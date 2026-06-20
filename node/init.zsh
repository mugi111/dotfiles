export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

if command -v brew >/dev/null 2>&1; then
  typeset nvm_script
  nvm_script="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
  [[ -s "$nvm_script" ]] && source "$nvm_script"
fi
