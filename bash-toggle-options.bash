#!/usr/bin/env bash
#
# Toggle bash options via fzf.

function __do
while
    builtin read -r b o n _;
do
    case ${b}${o} in
        (set+o)
            builtin set -o "$n";;
        (set-o)
            builtin set +o "$n";;
        (shopt-s)
            builtin shopt -u "$n";;
        (shopt-u)
            builtin shopt -s "$n";
    esac;
done;

function __select {
    builtin typeset \
        BOLD=$(command \tput bold || command \tput md;) \
        RESET=$(command \tput sgr0 || command \tput me;) \
        GREEN=$(command \tput setaf 2 || command \tput AF 2;) \
        RED=$(command \tput setaf 1 || command \tput AF 1;);

    command sed "
        / -[so] / {
            s/$/ ${BOLD}${GREEN}enabled${RESET}/;
            b return;
        }; {
            s/$/ ${BOLD}${RED}disabled${RESET}/;
        };
        : return;" |
    command \sort -k 3 |
    command \column -t |
    command \fzf --ansi --multi --with-nth=3.. --tiebreak=begin;
};

function __input {
    builtin shopt -p;
    builtin shopt -op;
};

'__do' < <('__select' < <('__input'));

# vim: set ts=4 sw=4 tw=0 et :
