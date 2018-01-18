#!/usr/bin/env bash
#
# Do layouting dynamically (xprop -spy -root).

win_active=
win_active_old=
xids=

xprop -spy -root _NET_CLIENT_LIST \
| {
        while
                read -r _ _ _ _ xids
        do
                read -r _ _ _ _ win_active < <(
                        xprop -root _NET_ACTIVE_WINDOW
                )
                if
                        [[
                                $(xprop -id "$win_active" WM_CLASS) =~ xtermj[12] ||
                                $(xprop -id "${win_active_old:-${win_active}}" WM_CLASS) =~ xtermj[12]
                        ]]
                then
                        :
                else
                        if
                                source "${XWINREG_TMP_FILE:-${TMPDIR:-/tmp}/xwinreg_default.tmp}"
                        then
                                if
                                        printf '%s\n' ${xids//,/} \
                                        | xwinpp print -I - --visible -D curr \
                                        | ! xwinreg ${_xwinreg_options[command]};
                                then
                                        source <(
                                                printf '%s\n' ${xids//,/} \
                                                | xwinpp print -I - --visible -D curr -P 0;
                                        )
                                        wmctrl -i -r "$_xwinpp_win_xid" -b "add,maximized_vert,maximized_horz"
                                }
                        else
                                printf '%s\n' ${xids//,/} \
                                | xwinpp print -I - --visible -D curr -P end \
                                | xwinreg -I - -L 1,1,maxi,alias:0,west -L 2,max,horiz,alias:0,east;
                        fi
                fi
                win_active_old=$win_active
        done 2>/dev/null
}

# vim: set ft=sh :
