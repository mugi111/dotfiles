typeset -U path PATH

path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  $path
)

if command -v brew >/dev/null 2>&1; then
  typeset brew_prefix
  brew_prefix="$(brew --prefix 2>/dev/null)"
  if [[ -d "$brew_prefix/share/zsh/site-functions" ]]; then
    fpath=("$brew_prefix/share/zsh/site-functions" $fpath)
  fi
fi

export PATH
