export NODENV_ROOT="$HOME/.nodenv"

if [[ -d "$NODENV_ROOT" ]]; then
  path=("$NODENV_ROOT/shims" $path)
  path=("$NODENV_ROOT/bin" $path)
fi

if command -v pnpm >/dev/null 2>&1; then
  export PNPM_HOME="$HOME/Library/pnpm"
  path=("$PNPM_HOME" $path)
fi

export PATH
