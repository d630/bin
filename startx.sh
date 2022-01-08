#!/usr/bin/env bash
#
# My mini wrapper for xinit.
#
# Allow only one xserver; start always on /dev/tty1 and use :0.
#
# $ . startx.sh

function __startx {
    if ! ((EUID)); then
        printf '%s: May not run as superuser; aborting\n' "${FUNCNAME[0]}" 1>&2
        return 1
    fi

    declare -i c
    c=$(exec -- fgconsole 2>/dev/null)

    if ((c != 1)); then
        printf '%s: Not on /dev/tty1; aborting\n' "${FUNCNAME[0]}" 1>&2
        return 1
    fi

    command -- rm -rf /tmp/.X11-unix 2>/dev/null

    #umask 077
    #cp -bf "$XERRFILE" "$XERRFILE" 2>/dev/null;
    # rm -f "$XERRFILE" 2>/dev/null;
    # touch "$XERRFILE" && chmod 600 "$XERRFILE" || return 1;

    declare hn mc sxauth
    hn=$(exec -- hostname -f)
    mc=$(exec -- mcookie)
    sxauth=$(exec -- mktemp --tmpdir serverauth.XXXXXXXXXX)

    command -- xauth -q remove :0 "$hn:0" "$hn/unix:0"
    command -- xauth -q <<-IN
		add :0 . $mc
		add $hn:0 . $mc
		add $hn/unix:0 . $mc
	IN

    command -- logger --id="$$" -t startx.sh -p user.info "Initializing X session for $LOGNAME"

    (
        cd -- "$HOME" ||
            exit 1
        exec 1> >(exec -- logger -e --id=$$ -t Xorg.0 -p user.notice) 2>&1
        exec -- xinit "$XINITRC" -- "$HOME/.xserverrc" -auth "$sxauth"
    )

    command -- logger --id=$$ -t startx.sh -p user.info "Finishing X session for $LOGNAME"

    # TODO
    command -- dbus-update-activation-environment DISPLAY=
    command -- systemctl --user unset-environment DISPLAY

    command -- daylight
}

__startx
unset -f __startx

# vim: set ft=zsh :
