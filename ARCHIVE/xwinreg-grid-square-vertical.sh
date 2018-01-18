#!/usr/bin/env dash
#
# xwinreg-grid-square-vertical.sh

xorg-get-xids.sh \
| xwinpp print -I - --visible -P 0 \
| xwinreg -I - -L 1,max,grid-square-verti,alias:0,all;

# vim: set ft=sh :
