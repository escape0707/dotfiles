# Coding Agent Guidelines

## Chezmoi Diff

This repo configures `chezmoi diff` to use difftastic for human review.
When an agent needs patch-style builtin output for scripting or precise text review, use:

```sh
chezmoi diff --use-builtin-diff
```

## /etc Mirror

`etc/**` is ignored by default. Use `manageEtcMirror=true` with `--destination /`
when rendering, diffing, or scripting the `/etc` mirror.
