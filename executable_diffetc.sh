#!/usr/bin/env bash
set -euo pipefail

runtime_dir=${XDG_RUNTIME_DIR:-"/run/user/$(id --user)"}

cd "${CHEZMOI_SOURCE_DIR:-$HOME/.local/share/chezmoi}/etc"

while IFS= read -r -d '' -u 3 source; do
    live="/etc/${source#./}"

    if [[ ! -e "$live" ]]; then
        printf '\n%s is missing\n' "$live"
        read -r -p 'Apply rendered source, delete source, skip, or quit? [a/d/S/q] ' reply

        case "$reply" in
            [Dd]*) rm --force -- "$source" ;;
            [Qq]*) exit 0 ;;
            [Aa]*)
                rendered=$(mktemp "$runtime_dir/diffetc.XXXXXXXXXX")
                trap 'rm --force -- "$rendered"' EXIT

                chezmoi --override-data '{"manageEtcMirror":true}' --destination / \
                    cat "$live" >"$rendered"

                sudo install -D --mode=0644 "$rendered" "$live"
                rm --force -- "$rendered"
                trap - EXIT
                ;;
        esac

        continue
    fi

    printf '\n%s\n' "$live"
    read -r -p 'Open rendered/source/live? [y/N/q] ' reply

    case "$reply" in
        [Qq]*) exit 0 ;;
        [Yy]*)
            rendered=$(mktemp "$runtime_dir/diffetc.XXXXXXXXXX")
            trap 'rm --force -- "$rendered"' EXIT

            chezmoi --override-data '{"manageEtcMirror":true}' --destination / \
                cat "$live" >"$rendered"

            SUDO_EDITOR="nvim -d $rendered $PWD/$source" sudoedit "$live" || true
            rm --force -- "$rendered"
            trap - EXIT
            ;;
    esac
done 3< <(find . -type f -print0 | sort --zero-terminated)
