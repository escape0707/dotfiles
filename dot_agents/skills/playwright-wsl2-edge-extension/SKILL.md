---
name: playwright-wsl2-edge-extension
description:
  Operate Playwright CLI reliably from WSL2 against Windows Microsoft Edge
  through Playwright Extension. Use when starting, attaching, recovering, or
  troubleshooting extension-backed Edge sessions across WSL2 and Windows,
  including relay timeouts, short-lived agent-started bridges, hung commands, or
  lost sessions.
---

# Playwright WSL2 Edge Extension

Use `$playwright-cli` for general command syntax. This skill owns only the
environment-specific startup, attachment, and recovery procedure for controlling
Windows Edge from WSL2. Keep application-specific navigation, submission, and
artifact policies in the calling workflow.

## Start the Session

1. Ensure the user has a Playwright Extension token, but do not ask them to
   paste or echo it into the conversation.
2. While [`openai/codex#14875`](https://github.com/openai/codex/issues/14875)
   remains unresolved for the installed Codex build, have the user own the
   extension bridge in a persistent external shell. Do not run `open`, `attach`,
   or another Playwright startup command from a one-shot agent tool call.
3. Have the user configure and start the session in their persistent `fish`
   shell:

   ```fish
   set --global --export NODE_OPTIONS '--dns-result-order=ipv4first'
   set --global --export PLAYWRIGHT_MCP_EXECUTABLE_PATH '/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'

   read --silent --prompt-str 'Extension token: ' playwright_extension_token
   set --global --export PLAYWRIGHT_MCP_EXTENSION_TOKEN "$playwright_extension_token"
   set --erase playwright_extension_token

   playwright-cli attach --extension=msedge --session=<purpose-specific-session>
   ```

4. Replace `<purpose-specific-session>` with a stable descriptive name for the
   current workflow, such as `job-application`, `ui-review`, or `site-debug`.
5. Keep that shell and its blocking `attach` command running for the lifetime of
   the browser session.
6. Reuse the same session name for agent-controlled commands:

   ```bash
   playwright-cli -s=<purpose-specific-session> snapshot
   ```

Do not set `PWTEST_EXTENSION_USER_DATA_DIR`. It has not worked reliably with the
user's Windows Edge profile.

Force IPv4 preference for this cross-OS path. Windows Edge cannot reach an
extension relay advertised as `ws://[::1]:<port>/...` through the user's WSL2
localhost forwarding, while `ws://127.0.0.1:<port>/...` works. Upstream closed
[`microsoft/playwright#41180`](https://github.com/microsoft/playwright/issues/41180)
as an environment IPv4/IPv6 mismatch, so retain this setup independently of the
Codex startup-process issue.

Before removing the persistent-shell restriction, verify both that the Codex
issue is resolved and that the installed Codex build preserves the bridge after
a one-shot tool call exits.
