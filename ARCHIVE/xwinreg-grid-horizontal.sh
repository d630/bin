#!/usr/bin/env dash
#
# xwinreg-grid-horizontal.sh

xorg-get-xids.sh \
| xwinpp print -I - --visible -P 0 \
| xwinreg -I - -L 1,max,grid-horiz,alias:0,all;

# vim: set ts=8 sw=8 tw=0 et :
