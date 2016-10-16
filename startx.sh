#!/usr/bin/env dash
#
# My mini wrapper for xinit.
# $ . startx.sh
#
# Never ever use Debian's ugly /etc/X11/Xsession.
#
# Allow only one xserver; start always on :0 and use /dev/tty1.

__startx ()
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
        cp -bf "$XERRFILE" "$XERRFILE" 2>/dev/null;
        rm -f "$XERRFILE" 2>/dev/null;
        touch "$XERRFILE" && chmod 600 "$XERRFILE" || return 1;

        local \
                hn=$(hostname -f) \
                mc=$(mcookie) \
                sxauth=$(mktemp --tmpdir serverauth.XXXXXXXXXX);

        xauth -q remove :0 "${hn}:0"
        xauth -q <<-IN
	add :0 . ${mc}
	add ${hn}:0 . ${mc}
	IN

        printf '%s: X session started for %s at %s\n' \
                "$0" "$LOGNAME" "$(date)" >>"$XERRFILE";

        (
                exec >>"$XERRFILE" 2>&1
                exec xinit "$XINITRC" -- "${HOME}/.xserverrc" -auth "$sxauth"
        )

        printf '%s: X session terminated for %s at %s\n' \
                "$0" "$LOGNAME" "$(date)" >>"$XERRFILE";

        deallocvt

        case "$SHELL" in
       "$(command -v bash)")
                . "${HOME}/.bash_profile"
        ;;
        *)
                . "${HOME}/.profile"
        esac
}

__startx
unset -f __startx

# vim: set ts=8 sw=8 tw=0 et :
