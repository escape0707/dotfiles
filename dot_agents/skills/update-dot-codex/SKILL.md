---
name: update-dot-codex
description: Use when the user asks what durable rules, preferences, facts, environment details, approval behavior, or workflow lessons should be persisted into Codex configuration, including AGENTS.md and ~/.codex/rules/default.rules.
---

# Update Dot Codex

When asked to persist Codex behavior or workflow learnings:

1. Separate durable facts from one-off task details.
2. Propose only concise rules likely to help future sessions.
3. Choose the right target:
   - Global AGENTS.md for durable user, environment, tooling, and workflow preferences.
   - Repo-local AGENTS.md for project-specific conventions.
   - `~/.codex/rules/default.rules` for approval behavior such as allow/prompt/forbidden command rules.
   - Other `~/.codex` files only when the user names them or the requested setting clearly belongs there.
4. Treat `~/.codex` and `~/.agents` as chezmoi-managed:
   - Edit the corresponding source file under `~/.local/share/chezmoi/`.
   - Apply only the target file with `chezmoi apply <target-path>` after editing.
   - Commit and push the chezmoi repo after applying the change.
5. Prefer minimalism over long explanations.
6. When a target file is outside the sandbox, request escalation instead of giving up.
7. For Codex approval rules, prefer narrow `prefix_rule` entries. Remote-mutating or externally side-effecting commands should usually be `prompt`, not `allow`.
8. Avoid recording transient branches, PR numbers, temporary paths, or conclusions that only mattered for the current task.
