#!/usr/bin/env bash
#
# Build README.md in github.com/D630/dotfiles .

cd -- "${HOME}/stow" || exit 1;

IFS='.:' read -r _ _ p _  _ < <(
        git config --local --get remote.origin.url
)
P=https://github.com/${p}

__find ()
{
        # find . -mindepth 3 -regextype posix-egrep \
        #         -path "./bin/local/bin/*" \
        #         -prune \
        #         -o \( -type f -a -regex "\./.*/local/bin/.*\.(awk|py|sh)" \) \
        #         -exec grep -H -m 1 '^# ' {} +;
        git ls-files -z '*.awk' '*.py' '*.sh' \
        | grep -Zz -v -e '^bash/.bashrc.d/*' -e '^profile/.profile.d/*' \
        | xargs -0 grep -H -m 1 '^# ';
}

{ printf '%s' "$(< /dev/fd/0)" > ./README.md ; } <<'HEADER'
Public repo with some of my dotfiles (configs and [helper scripts](https://github.com/D630/dotfiles/blob/master/SCRIPT.md)) used on Debian GNU/Linux. All my dotfiles are managed with [xstow](http://xstow.sourceforge.net/). You can find a description of my home directory and a list of my preferred tools in the [doc-repo](https://github.com/D630/doc). See also [bin](https://github.com/D630/bin) for other scripts.

Unless otherwise stated, these files are in the public domain.
HEADER

__find \
| sort \
| {
        printf '%s\n\n' "Scripts in */local/bin:";
        while
                IFS=: read -r p c
        do
                p=${p#./}
                printf '* [%s/%s](%s/blob/master/%s): %s\n' "${p%%/*}" "${p##*/}" "${P}" "${p}" "${c#\# }"
        done
} \
> ./SCRIPT.md;

# vim: set ft=sh :
