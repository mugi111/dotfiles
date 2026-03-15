export PYENV_ROOT="$HOME/.pyenv"

if [[ -d "$PYENV_ROOT" ]]; then
  path=("$PYENV_ROOT/shims" $path)
  path=("$PYENV_ROOT/bin" $path)
fi

export PATH
