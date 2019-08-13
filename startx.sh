#!/usr/bin/env bash
#
# My mini wrapper for xinit.
# $ . startx.sh
# Allow only one xserver; start always on :0 and use /dev/tty1.

function __startx {
    ((UID)) || {
        printf '%s: May not run as superuser; aborting\n' "$FUNCNAME" 1>&2;
        return 1;
    };

    declare -i c=$(fgconsole 2>/dev/null);

    if
        ! ((c));
    then
        printf '%s: Another X session was started; aborting\n' \
            "$FUNCNAME" 1>&2;
        return 1;
    elif
        ! ((c == 1));
    then
        printf '%s: Not on /dev/tty1; aborting\n' "$FUNCNAME" 1>&2;
        return 1;
    fi;

    rm -rf /tmp/.X11-unix 2>/dev/null;

    #umask 077
    #cp -bf "$XERRFILE" "$XERRFILE" 2>/dev/null;
    # rm -f "$XERRFILE" 2>/dev/null;
    # touch "$XERRFILE" && chmod 600 "$XERRFILE" || return 1;

    declare \
        hn=$(hostname -f) \
        mc=$(mcookie) \
        sxauth=$(mktemp --tmpdir serverauth.XXXXXXXXXX);

    xauth -q remove :0 "$hn:0" "$hn/unix:0";
    xauth -q <<-IN
	add :0 . $mc
	add $hn:0 . $mc
	add $hn/unix:0 . $mc
	IN

    logger --id=$$ -t startx.sh -p user.info \
        'Initializing X session '"for $LOGNAME";

	(
		cd "$HOME";
		exec 1> >(logger -e --id=$$ -t Xorg.0 -p user.notice) 2>&1;
		exec xinit "$XINITRC" -- "$HOME/".xserverrc -auth "$sxauth";
	)

    logger --id=$$ -t startx.sh -p user.info \
        'Finishing X session '"for $LOGNAME";

    # TODO
    dbus-update-activation-environment DISPLAY=;
    systemctl --user unset-environment DISPLAY;

    deallocvt;
	ProfileRcBaseConsole;

    # case $SHELL in
    #     ($BASH)
    #         . "$HOME/".bash_profile;;
    #     (*)
    #         . "$HOME/".profile;;
    # esac;
};

__startx;
unset -f __startx;

# vim: set ft=sh :
