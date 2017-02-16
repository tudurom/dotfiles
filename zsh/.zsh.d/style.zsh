setopt prompt_subst

# cd into dir if the command is the name of a dir
# and the command does not exist
setopt autocd
# print error if no match for filename
setopt nomatch
# notify about background jobs
setopt notify
# enable comments in interactive mode
setopt interactive_comments

autoload -U colors && colors
autoload -U zmv

PROMPT='%{$fg[red]%(? $fg[cyan] )%}> %f'

setopt extendedglob
setopt nocaseglob
setopt no_hup
