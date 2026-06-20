if command -v pnpm >/dev/null 2>&1; then
  export PNPM_HOME="$HOME/Library/pnpm"
  path=("$PNPM_HOME" $path)
fi

export PATH
