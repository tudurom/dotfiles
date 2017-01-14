autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt COMPLETE_ALIASES
