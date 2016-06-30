#!/usr/bin/env bash
#
# Grep and copy flash from firefox. Open selection in mpv.

browser=firefox
player=mpv
files=()

while
        IFS= read -r -d ''
do
        random=$(od -vAn -N 1 -tu < /dev/urandom)
        rsync -a -v --progress --no-l -L "$REPLY" "/tmp/${random// /}.flash"
done < <(
        find "/proc/$(pgrep ${browser})/fd" -type l -lname "/tmp/Flash*" -print0
)

mapfile -t files < <(
        find "/tmp/" -maxdepth 1 -type f -name "*.flash"
)

if
        (( ! ${#files[@]} ))
then
        printf '%s\n' "There is no flash file" \
        1>&2;
        exit 1
elif
        (( ${#files[@]} == 1 ))
then
        setsid.sh "$player" "/tmp/${random// /}.flash" \
        2>/dev/null;
else
        set -e
        ls -l "/tmp" \
        | grep -e ".*flash";
        read -re -p "File: " file
        setsid.sh "$player" "/tmp/${file}.flash" \
        2>/dev/null;
fi

# vim: set ts=8 sw=8 tw=0 et :
