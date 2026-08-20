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

## Archived Workflows

### Refactor Review Scaffold v1

`refactor-review-scaffold` is preserved at Git tag
`archive/refactor-review-scaffold-v1`, anchored to commit
`fa7c1975f531930c4bb305041023c5572dbb7cf9`.

It is intentionally not installed as an active skill. Its reviewer-attention,
endpoint-equivalence, and diff-alignment techniques remain useful, but its fixed
seven-layer and pytest-specific workflow must be adapted to the target
refactor’s semantics before reuse.

Inspect the archived source:

```shell
git show \
  archive/refactor-review-scaffold-v1:dot_agents/skills/refactor-review-scaffold/SKILL.md
```

Restore it into the working tree for adaptation:

```shell
git restore \
  --source=archive/refactor-review-scaffold-v1 \
  -- dot_agents/skills/refactor-review-scaffold/SKILL.md
```
