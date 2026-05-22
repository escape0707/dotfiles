# Dotfiles

This repository is managed with chezmoi.

The current goal is inventory first:

- Keep each machine on its own branch while its real state is being discovered.
- Compare machine branches to identify common, role-specific, machine-specific,
  secret, and local-only state.
- Use ignore rules to organize inventory by machine or role.
- Add templates only after the inventory differences are understood.

## Branch Roles

- `main`: eventual centralized source of truth.
- Machine branches such as `desktop-wsl` and `laptop-linux`: temporary snapshots
  of deployed machine state.

## Privacy and Security

- Do not commit secrets, tokens, host keys, account databases, browser profile
  state, caches, logs, or generated application state.
- Before sharing externally, redact private or machine-specific values.
- When practical, represent private values with chezmoi template data such as
  `{{ .chezmoi.homeDir }}`, `{{ .chezmoi.username }}`, local `[data]`,
  role-specific ignore rules, or system-keyring lookups like
  `{{ keyring "service" "user" }}`.
- Do not put real secrets in tracked files or local `[data]`.
