autoload -Uz compinit && compinit -u
autoload -Uz colors && colors

zstyle ':completion:*' menu select
zstyle ":completion:*:commands" rehash 1

setopt correct
setopt HIST_IGNORE_DUPS
