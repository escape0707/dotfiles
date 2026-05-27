function git-forge-dump
    set target $argv[1]

    if test -z "$target"
        echo "usage: git-forge-dump <github-or-gitlab-url>" >&2
        return 2
    end

    if type -q clip.exe
        _git_forge_dump $target | clip.exe
        set statuses $pipestatus
        if test $statuses[1] -ne 0
            return $statuses[1]
        end
        return $statuses[2]
    end

    if type -q wl-copy
        _git_forge_dump $target | wl-copy
        set statuses $pipestatus
        if test $statuses[1] -ne 0
            return $statuses[1]
        end
        return $statuses[2]
    end

    echo "git-forge-dump: no clipboard command found; expected clip.exe or wl-copy" >&2
    return 1
end

function _git_forge_dump
    set target $argv[1]

    set parts (string match --regex --groups-only '^https?://github\.com/([^/]+/[^/]+)/issues/([0-9]+)(?:[/?#].*)?$' -- $target)
    if test (count $parts) -eq 2
        gh issue view $target --json (_git_forge_gh_fields issue)
        return
    end

    set parts (string match --regex --groups-only '^https?://github\.com/([^/]+/[^/]+)/pull/([0-9]+)(?:[/?#].*)?$' -- $target)
    if test (count $parts) -eq 2
        gh pr view $target --json (_git_forge_gh_fields pr)
        return
    end

    set parts (string match --regex --groups-only '^https?://([^/]+)/(.+)/-/issues/([0-9]+)(?:[/?#].*)?$' -- $target)
    if test (count $parts) -eq 3
        _git_forge_dump_gitlab_issue $target $parts[1] $parts[2] $parts[3] issue
        return
    end

    set parts (string match --regex --groups-only '^https?://([^/]+)/(.+)/-/merge_requests/([0-9]+)(?:[/?#].*)?$' -- $target)
    if test (count $parts) -eq 3
        _git_forge_dump_gitlab_mr $target $parts[1] $parts[2] $parts[3]
        return
    end

    set parts (string match --regex --groups-only '^https?://([^/]+)/(.+)/-/work_items/([0-9]+)(?:[/?#].*)?$' -- $target)
    if test (count $parts) -eq 3
        _git_forge_dump_gitlab_issue $target $parts[1] $parts[2] $parts[3] work_item
        return
    end

    echo "unsupported forge URL: $target" >&2
    return 2
end

function _git_forge_dump_gitlab_issue
    set target $argv[1]
    set host $argv[2]
    set project $argv[3]
    set iid $argv[4]
    set kind $argv[5]
    set repo "https://$host/$project"
    set project_id (jq --null-input --raw-output --arg project "$project" '$project | @uri')

    printf '===== gitlab %s view: %s =====\n' $kind $target
    glab issue view --repo "$repo" --output json $iid
    or return

    printf '\n===== gitlab %s notes: %s =====\n' $kind $target
    glab api --hostname "$host" --paginate "projects/$project_id/issues/$iid/notes?per_page=100&sort=asc&order_by=created_at"
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
