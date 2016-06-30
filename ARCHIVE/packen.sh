#!/usr/bin/env dash
#
# tar and gzip $1.

tar czvf "${1}-$(date +%y%m%d-%H%M%S).tar.gz" "$1"

# vim: set ts=8 sw=8 tw=0 et :
