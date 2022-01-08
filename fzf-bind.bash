#!/usr/bin/env bash
#
# My fzf keybinding script for bash.
#
# "\C-xr" -> __fzf_history
# "\C-xl" -> __fzf_readline
# "\C-xt" -> __fzf_select
# "\C-xc" -> __fzf_cd
# "\C-xo" -> toggle_options
# "\C-xz" -> zcd
# "\C-xs" -> scd

function __fzf_bind {
    bind '"\er": redraw-current-line'
    # bind '"\e^": magic-space';
}

function __fzf_unbind {
    bind '"\er":'
    # bind '"\e^":';
}

function __fzf_rlw {
    if [[ -n $1 ]]; then
        local ins=$1
        [[ -n $2 ]] && ins=${ins@Q}
        READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}$ins${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
        ((READLINE_POINT = READLINE_POINT + ${#ins}))
        \__fzf_bind
    else
        \__fzf_unbind
    fi
}

function __fzf_history {
    \__fzf_rlw "$(
        HISTTIMEFORMAT= history |
            exec -- fzf --height 40% +i +s --tac -n2..,.. --tiebreak=index \
                --bind=ctrl-r:toggle-sort +m --query "$READLINE_LINE" |
            exec -- sed '
                /^\s*[[:digit:]]*/ {
                    s/\s*[[:digit:]]*\s*//;
                    b end;
                };
                d;
                : end'
    )"
}
bind -x '"\C-x1": \__fzf_history'
bind '"\C-xr": "\C-x1\er"'

function __fzf_readline {
    eval "bind '\"\C-x3\": $(bind -l | exec -- fzf --height 40% +s --reverse --toggle-sort=ctrl-r)'"
}
bind -x '"\C-x2": \__fzf_readline'
bind '"\C-xl": "\C-x2\C-x3"'

function __fzf_select {
    \__fzf_rlw "$(
        exec -- find -L . -mindepth 1 \
            \( -path '*/\.*' -o -fstype sysfs -o -fstype devfs -o -fstype devtmpfs -o -fstype proc \) -prune \
            -o -type f -print \
            -o -type d -print \
            -o -type l -print 2>/dev/null |
            exec -- cut -b3- |
            exec -- fzf --height 40% --reverse +m
    )" quotes please
}
bind -x '"\C-x4": \__fzf_select'
bind '"\C-xt": "\C-x4\er"'

function __fzf_cd {
    READLINE_LINE="$(
        exec -- find -L . -mindepth 1 \
            \( -path '*/\.*' -o -fstype sysfs -o -fstype devfs -o -fstype devtmpfs -o -fstype proc \) -prune \
            -o -type d -print 2>/dev/null |
            exec -- fzf --height 40% +m
    )"

    if [[ -d $READLINE_LINE ]]; then
        READLINE_LINE="cd -- ${READLINE_LINE@Q}"
    else
        READLINE_LINE='# nothing selected'
    fi
}
bind -x '"\C-x5": \__fzf_cd'
bind '"\C-xc": "\C-x5\C-m"'

bind -x '"\C-xo": toggle_options'
bind -x '"\C-xz": \zcd'

bind -x '"\C-xs": \scd'

\__fzf_bind

# vim: set ft=zsh :
