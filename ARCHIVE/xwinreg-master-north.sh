#!/usr/bin/env dash
#
# xwinreg-master-north.sh

xorg-get-xids.sh \
| xwinpp print -I - --visible -P 0 \
| xwinreg -I - -L 1,1,maxi,alias:0,north -L 2,max,verti,alias:0,south;

# vim: set ft=sh :
