#!/usr/bin/env dash
#
# Run script for xombrero-open-url-tab.sh.

daemonize.sh terminal.sh -e sh -c "xombrero-open-url-tab.sh; exec ${SHELL}"

# vim: set ft=sh :
