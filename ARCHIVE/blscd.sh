#!/usr/bin/env bash
#
# Wrapper for blscd.

source blscd

BLSCD_SHOW_HIDDEN=0 Blscd Blscd::Main "$@"

# vim: set ft=sh :
