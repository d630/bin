#!/usr/bin/env dash
#
# Run cvlc in terminal.

daemonize.sh terminal.sh -c cvlc -t cvlc -T cvlc -e sh -c "cvlc ${1};exec ${SHELL}"

# vim: set ft=sh :
