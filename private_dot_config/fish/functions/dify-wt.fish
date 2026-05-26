function dify-wt
    if test (count $argv) -ne 1
        echo "usage: dify-wt <new-name>"
        return 2
    end

    set name $argv[1]
    set common_git_dir (realpath (git rev-parse --git-common-dir))
    set repo_root (dirname $common_git_dir)
    set worktrees_dir "$repo_root.worktrees"
    set path "$worktrees_dir/$name"

    git fetch --all
    or return $status

    mkdir -p $worktrees_dir
    or return $status

    git worktree add -b $name $path upstream/main
    or return $status

    uv sync --project "$path/api" --group dev
end
