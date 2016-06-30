#!/usr/bin/env dash
#
# Update root menu of openbox3.

mkdir -p "${XDG_CACHE_HOME}/openbox"

echo "<?xml version='1.0' encoding='UTF-8'?>
<openbox_menu>

<menu id='/xdg' label='xdg'>" \
> "${XDG_CACHE_HOME}/openbox/xdg-menu.xml"

xdg_menu.pl --format openbox3 --root-menu "${X_XDG_SOURCE_DIR}/arch-applications.menu" \
>> "${XDG_CACHE_HOME}/openbox/xdg-menu.xml";

echo "</menu>

</openbox_menu>" \
>> "${XDG_CACHE_HOME}/openbox/xdg-menu.xml";

sed -i \
        -e 's/id=\"/&\/xdg\//' \
        -e 's/\/\/\//\//g' \
        "${XDG_CACHE_HOME}/openbox/xdg-menu.xml";

# vim: set ts=8 sw=8 tw=0 et :
