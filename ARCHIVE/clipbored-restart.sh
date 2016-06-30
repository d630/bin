#!/usr/bin/env dash
#
# Restart clipbored.

if
        test -n "$DISPLAY"
then
        export XDG_DATA_HOME="${HOME}/local/var/lib"
        clipbored -k
        pkill clipbored
        daemonize.sh clipbored
fi

# vim: set ts=8 sw=8 tw=0 et :
