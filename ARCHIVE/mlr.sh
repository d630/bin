#!/usr/bin/env dash
#
# Update personal non-public repos.

while
        read -r repo
do
        if
                cd -- "$repo"
        then
                if
                        test -e "./.git"
                then
                        git ls-files --deleted -z \
                        | xargs --null git rm \
                        1>/dev/null \
                        2>&1;
                        git add -A . \
                        1>/dev/null \
                        2>&1;
                        git commit -a -m "mlr $(date)"
                elif
                        test -e "./.hg"
                then
                        hg add \
                        1>/dev/null \
                        2>&1;
                        hg commit -m "mlr $(date)"
                fi
        fi
done < "${HOME}/local/var/lib/mlr/repos.txt"

# vim: set ft=sh :
