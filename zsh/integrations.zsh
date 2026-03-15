if command -v fzf >/dev/null 2>&1 && [[ -f "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v brew >/dev/null 2>&1; then
  typeset brew_prefix autosuggestions_script syntax_highlighting_script
  brew_prefix="$(brew --prefix 2>/dev/null)"

  autosuggestions_script="$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [[ -f "$autosuggestions_script" ]] && source "$autosuggestions_script"

  syntax_highlighting_script="$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -f "$syntax_highlighting_script" ]] && source "$syntax_highlighting_script"
fi

if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
  compdef __start_kubectl k
fi

if command -v docker >/dev/null 2>&1; then
  if docker completion zsh >/dev/null 2>&1; then
    source <(docker completion zsh)
    compdef _docker d
  fi
fi

if command -v docker-compose >/dev/null 2>&1; then
  if docker-compose completion zsh >/dev/null 2>&1; then
    source <(docker-compose completion zsh)
  fi
fi

if command -v pnpm >/dev/null 2>&1; then
  eval "$(pnpm completion zsh)"
fi
