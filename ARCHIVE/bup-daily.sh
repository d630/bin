#!/usr/bin/env bash
#
# Daily home backup with bup.

typeset -x BUP_DIR=/media/truecrypt1/linux/bup

while
        IFS= read -r -d ''
do
        BUP_DIR=/media/truecrypt1/linux/bup/${REPLY}
done < <(
        find "$BUP_DIR" -maxdepth 1 -type d -printf '%f\0' \
        | sort -zn \
        | sed -zn '$p';
)

bup index -ux /home
bup save -n home /home

# vim: set ts=8 sw=8 tw=0 et :
