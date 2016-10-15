#!/usr/bin/env dash
#
# My mini wrapper for xinit.
# $ . startx.sh


fn ()
{
        if
                test -n "$DISPLAY"
        then
                printf '%s: Another X session had been started; aborting\n' \
                        "$0" 1>&2;
                return 1
        elif
                test "$(fgconsole)" -ne 1
        then
                printf '%s: Not on /dev/tty1; aborting\n' "$0" 1>&2;
                return 1
        fi

        umask 077
        cp -bf -- "$XERRFILE" "$XERRFILE" 2>/dev/null;

        if
                touch "$XERRFILE" && chmod 600 "$XERRFILE";
        then
                (
                        exec >>"$XERRFILE" 2>&1
                        printf '%s: X session started for %s at %s\n' "$0" \
                                "$LOGNAME" "$(date)";
                        exec xinit "${HOME}/.xinitrc" -- "${HOME}/.xserverrc"
                )
                printf '%s: X session terminated for %s at %s\n' "$0" \
                        "$LOGNAME" "$(date)" >>"$XERRFILE";
                if
                        [ "$SHELL" = "$(which bash)" -a -x "$SHELL" ]
                then
                        . "${HOME}/.bash_logout"
                        . "${HOME}/.bash_profile"
                else
                        . "${HOME}/.profile"
                fi
        else
                printf '%s: Unable to create X session log/error file; aborting\n' \
                        "$0" 1>&2;
                return 1
        fi
}

fn
unset -f fn

# vim: set ts=8 sw=8 tw=0 et :
