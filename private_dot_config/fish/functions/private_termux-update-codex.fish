function termux-update-codex --description 'Install/update Codex for native Termux'
    set -l v $argv[1]
    test -n "$v"; or set v (pnpm view @openai/codex version)

    command -q tinyproxy; or pkg install -y tinyproxy; or return

    pnpm add -g --force --os=linux --cpu=arm64 @openai/codex-linux-arm64@npm:@openai/codex@$v-linux-arm64; or return
    set -l codex_bin (find -L ~/.local/share/pnpm/global/v11 -path '*/node_modules/@openai/codex-linux-arm64/vendor/aarch64-unknown-linux-musl/bin/codex' -type f -print -quit)

    mkdir -p ~/.local/bin
    printf '%s\n' \
        '#!/data/data/com.termux/files/usr/bin/sh' \
        'set -eu' \
        'export HTTPS_PROXY=http://127.0.0.1:8888' \
        'export SSL_CERT_FILE=/data/data/com.termux/files/usr/etc/tls/cert.pem' \
        'tinyproxy' \
        "exec $codex_bin \"\$@\"" \
        > ~/.local/bin/codex
    chmod 700 ~/.local/bin/codex
    fish_add_path -m ~/.local/bin

    mkdir -p ~/.codex
    touch ~/.codex/config.toml
    grep -q '^sandbox_mode[[:space:]]*=' ~/.codex/config.toml
    and sed -i 's/^sandbox_mode[[:space:]]*=.*/sandbox_mode = "danger-full-access"/' ~/.codex/config.toml
    or echo 'sandbox_mode = "danger-full-access"' >> ~/.codex/config.toml

    codex --version
end
