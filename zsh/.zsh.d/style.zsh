setopt prompt_subst

# print error if no match for filename
setopt nomatch
# notify about background jobs
setopt notify
# enable comments in interactive mode
setopt interactive_comments

autoload -U colors && colors
autoload -U zmv

# A simple arrow
# Cyan on exit success, red otherwise
PROMPT='%{$fg[red]%(? $fg[cyan] )%}> %f'

setopt extendedglob
setopt nocaseglob
setopt no_hup
