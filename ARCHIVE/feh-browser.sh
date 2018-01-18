#!/usr/bin/env bash
#
# Open all files under the current directory with feh.
# Source: archlinux wiki

shopt -s nullglob

if
        [[ ! -f $1 ]]
then
        printf '%s: first argument is not a file\n' "$0" \
        1>&2;
        exit 1
fi

typeset \
        file=$(basename -- "$1") \
        dir=$(dirname -- "$1");
typeset -a arr=()

shift 1

if
        cd -- "$dir"
then
        for i in *
        do
                [[ -f $i ]] || continue;
                arr+=( "$i" )
                [[ $i == $file ]] && c=$(( ${#arr[@]} - 1 ));
        done
fi

setsid.sh feh "$@" -- "${arr[@]:c}" "${arr[@]:0:c}"

# vim: set ft=sh :
