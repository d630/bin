#!/usr/bin/env bash
#
# Weekly home backup with bup.

typeset -x \
           BUP_DIR=/media/truecrypt1/linux/bup \
           today;

printf -v today '%(%Y-%m-%d)T' -1

while
        IFS= read -r -d ''
do
        if
                (( ${today//-/} - ${REPLY//-/} > 14 ))
        then
                tmp_dir=$(mktemp -d --tmpdir) && {
                        rsync -var --delete "${tmp_dir}/" "${BUP_DIR}/${REPLY}/" && {
                                trap 'rm -Rf "$tmp_dir" "${BUP_DIR}/${REPLY}"' EXIT
                                printf '%s/%s has been deleted\n' "$BUP_DIR" "$REPLY" \
                                1>&2;
                        }
                }
        fi
done < <(
        find "$BUP_DIR" -maxdepth 1 -type d -printf '%f\0' \
        | sort -zn \
        | sed -zn '$!p';
)

BUP_DIR=/media/truecrypt1/linux/bup/${today}

bup init
bup index -ux /home
bup save -n home /home

# vim: set ft=sh :
