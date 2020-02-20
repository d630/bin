#!/usr/bin/env bash
#
# My fzf keybinding script for bash.
#
# "\C-xr" -> __fzf_history
# "\C-xl" -> __fzf_readline
# "\C-xt" -> __fzf_select_dir
# "\C-xc" -> __fzf_cd
# "\C-xo" -> bash-toggle-options.bash
# "\C-xz" -> zcd
# "\C-xs" -> scd

function __fzf_bind {
    bind '"\er": redraw-current-line';
    bind '"\e^": magic-space';
};

function __fzf_unbind {
    bind '"\er":';
    bind '"\e^":';
};

function __fzf_rlw
if
    [[ -n $1 ]];
then
    \__fzf_bind;
    READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}$1${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}};
    ((READLINE_POINT = READLINE_POINT + ${#1}));
else
    \__fzf_unbind;
fi;

function __fzf_history {
    \__fzf_rlw "$(
        HISTTIMEFORMAT= history |
        command fzf +i +s --tac -n2..,.. --tiebreak=index --toggle-sort=ctrl-r |
        command sed '
            /^ *[0-9]/ {
                s/ *\([0-9]*\) .*/!\1/;
                b end;
            };
            d;
            : end';
    )";
};
bind -x '"\C-x1": \__fzf_history';
bind '"\C-xr": "\C-x1\e^\er"';

function __fzf_readline {
    eval "
        bind ' \
            \"\C-x3\": $(
                bind -l |
                command fzf +s --toggle-sort=ctrl-r;
            )'";
};
bind -x '"\C-x2": \__fzf_readline';
bind '"\C-xl": "\C-x2\C-x3"';

function __fzf_select_dir {
    \__fzf_rlw "$(
        command find -L . \
            \( -path '*/\.*' -o -fstype devfs -fstype devtmpfs -o -fstype proc \) \
            -prune \
            -o -type d -print 2>/dev/null |
        command fzf +m;
    )";
};
bind -x '"\C-x4": \__fzf_select_dir';
bind '"\C-xt": "\C-x4\e^\er"';

function __fzf_cd {
    READLINE_LINE="$(
        command find -L . \
            \( -path '*/\.*' -o -fstype devfs -fstype devtmpfs -o -fstype proc \) \
            -prune \
            -o -type d -print 2>/dev/null |
        command fzf +m;
    )";

    if
        [[ -d $READLINE_LINE ]];
    then
        READLINE_LINE="cd -- ${READLINE_LINE@Q}";
    else
        READLINE_LINE="# nothing selected";
    fi;
};
bind -x '"\C-x5": \__fzf_cd';
bind '"\C-xc": "\C-x5\C-m"';

bind -x '"\C-xo": . bash-toggle-options.bash';
bind -x '"\C-xz": \zcd';

bind -x '"\C-xs": \scd';

\__fzf_bind;

# vim: set ft=sh :
