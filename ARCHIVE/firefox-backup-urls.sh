#!/usr/bin/env bash
#
# Backup all uris in firefox with sqlite3.
# Create logfile and a record in urimark.

db_path=$(echo ${HOME}/.mozilla/firefox/*.default)/places.sqlite
log_file=${HOME}/local/var/log
log=${log_file}/urls.log
uris=${log_file}/uris_new.log

if
        sqlite3 "$db_path" '
                SELECT DISTINCT moz_places.url
                FROM moz_places
                WHERE (url LIKE "http%" OR url LIKE "ftp%" OR url LIKE "file%" OR url LIKE "mailto%" OR url LIKE "gopher%")
                UNION ALL
                SELECT DISTINCT moz_favicons.url
                FROM moz_favicons
                WHERE (url LIKE "http%" OR url LIKE "ftp%" OR url LIKE "file%" OR url LIKE "mailto%" OR url LIKE "gopher%")
                ORDER BY url' \
        | sed 's/"//g' \
        | tee "$uris" \
        | cat "$log" - \
        | sort -u \
        > "${log}.$$";
then
        mv "${log}.$$" "$log"
fi

if
        [[ -e $uris ]]
then
        while
                read -r line
        do
                um add uri="$line"
        done < "$uris"
        rm -- "$uris"
fi

# vim: set ft=sh :
