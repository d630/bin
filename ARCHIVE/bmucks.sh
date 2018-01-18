#!/usr/bin/env bash
#
# Mini session manager for tmux and screen.
# GNU GPLv3, Copyright 2014f. D630
# Forked from https://bitbucket.org/zserge/mucks
#
# See https://github.com/D630/dotfiles/blob/master/bmucks/local/etc/bmucksrc

__bmucks_new ()
if (( i ))
then    __bmucks_new_window "${TMP}/${config[id]}" "${windows[i]}"
else
        __bmucks_new_session "${TMP}/${config[id]}" "${config[id]}" \
                "${windows[i]}" \
        || {
                printf '%s:Error:82: Could not create new session\n' "$0" \
                1>&2;
                exit 82
        }; fi

__bmucks_count_panes ()
while [[ -n ${panes[${windows[i]}|${panes_nr}]} ]] && panes_nr=panes_nr+=1;
do true; done

__bmucks_process ()
for (( j=0 ; j <= $panes_nr ; ++j ))
do
        case ${panes[${windows[i]}|${j}]%% *} in
        split|hsplit)
                __bmucks_hsplit "${TMP}/${confif[id]}" "${windows[i]}"
                ;;
        vsplit)
                __bmucks_vsplit "${TMP}/${config[id]}" "${windows[i]}"
                ;;
        layout)
                __bmucks_layout "${TMP}/${config[id]}" \
                        "${panes[${windows[i]}|${j}]#* }";
                ;;
        sleep)
                sleep ${panes[${windows[i]}|${j}]#* }
                ;;
        *)
                __bmucks_send "${TMP}/${config[id]}" \
                        "${panes[${windows[i]}|${j}]}" "${windows[i]}";
        esac; done

__bmucks_parse_config ()
{
        typeset -i \
                i= \
                j= \
                panes_nr=;

        source "$1" || {
                printf '%s:Error:80: Could not source conf file: %s\n' \
                        "$0" "$1" \
                1>&2;
                exit 80
        }

        __bmucks_set_bmucks

        for (( ;i < ${#windows[@]}; ++i , panes_nr=0 ))
        do
                __bmucks_new
                __bmucks_count_panes
                __bmucks_process; done

        __bmucks_finalize "${TMP}/${config[id]}" "${config[id]}"
}

__bmucks_set_bmucks ()
case ${config[bmucks]} in
tmux)
        __bmucks_finalize      { tmux -S "$1" attach-session -t "$2"                   ; }
        __bmucks_hsplit        { tmux -S "$1" split-window -v                          ; }
        __bmucks_layout        { tmux -S "$1" select-layout $2                         ; }
        __bmucks_new_session   { tmux -S "$1" new-session -d -s "$2" -n "$3"           ; }
        __bmucks_new_window    { tmux -S "$1" new-window -n "$2"                       ; }
        __bmucks_send          { tmux -S "$1" send-keys "$2" "C-m"                     ; }
        __bmucks_vsplit        { tmux -S "$1" split-window -h                          ; }
        ;;
screen)
        __bmucks_finalize      { screen -r "$2"                                        ; }
        __bmucks_hsplit        { screen -S "${1##*/}" -X screen -t "$2" ${SHELL:-bash} ; }
        __bmucks_new_session   { screen -d -m -S "$2" -t "$3"                          ; }
        __bmucks_new_window    { screen -S "${1##*/}" -X screen -t "$2" ${SHELL:-bash} ; }
        __bmucks_send          { screen -S "${1##*/}" -p "$3" -X stuff "${2}\n"        ; }
        __bmucks_vsplit        { screen -S "${1##*/}" -X screen -t "$2" ${SHELL:-bash} ; }
        ;;
*)
        printf '%s:Error:81: Unknown bmucks: %s\n' "$0" "${config[bmucks]}" \
        1>&2;
        exit 81
esac

# -- MAIN.

TMP=${TMPDIR:-/tmp}

typeset -A config=(
        [file]=${1:-${XDG_CONFIG_HOME}/bmucksrc}
        [id]=bmucks${$}
)

trap "{ rm -f "${TMP}/${config[id]}" ; exit 255 ; }" INT TERM QUIT EXIT

2>/dev/null __bmucks_parse_config "${config[file]}" || exit 79;

# vim: set ft=sh :
