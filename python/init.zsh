if command -v pyenv >/dev/null 2>&1; then
  _dotfiles_init_pyenv() {
    unset -f _dotfiles_init_pyenv pyenv
    eval "$(command pyenv init - zsh)"
  }

  pyenv() {
    _dotfiles_init_pyenv
    pyenv "$@"
  }
fi
