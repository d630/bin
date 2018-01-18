#!/usr/bin/env dash
#
# Backup all uris from squid3 log.

log="${HOME}/local/var/log/urls.log"

if
        grep -o 'GET .* - HIER_DIRECT' "/var/log/squid3/access.log" \
        | cut -d ' ' -f 2 \
        | cat "$log" - \
        | sort -u > "${log}.$$";
then
        mv "${log}.$$" "$log"
fi

# vim: set ft=sh :
