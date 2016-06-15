prompt () {
    exit_color=6
    b="$(tput bold)"
    l="$(echo -n $b; tput setaf 0)"
    z="$(tput sgr0)"
    e="$(tput setaf $exit_color)"
    _ERR=$?
    if [ $_ERR -ne 0 ]; then
        exit_color=1
    fi
    dir="${l}$(pwd | sed -e "s/\/usr\/home\/$USER/~/" | sed -e "s/\/home\/$USER/~/")"
    arrow="${e}───"
    echo "${dir}"
    echo "${arrow}${z} "
}

PS1='$(prompt)'
PS2='> '
export PS1 PS2
