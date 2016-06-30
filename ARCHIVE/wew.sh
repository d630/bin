#!/usr/bin/env bash
#
# Spy xwindows via wew.
# Find wew here: https://github.com/wmutils/opt

wew_maxi ()
{
        sleep 0.5
        wmctrl -i -r "$1" -b "add,maximized_vert,maximized_horz"
}

wew_get_class ()
{
        read -r _ _ instance class < <(
                xprop -id "$1" WM_CLASS
        )
        class=${class//\"/}
        instance=${instance//[,\"]/}
}

wew_get_ws ()
{
        read -r _ _ w h < <(
                xprop -root _NET_DESKTOP_GEOMETRY
        )
        h=${h/,/}
}

wew
| {
        while
                IFS=: read -r n id
        do
                case $n in
                16)
                        wew_get_class "$id"
                        case $class in
                        Chromium | \
                        Claws-mail | \
                        Emacs | \
                        Gvim | \
                        Iceweasel | \
                        Pidgin | \
                        Spacefm | \
                        URxvt | \
                        VirtualBox | \
                        Vlc | \
                        XTerm | \
                        Xombrero | \
                        Zathura | \
                        libreoffice* | \
                        stterm-256color)
                                wew_maxi "$id"
                        ;;
                        st-256color)
                                case $instance in
                                stj1)
                                        xdotool windowmove "$id" 0 0 windowsize "$id" 100% 75%
                                ;;
                                stj2)
                                        xdotool windowmove "$id" 0 $(( h/100*75 )) windowsize "$id" 100% 25%
                                ;;
                                *)
                                        wew_maxi "$id"
                                esac
                        esac
                esac
        done
}

# vim: set ts=8 sw=8 tw=0 et :
