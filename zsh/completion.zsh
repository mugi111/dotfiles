autoload -Uz compinit
compinit -C -d "$HOME/.zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' complete-options true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:warnings' format '%F{red}no matches found%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' rehash true
zstyle ':completion:*' squeeze-slashes true

autoload -U select-word-style
select-word-style bash
