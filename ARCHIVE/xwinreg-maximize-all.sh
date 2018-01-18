#!/usr/bin/env dash
#
# xwinreg-maximize-all.sh

xorg-get-xids.sh \
| xwinpp print -I - --visible -P 0 \
| xwinreg -I - -L 1,max,maxi,alias:0,all;

# vim: set ft=sh :
