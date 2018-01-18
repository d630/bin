#!/usr/bin/env bash
#
# Toggle bash options via fzf.

function __set
while
    read -r b o n _;
do
    case $b$o in
        (set+o)
            set -o $n;;
        (set-o)
            set +o $n;;
        (shopt-s)
            shopt -u $n;;
        (shopt-u)
            shopt -s $n;;
    esac;
done;

function __these {
    BOLD=$(tput bold || tput md);
    RESET=$(tput sgr0 || tput me);
    GREEN=$(tput setaf 2 || tput AF 2);
    RED=$(tput setaf 1 || tput AF 1);

    sed "
        / -[so] / {
            s/$/ ${BOLD}${GREEN}enabled${RESET}/;
            b return;
        }; {
            s/$/ ${BOLD}${RED}disabled${RESET}/;
        };
        : return;
    " |
    sort -k 3 |
    column -t |
    fzf --ansi --multi --with-nth=3.. --tiebreak=begin;
};

function __options {
    shopt -p;
    shopt -op;
};

IFS=$' \t\n';

__set < <(__these < <(__options));

# vim: set ft=sh :
