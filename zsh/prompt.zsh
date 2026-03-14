autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=(precmd_vcs_info)

zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b)%f'
zstyle ':vcs_info:*' enable git

autoload -Uz colors && colors
setopt PROMPT_SUBST

PROMPT='%F{green}%n@%m%f:%F{blue}%~%f${vcs_info_msg_0_} %# '
RPROMPT='%(?..%F{red}[exit:%?]%f)'
