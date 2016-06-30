#!/usr/bin/env bash
#
# Postprocessing gistup-bin.sh to update submodules in gist-bin-pub.

typeset \
        action \
        gbp=${X_XDG_CODE_DIR}/projects/gist-bin-pub \
        id \
        name \
        name_old \
        readme \
        url_gist=https://gist.github.com;

typeset -i \
        i \
        j;

typeset -a \
        data_names \
        descs \
        files \
        repos;

if
        [[ ! -d ${gbp}/.git ]]
then
        printf '%s:Error:84: Repo is missing in %s\n' "$0" "$gbp" \
        1>&2;
        exit 84
fi

if
        ! source "${gbp}/LIST.bash"
then
        printf '%s:Error:79: %s/LIST.bash is misssing\n' "$0" "$gbp" \
        1>&2;
        exit 79
fi

if
        typeset -p data \
        1>/dev/null \
        2>&1;
then
        printf '%s:Error:80: data is missing\n' "$0" \
        1>&2;
        exit 80
fi

case $1 in
add)
        action=add
;;
update)
        action=update
;;
*)
        printf '%s:Error:81: Unknown subcommand: %s\n' "$0" "$1" \
        1>&2;
        exit 81
esac
shift 1

git checkout master

shopt -s extglob

if
        [[ -n $1 && $1 == all ]]
then
        if
                [[ $action == update ]]
        then
                (
                        if
                                cd -- "$gbp"
                        theb
                                git submodule foreach 'git pull origin master'
                                git add -A .
                                git commit -m "auto"
                        fi
                )
                exit $?
                data_names=( ${!data[@]} )
                repos=( ${data_names[@]//+([0-9]|[a-z])_@(repo_files|repo_descs)/} )
                for i in "${!repos[@]}"
                do
                        repos[$i]="${data[${repos[$i]}]}|${repos[$i]/_/|/}"
                done
        else
                printf '%s:Error:85: Currently, "add" cannot be combined with "all"\n' "$0" \
                1>&2;
                exit 85
        fi
elif
        [[ -n $1 && $1 == +([0-9]|[a-z]) ]]
then
        repos=( "${data[${1}_repo_name]}|${1}|repo_name" )
else
        printf '%s:Error:82: Valid argument is missing: %s\n' "$0" "$1" \
        1>&2;
        exit 82
fi

shopt -u extglob

while
        IFS='|' read -r name id _
do
        mkdir -p "${gbp}/${name}"
        IFS=: read -r -a files \
        <<< "${data[${id}_repo_files]}";
        mapfile -t descs < <(
                printf '%s\n' "${data[${id}_repo_descs]//\# /$'\n'}"
        )
        descs=( "${descs[@]:1}" )
        if
                (( ${#files[@]} ))
        then
                if
                        [[ ! $name == $name_old ]]
                then
                        > "${gbp}/${name}/README.md"
                        exec 3>>"${gbp}/${name}/README.md"
                fi
                for j in "${!files[@]}"
                do
                        printf '* [%s](%s): %s\n' "${files[$j]}" "${url_gist}/${id}#file-${files[$j]//./-}" "${descs[$j]}" \
                        1>&3;
                done
                name_old=$name
        else
                printf '%s:Error:83: File data is missing: %s\n' "$0" "$id" \
                1>&2;
                continue
        fi
        (
                if
                        [[ $action == add ]]
                then
                        if
                                cd -- "$gbp"
                        then
                                git submodule add "${url_gist}/${id}" "${name}/${name}" &&
                                git submodule update --init &&
                                git add -A "$name" &&
                                git commit -m "${name}: add submodule"
                        fi
                else
                        if
                                cd -- "${gbp}/${name}/${name}"
                        then
                                git checkout master
                                git pull origin master
                                if
                                        cd -- "$gbp"
                                then
                                        git add -A "$name" &&
                                        git commit -m "${name}: update submodule"
                                fi
                        fi
                fi
        )
done < <(
        printf '%s\n' "${repos[@]}" \
        | sort;
)

exec 3<&-

{ readme=$(</dev/fd/0) ; } <<'README'
Super repository for bin-like gists on https://gist.github.com/D630

Get it with `git clone --recursive https://github.com/D630/gist-bin-pub.git`

Contents are published with:

* [gistup-bin-post.sh](https://gist.github.com/21951041cdf1c5ff47ca#file-gistup-bin-post-sh)
* [gistup-bin.sh](https://gist.github.com/21951041cdf1c5ff47ca#file-gistup-bin-sh)
* [gistup](https://github.com/mbostock/gistup)

Unless otherwise stated, these files are in the public domain:

README

if
        cd -- "$gbp"
then
        {
                printf '%s\n' "$readme";
                find . -mindepth 2 -maxdepth 2 -name README.md \
                | xargs cat \
                | sort;
        } > README.md
        git add -A README.md
        git commit -m 'gist-bin-pub: update README.md'
        git push -u --tags origin master
fi

# vim: set ts=8 sw=8 tw=0 et :
