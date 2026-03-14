autoload -Uz compinit
compinit -d "$HOME/.zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}no matches found%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' squeeze-slashes true

autoload -U select-word-style
select-word-style bash
