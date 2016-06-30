#!/usr/bin/env bash
#
# Set up that repo in ~/src.

set -e

shopt -s nullglob
shopt -s extglob
shopt -s dotglob

make () { colormake "$@" ; }

purge ()
if
        [[ -d $PKG_DEST ]]
then
        "${HOME}/src/github.com/D630/bin/bin/pkg.sh" -D "${PKG_DEST#${PKG_BASE}/}"
        rm -rfv -- "$PKG_DEST"
else
        printf '%s: %s\n' "Info: pkg had not been set up before" "$PKG_DEST" 1>&2;
fi

prae ()
{
        for d in "${@:-local/bin}"
        do
                mkdir -vp -- "${PKG_DEST}/${d}"
        done
}

post () { "${HOME}/src/github.com/D630/bin/bin/pkg.sh" -S "${PKG_DEST#${PKG_BASE}/}" ; }

SRC_NAME=${1:?src name missing}
PKG_NAME=${2:-$1}
SRC_BASE=${SRC_BASE:-${HOME}/src}
PKG_BASE=${PKG_DIR:-${HOME}/stow}
PKG_DEST=${PKG_BASE}/${PKG_NAME//\//::}

if
        [[ -d $SRC_BASE ]]
then
        printf '%s: %s\n' "Using src dir" "$SRC_BASE" 1>&2;
else
        printf '%s: %s\n' "Error: src dir/base missing" "$SRC_BASE" 1>&2;
        exit 1
fi

if
        [[ -d $PKG_BASE ]]
then
        printf '%s: %s\n' "Using pgk dir" "$PKG_BASE" 1>&2;
else
        printf '%s: %s\n' "Error: pkg dir missing" "$PKG_BASE" 1>&2;
        exit 1
fi

if
        [[ -d ${SRC_BASE}/${SRC_NAME} ]]
then
        printf '%s: %s\n' "Using src" "${SRC_BASE}/${SRC_NAME}" 1>&2;
else
        printf '%s: %s\n' "Error: src is not a directory" "${SRC_BASE}/${SRC_NAME}" 1>&2;
        exit 1
fi

if
        [[ -r ${SRC_BASE}/${SRC_NAME}/src.info ]]
then
        printf '%s\n' "File src.info available" 1>&2;
else
        printf '%s: %s\n' "Error: src.info missing" "${SRC_BASE}/${SRC_NAME}/src.info" 1>&2;
        exit 1
fi

if
        [[
                -e ${SRC_BASE}/${SRC_NAME}/${SRC_NAME##*/}.hg &&
                -e ${SRC_BASE}/${SRC_NAME}/${SRC_NAME##*/}.git
        ]]
then
        printf '%s: %s\n' "Error: too many different VCS" 1>&2;
else
        printf -v mirror "%s" "${SRC_BASE}/${SRC_NAME}/${SRC_NAME##*/}."@(hg|git)
fi

if
        [[ -d $mirror ]]
then
        printf '%s: %s\n' "Using mirror" "$mirror" 1>&2;
else
        printf '%s\n' "Error: mirror missing" 1>&2;
        exit 1
fi

if
        [[ -r ${SRC_BASE}/${SRC_NAME}/${SRC_NAME##*/} ]]
then
        printf '%s: %s\n' "Using work tree" "${SRC_BASE}/${SRC_NAME}/${SRC_NAME##*/}" 1>&2;
else
        printf '%s\n' "Error: work tree missing" 1>&2;
        exit 1
fi

cd -- "${SRC_BASE}/${SRC_NAME}/${SRC_NAME##*/}"
source ../src.info

# vim: set ts=8 sw=8 tw=0 et :
