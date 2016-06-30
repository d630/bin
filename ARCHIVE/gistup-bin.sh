#!/usr/bin/env bash
#
# My gistup wrapper for gist-bin-pub.

# -- FUNCTIONS.

__gistup_list ()
if
        [[ -f ./.git/config ]]
then
        typeset \
                id \
                d \
                p;
        typeset -A data
        IFS='.:' \
        read -r _ _ _ id _ < <(
                git config --local --get remote.origin.url
        )
        data[${id}_repo_name]=$desc
        while
                IFS=':' \
                read -r p d;
        do
                data[${id}_repo_files]=${data[${id}_repo_files]:+${data[${id}_repo_files]}:}${p}
                data[${id}_repo_descs]=${data[${id}_repo_descs]}${d}
        done < <(
                find "$pwd" -mindepth 1 -path "${pwd}*/.*" -prune -o -type f -printf '%P\0' \
                | xargs --null grep -HR -m 1 '^# ' \
                | sort;
        )
        typeset -p data \
        > "${gbp}/LIST.bash" &&
        gistup-bin-post.sh "$action" "$id";
else
        printf '%s:%s\n' "$0" "${msg[81]}" \
        1>&2;
        exit 81
fi

# -- MAIN.

typeset \
        action= \
        basename=${PWD##*/} \
        desc=$1 \
        dirname=${PWD%/*} \
        gbp=${X_XDG_CODE_DIR}/projects/gist-bin-pub \
        pwd=$PWD;

typeset pbasename=${dirname##*/}

typeset -a msg=(
        [79]='Note:79: Not a git repository (or any of the parent directories): .git'
        [81]='Error:81: Could not parse a conf file'
        [82]='Error:82: Could not create a git repository: a description is missing'
        [83]="Error:83: '${gbp}' is misssing"
        [85]='Error:85: Execution failed: github-add-rsa.sh'
)

github-add-rsa.sh || {
        printf '%s:%s\n' "$0" "${msg[85]}" \
        1>&2;
        exit 85
}

if
        [[ ! -e $gbp ]]
then
        printf '%s:%s\n' "$0" "${msg[83]}" \
        1>&2;
        exit 83
fi

if
        [[ ! -x $(type -p gistup) ]]
then
        printf '%s:Error:84: command not found: "gistup"\n' "$0" \
        1>&2;
        exit 84
fi

if
        [[ -d ./.git ]]
then
        action=update
        desc="${pbasename}: ${desc:-update}"
        git add -A . &&
        git commit -m "$desc" &&
        git push -u --tags origin master &&
        desc=$pbasename __gistup_list;
else
        printf '%s\n' "$0" "${msg[79]}" \
        1>&2;
        if
                ! ${desc:+false}
        then
                action=add
                gistup \
                        --no-open \
                        --public \
                        --remote origin \
                        -m "$desc -- https://github.com/D630/gist-bin-pub/tree/master/${desc}";
                __gistup_list
        else
                printf '%s:%s\n' "$0" "${msg[82]}" \
                1>&2;
                exit 82
        fi
fi

# vim: set ts=8 sw=8 tw=0 et :
