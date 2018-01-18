#!/usr/bin/env dash
#
# xwinreg-master-west.sh

xorg-get-xids.sh \
| xwinpp print -I - --visible -P 0 \
| xwinreg -I - -L 1,1,maxi,alias:0,west -L 2,max,horiz,alias:0,east;

# vim: set ft=sh :
