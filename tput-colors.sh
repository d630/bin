#!/bin/sh
#
# Tput: export most terminfo/ANSI escape sequences needed for colorization.

exec 2>/dev/null

TI_AM=$(exec tput am)

TI_BLACK_F=$(exec tput setaf 0)
TI_BLACK_F_BOLD=${TI_BOLD}${TI_BLACK_F}

TI_BLUE_F=$(command -- tput setaf 4 || exec tput AF 4)
TI_BLUE_F_BOLD=${TI_BOLD}${TI_BLUE_F}

TI_BOLD=$(command -- tput bold || exec tput md)
TI_CIVIS=$(command -- tput civis || exec tput vi)
TI_CLEAR=$(exec tput clear)
TI_CNORM=$(command -- tput cnorm || exec tput ve)

TI_CYAN_F=$(exec tput setaf 6)
TI_CYAN_F_BOLD=$TI_BOLD$TI_CYAN_F

TI_ED=$(exec tput ed)
TI_EL=$(command -- tput el || exec tput ce)

TI_GREEN_B=$(exec tput setab 2)
TI_GREEN_F=$(command -- tput setaf 2 || exec tput AF 2)
TI_GREEN_F_BOLD=$TI_BOLD$TI_GREEN_F

TI_HOME=$(exec tput home)

TI_PURPLE_F=$(exec tput setaf 5)
TI_PURPLE_F_BOLD=$TI_BOLD$TI_PURPLE_F

TI_RED_B=$(exec tput setab 1)
TI_RED_F=$(exec tput setaf 1)
TI_RED_F_BOLD=$TI_BOLD$TI_RED_F

TI_RMAM=$(exec tput rmam)
TI_RMCUP=$(command -- tput rmcup || exec tput te)
TI_SGR0=$(command -- tput sgr0 || exec tput me)
TI_SMCUP=$(command -- tput smcup || exec tput ti)

TI_WHITE_B=$(exec tput setab 7)
TI_WHITE_F=$(command -- tput setaf 7 || exec tput AF 7)
TI_WHITE_F_BOLD=$TI_BOLD$TI_WHITE_F

TI_YELLOW_B=$(exec tput setab 3)
TI_YELLOW_F=$(exec tput setaf 3)
TI_YELLOW_F_BOLD=$TI_BOLD$TI_YELLOW_F

export \
    TI_AM \
    TI_BLACK_F \
    TI_BLACK_F_BOLD \
    TI_BLUE_F \
    TI_BLACK_F_BOLD \
    TI_BOLD \
    TI_CIVIS \
    TI_CLEAR \
    TI_CNORM \
    TI_CYAN_F \
    TI_CYAN_F_BOLD \
    TI_ED \
    TI_EL \
    TI_GREEN_B \
    TI_GREEN_F \
    TI_GREEN_F_BOLD \
    TI_HOME \
    TI_PURPLE_F \
    TI_PURPLE_F_BOLD \
    TI_RED_B \
    TI_RED_F \
    TI_RED_F_BOLD \
    TI_RMAM \
    TI_RMCUP \
    TI_SGR0 \
    TI_SMCUP \
    TI_WHITE_B \
    TI_WHITE_F \
    TI_WHITE_F_BOLD \
    TI_YELLOW_B \
    TI_YELLOW_F \
    TI_YELLOW_F_BOLD

# vim: set ft=sh :
