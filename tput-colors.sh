#!/bin/sh
#
# Tput: export most terminfo/ANSI escape sequences needed for colorization.

{
	TI_AM=$(tput am);

	TI_BLACK_F=$(tput setaf 0);
	TI_BLACK_F_BOLD=${TI_BOLD}${TI_BLACK_F};

	TI_BLUE_F=$(tput setaf 4 || tput AF 4);
	TI_BLUE_F_BOLD=${TI_BOLD}${TI_BLUE_F};

	TI_BOLD=$(tput bold || tput md);
	TI_CIVIS=$(tput civis || tput vi);
	TI_CLEAR=$(tput clear);
	TI_CNORM=$(tput cnorm || tput ve);

	TI_CYAN_F=$(tput setaf 6);
	TI_CYAN_F_BOLD=$TI_BOLD$TI_CYAN_F;

	TI_ED=$(tput ed);
	TI_EL=$(tput el || tput ce);

	TI_GREEN_B=$(tput setab 2);
	TI_GREEN_F=$(tput setaf 2 || tput AF 2);
	TI_GREEN_F_BOLD=$TI_BOLD$TI_GREEN_F;

	TI_HOME=$(tput home);

	TI_PURPLE_F=$(tput setaf 5);
	TI_PURPLE_F_BOLD=$TI_BOLD$TI_PURPLE_F;

	TI_RED_B=$(tput setab 1);
	TI_RED_F=$(tput setaf 1);
	TI_RED_F_BOLD=$TI_BOLD$TI_RED_F;

	TI_RMAM=$(tput rmam);
	TI_RMCUP=$(tput rmcup || tput te);
	TI_SGR0=$(tput sgr0 || tput me);
	TI_SMCUP=$(tput smcup || tput ti);

	TI_WHITE_B=$(tput setab 7);
	TI_WHITE_F=$(tput setaf 7 || tput AF 7);
	TI_WHITE_F_BOLD=$TI_BOLD$TI_WHITE_F;

	TI_YELLOW_B=$(tput setab 3);
	TI_YELLOW_F=$(tput setaf 3);
	TI_YELLOW_F_BOLD=$TI_BOLD$TI_YELLOW_F;
} 2>/dev/null;

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
	TI_YELLOW_F_BOLD;

# vim: set ft=sh :
