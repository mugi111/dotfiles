autoload -Uz add-zsh-hook colors
colors
setopt PROMPT_SUBST

zmodload zsh/datetime 2>/dev/null || true

typeset -g POWERLINE_PROMPT=""
typeset -g POWERLINE_RPROMPT=""
typeset -g POWERLINE_LAST_DURATION_MS=0
typeset -g POWERLINE_CMD_START=""

typeset -gA POWERLINE_PALETTE=(
  bg "#1a1b26"
  surface "#24283b"
  fg "#c0caf5"
  muted "#565f89"
  blue "#7aa2f7"
  cyan "#7dcfff"
  teal "#73daca"
  green "#9ece6a"
  orange "#ff9e64"
  purple "#bb9af7"
  yellow "#e0af68"
  red "#f7768e"
)

_powerline_color() {
  local color_name="$1"
  print -r -- "${POWERLINE_PALETTE[$color_name]:-$color_name}"
}

_powerline_join() {
  local from_color="$1"
  local to_color="$2"
  print -rn -- "%K{$(_powerline_color "$to_color")}%F{$(_powerline_color "$from_color")}%f"
}

_powerline_segment() {
  local bg_color="$1"
  local content="$2"
  local fg_color="${3:-bg}"

  [[ -z "$content" ]] && return

  if [[ -n "$POWERLINE_PROMPT" && -n "${POWERLINE_LAST_BG:-}" ]]; then
    POWERLINE_PROMPT+="$(_powerline_join "$POWERLINE_LAST_BG" "$bg_color")"
  else
    POWERLINE_PROMPT+="%F{$(_powerline_color "$bg_color")}%f"
  fi

  POWERLINE_PROMPT+="%K{$(_powerline_color "$bg_color")}%F{$(_powerline_color "$fg_color")} ${content} %f"
  POWERLINE_LAST_BG="$bg_color"
}

_powerline_end_left() {
  if [[ -n "${POWERLINE_LAST_BG:-}" ]]; then
    POWERLINE_PROMPT+="%k%F{$(_powerline_color "$POWERLINE_LAST_BG")}%f"
  fi
}

_powerline_capsule() {
  local bg_color="$1"
  local content="$2"
  local fg_color="${3:-bg}"

  [[ -z "$content" ]] && return

  print -rn -- "%F{$(_powerline_color "$bg_color")}%f%K{$(_powerline_color "$bg_color")}%F{$(_powerline_color "$fg_color")} ${content} %f%k%F{$(_powerline_color "$bg_color")}%f"
}

_powerline_truncate_path() {
  local path="${PWD/#$HOME/~}"
  local -a parts

  if [[ "$path" == "/" ]]; then
    print -r -- "/"
    return
  fi

  parts=("${(@s:/:)path}")
  if (( ${#parts[@]} <= 3 )); then
    print -r -- "$path"
    return
  fi

  if [[ "$path" == "~"* ]]; then
    print -r -- "~/${(j:/:)parts[-2,-1]}"
    return
  fi

  print -r -- ".../${(j:/:)parts[-3,-1]}"
}

_powerline_git_state() {
  local git_dir
  git_dir="$(git rev-parse --git-dir 2>/dev/null)" || return

  if [[ -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]]; then
    print -r -- "REBASING"
  elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
    print -r -- "MERGING"
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    print -r -- "CHERRY-PICKING"
  elif [[ -f "$git_dir/REVERT_HEAD" ]]; then
    print -r -- "REVERTING"
  elif [[ -f "$git_dir/BISECT_LOG" ]]; then
    print -r -- "BISECTING"
  fi
}

_powerline_git_metrics() {
  local metrics

  metrics="$(
    {
      git diff --numstat --ignore-submodules -- 2>/dev/null
      git diff --cached --numstat --ignore-submodules -- 2>/dev/null
    } | awk '
      $1 != "-" { added += $1 }
      $2 != "-" { deleted += $2 }
      END {
        if (added > 0 || deleted > 0) {
          printf "+%d -%d", added, deleted
        }
      }
    '
  )"

  print -r -- "$metrics"
}

_powerline_git_info() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local branch git_status_line ahead_behind status_line git_state git_metrics
  local -a status_lines status_parts
  local staged=0 modified=0 untracked=0 conflicted=0 renamed=0 deleted=0 stashed=0
  local branch_segment status_segment

  branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)" || return
  status_lines=("${(@f)$(git status --porcelain --branch 2>/dev/null)}")
  git_status_line="${status_lines[1]}"

  if [[ "$git_status_line" == *ahead* ]]; then
    ahead_behind+=" >"
  fi
  if [[ "$git_status_line" == *behind* ]]; then
    ahead_behind+=" <"
  fi

  for status_line in "${status_lines[@]:1}"; do
    [[ -z "$status_line" ]] && continue
    if [[ "$status_line" == "??"* ]]; then
      ((untracked++))
      continue
    fi

    [[ "$status_line" == *"U"* ]] && ((conflicted++))
    [[ "$status_line[1]" == "R" || "$status_line[2]" == "R" ]] && ((renamed++))
    [[ "$status_line[1]" == "D" || "$status_line[2]" == "D" ]] && ((deleted++))

    if [[ "$status_line[1]" != " " && "$status_line[1]" != "?" && "$status_line[1]" != "U" ]]; then
      ((staged++))
    fi
    if [[ "$status_line[2]" != " " && "$status_line[2]" != "?" && "$status_line[2]" != "U" ]]; then
      ((modified++))
    fi
  done

  stashed="$(git stash list 2>/dev/null | wc -l | tr -d ' ')"

  branch_segment=" ${branch}"
  _powerline_segment purple "$branch_segment"

  (( staged > 0 )) && status_parts+="+${staged}"
  (( modified > 0 )) && status_parts+="!${modified}"
  (( untracked > 0 )) && status_parts+="?${untracked}"
  (( conflicted > 0 )) && status_parts+="=${conflicted}"
  (( renamed > 0 )) && status_parts+="r${renamed}"
  (( deleted > 0 )) && status_parts+="x${deleted}"
  (( stashed > 0 )) && status_parts+="\$${stashed}"
  [[ -n "$ahead_behind" ]] && status_parts+="${ahead_behind# }"

  if (( ${#status_parts[@]} > 0 )); then
    status_segment="${(j: :)status_parts}"
    _powerline_segment surface "$status_segment" yellow
  fi

  git_state="$(_powerline_git_state)"
  [[ -n "$git_state" ]] && _powerline_segment surface "$git_state" red

  git_metrics="$(_powerline_git_metrics)"
  [[ -n "$git_metrics" ]] && _powerline_segment surface "$git_metrics" green
}

_powerline_detect_file() {
  local candidate
  for candidate in "$@"; do
    [[ -e "$candidate" ]] && return 0
  done
  return 1
}

_powerline_language_segments() {
  local version

  if command -v docker >/dev/null 2>&1; then
    local docker_context
    docker_context="$(docker context show 2>/dev/null)"
    [[ -n "$docker_context" && "$docker_context" != "default" ]] && _powerline_segment teal " ${docker_context}"
  fi

  if command -v kubectl >/dev/null 2>&1; then
    local kube_context kube_namespace kube_label kube_color
    kube_context="$(kubectl config current-context 2>/dev/null)"
    if [[ -n "$kube_context" ]]; then
      kube_namespace="$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
      kube_color="orange"
      if [[ "$kube_context" == *prod* ]]; then
        kube_color="red"
      elif [[ "$kube_context" == *stg* || "$kube_context" == *stage* ]]; then
        kube_color="yellow"
      fi

      kube_label="󱃾 ${kube_context}"
      [[ -n "$kube_namespace" ]] && kube_label+=" (${kube_namespace})"
      _powerline_segment "$kube_color" "$kube_label"
    fi
  fi

  if command -v python3 >/dev/null 2>&1 && _powerline_detect_file pyproject.toml requirements.txt .python-version Pipfile tox.ini .venv venv *.py(N); then
    version="$(python3 --version 2>/dev/null | awk '{print $2}')"
    [[ -n "$version" ]] && _powerline_segment green " ${version}"
  fi

  if command -v node >/dev/null 2>&1 && _powerline_detect_file package.json .node-version .nvmrc; then
    version="$(node --version 2>/dev/null)"
    [[ -n "$version" ]] && _powerline_segment cyan " ${version#v}"
  fi

  if command -v go >/dev/null 2>&1 && _powerline_detect_file go.mod go.sum .go-version; then
    version="$(go version 2>/dev/null | awk '{print $3}')"
    [[ -n "$version" ]] && _powerline_segment blue " ${version#go}"
  fi

  if command -v rustc >/dev/null 2>&1 && _powerline_detect_file Cargo.toml Cargo.lock rust-toolchain rust-toolchain.toml; then
    version="$(rustc --version 2>/dev/null | awk '{print $2}')"
    [[ -n "$version" ]] && _powerline_segment orange " ${version}"
  fi

  if [[ -f package.json ]]; then
    local package_version
    if command -v jq >/dev/null 2>&1; then
      package_version="$(jq -r '.version // empty' package.json 2>/dev/null)"
    else
      package_version="$(sed -n 's/.*\"version\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p' package.json | head -n 1)"
    fi
    [[ -n "$package_version" ]] && _powerline_segment yellow "󰏗 ${package_version}"
  fi
}

_powerline_format_duration() {
  local duration_ms="$1"
  local minutes seconds

  if (( duration_ms < 2000 )); then
    return
  fi

  if (( duration_ms >= 60000 )); then
    minutes=$(( duration_ms / 60000 ))
    seconds=$(( (duration_ms % 60000) / 1000 ))
    print -r -- "${minutes}m${seconds}s"
    return
  fi

  print -r -- "$(( duration_ms / 1000 ))s"
}

_powerline_preexec() {
  POWERLINE_CMD_START="${EPOCHREALTIME:-$EPOCHSECONDS}"
}

_powerline_precmd() {
  local last_status=$?
  local prompt_char="❯"
  local prompt_color="blue"
  local duration_label right_segments=""
  local directory_label

  POWERLINE_PROMPT=""
  POWERLINE_RPROMPT=""
  POWERLINE_LAST_BG=""

  directory_label="$(_powerline_truncate_path)"
  [[ ! -w "$PWD" ]] && directory_label+=" 󰌾"
  _powerline_segment blue "$directory_label"
  _powerline_git_info
  _powerline_language_segments
  _powerline_end_left

  if [[ -n "$POWERLINE_CMD_START" ]]; then
    POWERLINE_LAST_DURATION_MS="$(printf '%.0f' "$(( (${EPOCHREALTIME:-$EPOCHSECONDS} - POWERLINE_CMD_START) * 1000 ))" 2>/dev/null)"
  else
    POWERLINE_LAST_DURATION_MS=0
  fi
  POWERLINE_CMD_START=""

  if (( last_status != 0 )); then
    right_segments+="$(_powerline_capsule red "✘${last_status}")"
    prompt_color="red"
  fi

  duration_label="$(_powerline_format_duration ${POWERLINE_LAST_DURATION_MS:-0})"
  if [[ -n "$duration_label" ]]; then
    [[ -n "$right_segments" ]] && right_segments+=" "
    right_segments+="$(_powerline_capsule yellow "󰔛 ${duration_label}")"
  fi

  POWERLINE_RPROMPT="$right_segments"
  POWERLINE_PROMPT="${POWERLINE_PROMPT}
%F{$(_powerline_color "$prompt_color")}${prompt_char}%f "
}

add-zsh-hook preexec _powerline_preexec
add-zsh-hook precmd _powerline_precmd

PROMPT='${POWERLINE_PROMPT}'
RPROMPT='${POWERLINE_RPROMPT}'
