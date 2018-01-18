#!/usr/bin/env dash
#
# dpkg --purge

dpkg -l \
| grep '^rc ' \
| cut -d " " -f3 \
| xargs dpkg --purge;

# vim: set ft=sh :
