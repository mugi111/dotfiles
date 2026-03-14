mkcd() {
  mkdir -p "$1" && cd "$1"
}

extract() {
  if [[ ! -f "$1" ]]; then
    echo "extract: file not found: $1"
    return 1
  fi

  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.tar.xz) tar xJf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.gz) gunzip "$1" ;;
    *.rar) unrar x "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.7z) 7z x "$1" ;;
    *.xz) unxz "$1" ;;
    *)
      echo "extract: unsupported format: $1"
      return 1
      ;;
  esac
}

showpath() {
  printf '%s\n' "${path[@]}"
}
