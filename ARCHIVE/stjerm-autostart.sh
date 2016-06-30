#!/usr/bin/env dash
#
# Run stjerm.

stjerm -m windows -k c -ah false -o 100 -w 100% -h 20% -p bottom \
        -sh /bin/bash -l 5000 -st never -ub false \
        -fn "-*-terminus-medium-*-*-*-14-*-*-*-*-*-iso10646-*" -ab false;

# vim: set ts=8 sw=8 tw=0 et :
