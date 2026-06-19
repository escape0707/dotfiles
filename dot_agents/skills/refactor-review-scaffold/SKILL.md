---
name: refactor-review-scaffold
description: Only use this skill when the user specifically invoked it.
---

# Refactor Review Scaffold

Use after an implementation is working and the user wants a migration, rewrite, or refactor made easier to review.

## Goal

Branch off a branch and rewrite into a reviewable commit series review branch without changing the final tested behavior.

Each scaffold commit must make one clear claim, and that claim must be mechanically checkable with the review command for that layer.

## Workflow

1. Start from an implementation that is already intended to be final.
2. Identify the scaffold mode and comparison target:
   - First scaffold: the comparison target is the original feature branch being scaffolded. Rebuild the five-layer scaffold so the scaffold tip matches that endpoint.
   - Scaffold revision: the comparison target is the previous `vN-1` scaffold branch. Create a new `codex/...-vN` branch and implement the requested review feedback into the correct layer while rebuilding.
3. Classify each logical hunk by where it exists at the review base, before migration edits:
   - `left-only`: exists only in one compared file or location.
   - `right-only`: exists only in the other compared file or location.
   - `base duplicate`: the same-content hunk already exists in both compared files or locations.
   - `same-purpose base pair`: both compared files or locations have hunks serving the same purpose, but their text differs.
4. Rebuild the branch using the five commit layers below, in order.
5. Verify each scaffold commit with the review command for that layer. The output must match the layer claim: mechanical layers show only mechanical changes, content layers show only meaningful anchored upgrades, movement layers show only moved or reordered blocks, and dedup layers show only deduplication.
6. Verify the endpoint check. For a first scaffold, the diff against the comparison target must be empty. For a scaffold revision, the diff against the comparison target must contain only the requested review-feedback change.

## Commit Layers

Build the scaffold in these exact five layers and order. Each layer keeps its stated purpose. If a layer has no hunks, record that it was intentionally empty/skipped in an empty commit.

Review scaffold commits are allowed to be non-runnable if their claim is honest and mechanically verifiable. The final tip must satisfy the endpoint check.

1. `static_tool_conformance_*`

   Static-tool and parseability-only changes go exclusively here unless separating them is practically impossible.

   Verify with word diff.

2. `content_upgrade_*`

   Meaning-changing migration/refactor edits go exclusively here unless separating them is practically impossible. Upgrade each hunk where it exists at the review base. For `same-purpose base pair` hunks, upgrade both sides until the final intended content is identical on both sides. Remove obsolete review-base hunks here.

   Verify with difftastic.

3. `rename_*`

   Name-only alignment goes exclusively here unless separating it is practically impossible. Behavior and structure changes stay out of this layer.

   Verify with word diff.

4. `move_or_reorder_blocks`

   Hunk relocation between files and hunk reordering within a file go exclusively here unless separating them is practically impossible. The diff must move or reorder prepared hunks without changing their content.

   Verify with `--color-moved`. The diff must contain only moved or reordered hunks, with no unmoved additions, deletions, or edits.

5. `remove_duplicates`

   Deduplication goes exclusively here unless separating it is practically impossible. This layer is strictly deduplication-only. Obsolete hunk removal belongs exclusively in `content_upgrade_*`.

   Verify with normal deletion diff plus cross-file endpoint diffs.

## Verification Commands

Static conformance:
```bash
DFT_GRAPH_LIMIT=100000000 git ddiff LAYER~..LAYER
```

Content upgrade:
```bash
DFT_GRAPH_LIMIT=100000000 git ddiff LAYER~..LAYER
```

Moved blocks and in-file reordering:
```bash
git diff --color-moved=blocks --color-moved-ws=ignore-all-space LAYER~..LAYER
```

Duplicate cleanup commit:
```bash
git diff LAYER~..LAYER
```

Duplicate cleanup cross-file endpoint checks:
```bash
git diff MOVE_LAYER:path/a.py FINAL:path/b.py
git diff MOVE_LAYER:path/b.py FINAL:path/a.py
```

For duplicate cleanup, the normal commit diff must show only removal of duplicate hunks. The cross-file endpoint diffs must show shared final hunks as unchanged context. They must show only left-file final-exclusive hunks as deletions and only right-file final-exclusive hunks as additions.

Endpoint check:
```bash
git diff comparison-target...HEAD
```

Final review surface:
```bash
DFT_GRAPH_LIMIT=100000000 git ddiff upstream/main...new-review-branch
```

Series comparison:
```bash
git range-diff --no-patch --creation-factor=95 old-review-branch...new-review-branch
```

## Handoff

Report:
- scaffold branch name
- commits and their review purpose
- intentionally empty/skipped layers
- test/lint commands run
- endpoint preservation result
- range-diff command for comparing scaffold versions
- every layer review command needed to inspect the scaffold
- final review surface command
