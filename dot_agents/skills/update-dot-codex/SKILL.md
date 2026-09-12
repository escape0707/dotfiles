---
name: update-dot-codex
description:
  Use when the user asks what durable rules, preferences, facts, environment
  details, approval behavior, or workflow lessons should be persisted into Codex
  configuration, including AGENTS.md and ~/.codex/rules/default.rules.
---

# Update Dot Codex

When asked to persist Codex behavior or workflow learnings:

1. Separate durable lessons from transient branches, PR numbers, temporary
   paths, and conclusions specific to the current task.
2. Choose the narrowest appropriate target:
   - Global AGENTS.md for durable user, environment, tooling, and workflow
     preferences.
   - Repo-local AGENTS.md for project-specific conventions.
   - `~/.codex/rules/default.rules` for approval behavior such as
     allow/prompt/forbidden command rules.
   - The owning skill for workflow-specific practices; do not duplicate its
     procedures in global AGENTS.md.
   - Other `~/.codex` files only when the user names them or the requested
     setting clearly belongs there.
3. Inspect the existing target and managed source before proposing concise
   wording. Revise or replace overlapping rules rather than appending another
   version; preserve unrelated instructions and settings.
4. Treat `~/.codex` and `~/.agents` as chezmoi-managed:
   - Edit the corresponding source file under `~/.local/share/chezmoi/`.
   - Apply only the target file with `chezmoi apply <target-path>` after
     editing.
   - Verify the intended change reached the live target and unrelated content
     remains intact. Check source and target match where directly comparable.
5. Use `interactive-skill-crafting` when the user wants collaborative skill
   authorship. A straightforward approved rule change needs no crafting pass.
6. When a target file is outside the sandbox, request escalation instead of
   giving up.
7. For Codex approval rules, prefer narrow `prefix_rule` entries.
   Default remote-mutating or externally side-effecting commands to `prompt`.
   Verify representative intended matches and commands outside the allowed scope.
8. After verification, commit and push approved changes in the chezmoi repo,
   honoring any explicit review or delivery holds.
