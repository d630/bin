#!/usr/bin/env bash
#
# Wrapper for blscd.

source blscd

BLSCD_SHOW_HIDDEN=0 Blscd Blscd::Main "$@"

# vim: set ts=8 sw=8 tw=0 et :
