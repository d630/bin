#!/usr/bin/env dash
#
# xwinreg-master-south.sh

xorg-get-xids.sh \
| xwinpp print -I - --visible -P 0 \
| xwinreg -I - -L 1,1,maxi,alias:0,south -L 2,max,verti,alias:0,north;

# vim: set ts=8 sw=8 tw=0 et :
