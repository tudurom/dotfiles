#!/bin/dash
#
# z3bra & tudurom - 2014 (c) wtfpl
# groaw - group, organize and arrange windows (or just a bear behind you)
# mod by tudurom - keeps track of currently mapped groups

GROOT=/tmp/groaw
GNUMBER=6

usage() {
        echo "$(basename $0) [-h] [-admtu <gid>]"
}

add_to_group() {
        :> $GROOT/$2/$1
        show_group $2
}

remove_from_group() {
    test "$2" = "all" \
        && rm -f $GROOT/*/$1 \
        || rm -f $GROOT/$2/$1
    hide_group $2
}

find_group() {
        file=$(find $GROOT -name "$1")
        test -n "$file" && basename $(dirname $file)
}

show_group() {
        for file in $GROOT/$1/*; do
                wid=$(basename $file)
                mapw -m $wid
        done
        test -f "$GROOT/mapped/$1" || touch "$GROOT/mapped/$1"
}

hide_group() {
        for file in $GROOT/$1/*; do
                wid=$(basename $file)
                mapw -u $wid
        done
        test -f "$GROOT/mapped/$1" && rm "$GROOT/mapped/$1"
}

togg_group() {
    wid=$(ls -1 $GROOT/$1 | sed 1q)

    test -z "$wid" && return
    wattr m $wid \
        && hide_group $1 \
        || show_group $1
}

is_mapped() {
    test -f "$GROOT/mapped/$1"
    exit $?
}

check_groups_sanity() {
        for gid in $(seq 1 $GNUMBER ); do
                test -d $GROOT/$gid || mkdir -p $GROOT/$gid
        done

        test -d $GROOT/mapped || mkdir -p $GROOT/mapped

        for file in $(find $GROOT -type f); do
                if ! (echo $file | grep mapped); then
                        wid=$(basename $file)
                        wattr $wid || rm -f $file
                fi
        done

        for group in $GROOT/*; do
          gid=$(basename $group)
          test -n "`ls -A $group`" || (test -f $GROOT/mapped/$gid && rm -f $GROOT/mapped/$gid)
        done
}

check_groups_sanity

while getopts ":a:wd:ghm:t:u:p:" opt; do
        case $opt in
                a) add_to_group `pfw` $OPTARG ;;
                d) remove_from_group `pfw` $OPTARG ;;
                g) find_group `pfw` ;;
                m) show_group $OPTARG ;;
                t) togg_group $OPTARG ;;
                u) hide_group $OPTARG ;;
                p) is_mapped $OPTARG ;;
                *) usage && exit 0;;
        esac
done

# in case no argument is given, display the whole tree
test $# -eq 0 && tree --noreport $GROOT
exit 0

# vim: set ft=sh :
