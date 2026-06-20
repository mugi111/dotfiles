autoload -Uz add-zsh-hook

_dotfiles_find_up() {
  local target="$1"
  local dir="$PWD"

  while [[ "$dir" != "/" ]]; do
    if [[ -e "$dir/$target" ]]; then
      printf '%s\n' "$dir/$target"
      return 0
    fi
    dir="${dir:h}"
  done

  [[ -e "/$target" ]] && printf '%s\n' "/$target"
}

_dotfiles_deactivate_auto_venv() {
  if [[ -n "${DOTFILES_AUTO_VENV_ACTIVE:-}" ]] && typeset -f deactivate >/dev/null 2>&1; then
    deactivate >/dev/null 2>&1 || true
  fi

  unset DOTFILES_AUTO_VENV_ACTIVE
}

_dotfiles_auto_venv() {
  [[ -o interactive ]] || return 0

  local envrc_path activate_path target_venv
  envrc_path="$(_dotfiles_find_up .envrc)"

  if [[ -n "$envrc_path" ]]; then
    _dotfiles_deactivate_auto_venv
    return 0
  fi

  activate_path="$(_dotfiles_find_up .venv/bin/activate)"
  target_venv="${activate_path:h:h}"

  if [[ -z "$activate_path" || ! -f "$activate_path" ]]; then
    _dotfiles_deactivate_auto_venv
    return 0
  fi

  if [[ "${VIRTUAL_ENV:-}" == "$target_venv" ]]; then
    DOTFILES_AUTO_VENV_ACTIVE="$target_venv"
    return 0
  fi

  if [[ -n "${VIRTUAL_ENV:-}" && -z "${DOTFILES_AUTO_VENV_ACTIVE:-}" ]]; then
    return 0
  fi

  _dotfiles_deactivate_auto_venv
  source "$activate_path"
  export DOTFILES_AUTO_VENV_ACTIVE="$target_venv"
}

add-zsh-hook chpwd _dotfiles_auto_venv
_dotfiles_auto_venv
