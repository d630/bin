#!/usr/bin/env dash
#
# Unhide all xwindows on current desktop, and the active region of xwinreg.

xwinreg-unhide-active-region.sh

get-xids.sh \
| xwinpp -I - --hidden --desk=curr -p \
| xwinmo - -U;

# vim: set ts=8 sw=8 tw=0 et :
