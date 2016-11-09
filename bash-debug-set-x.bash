#!/usr/bin/env bash
#
# A debugging function for bash.
# based on http://mywiki.wooledge.org/BashGuide/Practices#Activate_Bash.27s_Debug_Mode

function debug_set_x
case $1 in
    ("")
        ! :;;
    (-)
        set -x;;
    (+)
        set +x;
        exec 4>&-;;
    (*)
        [[ -d ${1%/*} ]] && {
            exec 4>>"$1";
            BASH_XTRACEFD=4;
            set -x;
        };
esac;

# vim: set ts=4 sw=4 tw=0 et :
