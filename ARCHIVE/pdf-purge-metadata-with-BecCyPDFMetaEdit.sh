#!/usr/bin/env dash
#
# Run BeCyPDFMetaEdit.

wine "${HOME}/.wine/drive_c/Program Files/BeCyPDFMetaEdit/BeCyPDFMetaEdit.exe" \
        "./*.pdf" -d 2 -T "" -S "" -A "" -K "" -R "" -P "" -C "" -M "" -X 1 -q;

# vim: set ft=sh :
