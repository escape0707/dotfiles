# Coding Agent Guidelines

## Quick Command: Reconcile / Sync

When I say `reconcile` or `sync`, note the pre-fetch `HEAD` commit ID as the
baseline, then fetch `origin/main`.
Compare that baseline, the fetched remote, the local
working tree, and live files to understand what changed and where they disagree.

Use `quote-explain-hunk` to explain each problem and `interactive-decision-review`
to decide with me which changes to keep, combine, or defer and why. After review,
carry the agreed resolutions through local source, live files, and remote `main`,
including commit and push. Verify that all three agree on the resolved changes
and report any remaining drift.

## Chezmoi Diff

This repo configures `chezmoi diff` to use difftastic for human review. When an
agent needs patch-style builtin output for scripting or precise text review,
use:

```sh
chezmoi diff --use-builtin-diff
```

## /etc Mirror

`etc/**` is ignored by default. Use `manageEtcMirror=true` with
`--destination /` when rendering, diffing, or scripting the `/etc` mirror.
