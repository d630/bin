#!/usr/bin/env bash
#
# Simple clipboard manager for clipbored using dmenu or fzf.

xsels=${HOME}/local/var/lib/clipbored/clips

if
        test-tty.sh \
        2>/dev/null;
then
        menu=fzf
else
        menu=dmenu2
fi

printf -v xsels '%s' "$(
        tac "$xsels" \
        | sed '/^$/d' \
        | menu.sh "$menu" ">";
)"

printf "$xsels" \
| xclip -i -l 1 -selection clipboard;

# vim: set ft=sh :
