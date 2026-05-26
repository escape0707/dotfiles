function _gh_view_all_fields
    switch $argv[1]
        case ghi
            set kind issue
        case ghpr
            set kind pr
        case '*'
            return 1
    end

    echo "gh $kind view --json "(gh $kind view --json 2>&1 | tail -n +2 | string trim | string match -v projectCards | string join ,)" % | clip.exe"
end
