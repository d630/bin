#!/usr/bin/env bash
#
# A debugging function for bash.
# Based on http://mywiki.wooledge.org/BashGuide/Practices#Activate_Bash.27s_Debug_Mode

debug_set_x ()
case $1 in
	('')
		! :;;
	(-)
		set -x;;
	(+)
		set +x;
		exec 4>&-;;
	(*)
		if
			[[ -d ${1%/*} ]];
		then
			exec 4>>"$1";
			BASH_XTRACEFD=4;
			set -x;
		fi;;
esac;

# vim: set ft=sh :
