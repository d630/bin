#!/usr/bin/env bash
#
# Outline topological sort.

# Input like:
# 35
# 38
# 75
# 40 35
# 81 38
# 39 40,75,81
# 50 40
# 55 50

(( $# == 0 )) && { echo "Argument needed." >&2 ; exit 1 ; }
(( $# > 1 )) && { echo "More than one argument is not allowed." >&2 ; exit 1 ; }
[[ ! -f $1 ]] && { echo "Argument is not a file." >&2 ; exit 1 ; }

declare -A deps children
declare -a \
           ch=() \
           new_children=() \
           tsorted=()
declare \
        c= \
        chars= \
        child= \
        greatest= \
        i= \
        ind= \
        j= \
        k= \
        l= \
        m= \
        n= \
        parent= \
        skip=

while read -r parent child
do
    [[ $child ]] &&
    {
        ch=()
        for c in ${child//,/ }
        do
            if [[ ${deps[${c} ${parent}]} ]]
            then
                continue
            else
                deps[${parent} ${c}]=${c}
                ch+=( $c )
            fi
        done
        children[$parent]=${ch[@]}
        parent=
        child=
    }
done < "$1"

mapfile -t tsorted < <(printf '%s\n' "${!deps[@]}" | tsort 2>/dev/null)

for (( i=${#tsorted[@]}-1 ; i >= 0 ; --i ))
do
    [[ ${children[${tsorted[$i]}]} ]] &&
    {
        new_children=()
        for j in ${children[${tsorted[$i]}]}
        do
            if [[ ${children[$j]} ]]
            then
                new_children+=( ${j}_${children[$j]// /_} )
            else
                new_children+=( ${j} )
            fi
        done
        children[${tsorted[$i]}]=${new_children[@]}
    }
    (( ${tsorted[$i]} > greatest )) && greatest=${tsorted[$i]}
done

chars=${#greatest}

for k in "${tsorted[@]}"
do
    skip=
    for l in ${children[@]//_/ }
    do
        (( $k == $l )) && skip=skip && break
    done
    [[ ! $skip ]] &&
    {
        printf '%d\n' "$k"
        for m in ${children[$k]}
        do
            ind=$chars
            if [[ $m =~ _ ]]
            then
                for n in ${m//_/ }
                do
                    printf '%*d\n' "$((ind+=4))" "$n"
                done
            else
                printf '%*d\n' "$((ind+4))" "$m"
            fi
        done
    }
done

# vim: set ft=sh :
