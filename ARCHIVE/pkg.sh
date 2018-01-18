#!/usr/bin/env dash
#
# Install that pkg.

set -e

PKG_BASE="${PKG_BASE:-${HOME}/stow}"
PKG_DEST="${PKG_DEST:-${HOME}}"

test -d "$PKG_BASE" || {
        printf '%s: %s\n' "stow dir missing" "$PKG_BASE" 1>&2;
        exit 1
}

test -d "$PKG_DEST" || {
        printf '%s: %s\n' "target dir missing" "$PKG_DEST" 1>&2;
        exit 1
}

for arg
do
        case "${arg#-}" in
        S)
                action=_
                readonly action
                shift 1
        ;;
        [DR])
                action="$arg"
                readonly action
                shift 1
        ;;
        *)
                PKG_NAME="$arg"
                readonly PKG_NAME
                shift 1
        esac
done

: "${PKG_NAME:?pkg name missing}"
: "${action:?action missing}"

test -d "${PKG_BASE}/${PKG_NAME}" || {
printf '%s: %s\n' "pkg does not exist; no directory found" "${PKG_BASE}/${PKG_NAME}" 1>&2;
        exit 1
}

xstow -v -dir "$PKG_BASE" -target "$PKG_DEST" ${action##*_*} "$PKG_NAME"

# vim: set ft=sh :
