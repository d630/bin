#!/usr/bin/env dash
#
# Select url with menu and open it in a new tab in xombrero.

count="$(pgrep -c xombrero)"

file_uris="${HOME}/local/var/log//urls.log"
uri="$(
        grep -oP -e '((http|https|gopher|ftp|ftps|webdav|webdavs|dav|davs):(//)?[^ <>"\t]*|(www|ftp)[0-9]?\.[-a-z0-9.]+)[^ .,;\t\n\r<">\):]?[^, <>"\t]*[^ .,;\t\n\r<">\):]' "$file_uris" \
        | menu.sh "dmenu2" ">";
)"

test -n "$uri" || exit 1;

if
        [ "$count" -eq 0 ]
then
        setsid.sh xombrero "$uri"
else
        xombrero -n "$uri"
fi

# vim: set ts=8 sw=8 tw=0 et :
