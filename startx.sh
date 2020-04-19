#!/usr/bin/env bash
#
# My mini wrapper for xinit.
#
# Allow only one xserver; start always on /dev/tty1 and use :0.
#
# $ . startx.sh

function __startx {
	((UID)) || {
		printf '%s: May not run as superuser; aborting\n' "$FUNCNAME" 1>&2;
		return 1;
	};

	declare -i c;
	c=$(fgconsole 2>/dev/null);

	((c == 1)) || {
		printf '%s: Not on /dev/tty1; aborting\n' "$FUNCNAME" 1>&2;
		return 1;
	}

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
		'Initializing X session for '"$LOGNAME";

	(
		cd "$HOME";
		exec 1> >(logger -e --id=$$ -t Xorg.0 -p user.notice) 2>&1;
		exec xinit "$XINITRC" -- "$HOME/.xserverrc" -auth "$sxauth";
	)

	logger --id=$$ -t startx.sh -p user.info \
		'Finishing X session for '"$LOGNAME";

	# TODO
	dbus-update-activation-environment DISPLAY=;
	systemctl --user unset-environment DISPLAY;

	daylight
};

__startx;
unset -f __startx;

# vim: set ft=sh :
