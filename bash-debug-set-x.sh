#!/usr/bin/env bash
#
# A debugging function for bash.
# based on http://mywiki.wooledge.org/BashGuide/Practices#Activate_Bash.27s_Debug_Mode

debug_set_x ()
if
        [[ $1 == - ]]
then
        set -x
elif
        [[ $1 == + ]]
then
        set +x
        exec 4>&-;
elif
        [[ -n $1 && -d ${1%/*} ]]
then
        exec 4>>"$1";
        BASH_XTRACEFD=4
        set -x
fi

# vim: set ts=8 sw=8 tw=0 et :
