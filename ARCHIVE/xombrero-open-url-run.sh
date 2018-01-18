#!/usr/bin/env dash
#
# Run script for xombrero-open-url.sh.

daemonize.sh terminal.sh -e -sh -c "xombrero-open-url.sh;exec ${SHELL}"

# vim: set ft=sh :
