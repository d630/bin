#!/usr/bin/env dash
#
# Use xterm like kuake and yeahconsole terminal.
# Source: https://wiki.archlinux.org/index.php/ \
#       Urxvt#Improved_Kuake-like_behavior_in_Openbox

id="$(cat /tmp/xtermj1)"

if
        test -n "$id" && xprop -id "0x${id}" 1>/dev/null 2>&1;
then
        if
                xprop -root _NET_CLIENT_LIST \
                | fgrep -q "0x${id}";
        then
                xdotool windowunmap "0x${id}"
        else
                wmctrl -i -a "0x${id}"
        fi
else
        (
                exec xterm -b 4 -name xtermj1 \
                -e sh -c "printf '%x\n' \${WINDOWID} >/tmp/xtermj1;bash" &
        )
fi

# vim: set ft=sh :
