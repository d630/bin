#!/usr/bin/env bash
#
# Print horizontal line.
# Source: http://wiki.bash-hackers.org/snipplets/print_horizontal_line

#printf '%*s\n' "${1:-$(tput cols)}" ' ' | tr ' ' -
printf -v horiz '%*s\n%s' "${1:-$(tput cols)}" ''
printf '%s' "${horiz// /-}"
#eval printf %.0s- '{1..'"${1:-$(tput cols)}"\}; echo

# vim: set ts=8 sw=8 tw=0 et :
