#!/usr/bin/env bash
#
# Toggle bash options via fzf.

function __do
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

function __select {
    typeset \
        BOLD=$(tput bold || tput md) \
        RESET=$(tput sgr0 || tput me) \
        GREEN=$(tput setaf 2 || tput AF 2) \
        RED=$(tput setaf 1 || tput AF 1);

    sed "
        / -[so] / {
            s/$/ ${BOLD}${GREEN}enabled${RESET}/;
            b return;
        }; {
            s/$/ ${BOLD}${RED}disabled${RESET}/;
        };
        : return;" |
    sort -k 3 |
    column -t |
    fzf --ansi --multi --with-nth=3.. --tiebreak=begin;
};

function __input {
    shopt -p;
    shopt -op;
};

__do < <(__select < <(__input));

# vim: set ts=4 sw=4 tw=0 et :
