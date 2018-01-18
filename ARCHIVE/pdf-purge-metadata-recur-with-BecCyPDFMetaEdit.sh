#!/usr/bin/env dash
#
# Remove PDF metadata with BeCyPDFMetaEdit (recur).

wine "${HOME}/.wine/drive_c/Program Files/BeCyPDFMetaEdit/BeCyPDFMetaEdit.exe" \
        "./*.pdf" -s -d 2 -T "" -S "" -A "" -K "" -R "" -P "" -C "" -M "" -X 1 -q;

# vim: set ft=sh :
