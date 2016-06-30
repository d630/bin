#!/usr/bin/env dash
#
# Create backup copy of a file.

for file
do
        if
                test -e "$1"
        then
                cp -v -- "$1" "${1}_$(date +%Y-%m-%d_%H-%M-%S)"
        else
                printf '%s not found\n' "$1" \
                1>&2;
        fi
done

# vim: set ts=8 sw=8 tw=0 et :
