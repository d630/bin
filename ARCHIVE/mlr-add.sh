#!/usr/bin/env dash
#
# Record repo as personal non-public repo.

if
        [ -e "./.git" -o -e "./.hg" ]
then
        if
                printf '%s\n' "$PWD" \
                >> "${HOME}/local/var/lib/mlr/repos.txt";
        then
                tail -n2 "${HOME}/local/var/lib/mlr/repos.txt"
        fi
else
        printf '%s\n' "There is no repo in this dir." \
        1>&2;
fi

# vim: set ts=8 sw=8 tw=0 et :
