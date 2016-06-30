#!/usr/bin/env dash
#
# dpkg --purge

dpkg -l \
| grep '^rc ' \
| cut -d " " -f3 \
| xargs dpkg --purge;

# vim: set ts=8 sw=8 tw=0 et :
