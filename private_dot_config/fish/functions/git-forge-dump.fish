function git-forge-dump
    set target $argv[1]

    if test -z "$target"
        echo "usage: git-forge-dump <github-or-gitlab-url>" >&2
        return 2
    end

    set clipboard_command
    for command in clip.exe wl-copy
        if type -q $command
            set clipboard_command $command
            break
        end
    end

    if test -z "$clipboard_command"
        echo "git-forge-dump: no clipboard command found; expected clip.exe or wl-copy" >&2
        return 1
    end

    _git_forge_dump $target | $clipboard_command
    set statuses $pipestatus
    if test $statuses[1] -ne 0
        return $statuses[1]
    end
    return $statuses[2]
end

function _git_forge_dump
    set target $argv[1]
    set parts (string match --regex --groups-only '^https?://([^/]+)/(.+?)/(?:-/)?(issues|pull|work_items|merge_requests)/([0-9]+)(?:[/?#].*)?$' -- $target)

    if test (count $parts) -eq 4
        set host $parts[1]
        set project $parts[2]
        set kind $parts[3]
        set iid $parts[4]

        if test "$host" = github.com
            switch $kind
                case issues
                    set kind issue
                case pull
                    set kind pr
            end
            gh $kind view $target --json (_git_forge_gh_fields $kind)
            return
        else
            switch $kind
                case issues work_items
                    _git_forge_dump_gitlab_issue $target $host $project $iid
                    return
                case merge_requests
                    _git_forge_dump_gitlab_mr $target $host $project $iid
                    return
            end
        end
    end

    echo "unsupported forge URL: $target" >&2
    return 2
end

function _git_forge_dump_gitlab_issue
    set target $argv[1]
    set host $argv[2]
    set project $argv[3]
    set iid $argv[4]
    set repo "https://$host/$project"
    set project_id (jq --null-input --raw-output --arg project "$project" '$project | @uri')

    jq --slurpfile notes (glab api --hostname "$host" --paginate "projects/$project_id/issues/$iid/notes?per_page=100&sort=asc&order_by=created_at" | psub) \
        '.Notes = $notes[0]' \
        (glab issue view --repo "$repo" --output json $iid | psub)
end

function _git_forge_dump_gitlab_mr
    set target $argv[1]
    set host $argv[2]
    set project $argv[3]
    set iid $argv[4]
    set repo "https://$host/$project"

    printf '===== gitlab merge_request view: %s =====\n' $target
    glab mr view --repo "$repo" --comments --system-logs --per-page 100 --output json $iid
    or return

    printf '\n===== gitlab merge_request diff: %s =====\n' $target
    glab mr diff --repo "$repo" --raw --color=never $iid
end

function _git_forge_gh_fields
    set kind $argv[1]
    gh $kind view --json 2>&1 | tail -n +2 | string trim | string match --invert projectCards | string join ,
end
