# Dotfiles

This repository is managed with chezmoi.

## Workflow

- Inventory first: keep each machine or environment on its own branch while its
  real state is being discovered.
- Normalize second: compare branches, remove irrelevant state, and template
  private, secret, role-specific, or machine-specific values after the drift is
  understood.
- Unify last: merge the cleaned branches into `main` with data, roles,
  templates, and ignore rules that make `chezmoi apply` safe on each target.

## Branch Roles

- `main`: shared documentation now, eventual centralized source of truth later.
- Machine branches: temporary inventory and cleanup branches for deployed state.

## Privacy and Security

- Do not commit secrets, tokens, host keys, account databases, browser profile
  state, caches, logs, or generated application state.
- Before sharing externally, redact private or machine-specific values.
- When practical, represent private values with chezmoi template data such as
  `{{ .chezmoi.homeDir }}`, `{{ .chezmoi.username }}`, local `[data]`,
  role-specific ignore rules, or system-keyring lookups like
  `{{ keyring "service" "user" }}`.
- Do not put real secrets in tracked files or local `[data]`.
