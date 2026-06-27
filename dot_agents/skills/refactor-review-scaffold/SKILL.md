---
name: refactor-review-scaffold
description: Only use this skill when the user specifically invoked it.
---

# Refactor Review Scaffold

Use after an implementation is working and the user wants a migration, rewrite, or refactor made easier to review.

## Goal

Branch off a branch and rewrite into a reviewable commit series review branch without changing the final tested behavior.

Each scaffold commit must make one clear claim, and that claim must be mechanically checkable with the review command for that layer.

## Review Optimization Strategy

Optimize for reviewer attention, not implementation chronology.

Planning priority is different from commit order. Plan the scaffold by reviewer burden first, then emit the commits in
the required layer order:

1. Maximize `rename_*`, `move_or_reorder_blocks`, and `remove_duplicates`.
   These layers are mechanically reviewable and should carry every hunk that can honestly be made name-only,
   moved-only, reordered-only, or dedup-only.
2. Maximize `static_tool_conformance_*`.
   Put every static-tool, typing, parseability, formatting, and lint-only adjustment here when it can be separated
   without making the layer claim false. Put import-only adjustments here only when they are independent of later hunk
   relocation or duplicate cleanup.
3. Minimize `content_upgrade_*`.
   This is the reviewer-attention layer. It should contain only irreducible meaning changes and deletion of
   review-base hunks that have no rename, move, reorder, dedup, or same-purpose upgrade path.

Do not make a later mechanical layer empty until every candidate hunk has been classified and ruled out for that layer.

## Workflow

1. Start from an implementation that is already intended to be final.
2. Identify the scaffold mode and comparison target:
   - First scaffold: the comparison target is the original feature branch being scaffolded. Rebuild the five-layer scaffold so the scaffold tip matches that endpoint.
   - Scaffold revision: the comparison target is the previous `vN-1` scaffold branch. Create a new `codex/...-vN` branch and classify the requested feedback as `scaffold-only` or `endpoint-changing`. Scaffold-only feedback changes commit boundaries, layer placement, or reviewability while keeping the new tip tree-identical to the previous scaffold tip. Endpoint-changing feedback changes the final tree and must be implemented in the correct layer while rebuilding.
3. Classify each logical hunk by review-base topology and endpoint diff dynamic. The source/base location is where the
   hunk exists before migration edits. The endpoint location is where the final tree keeps that responsibility.
   - `one-way-migrated`: exists in one review-base location, has no same-purpose hunk in the endpoint location at the
     review base, and its responsibility relocates to that endpoint location by the final tree.
   - `deleted-obsolete`: exists in a review-base location, and no final endpoint hunk keeps that responsibility.
   - `not-relocated`: exists in a review-base location that is already its endpoint location.
   - `base duplicate`: the same-content hunk already exists in both compared files or locations.
   - `same-purpose base pair`: both compared files or locations have hunks serving the same purpose, but their text differs.
4. For every hunk, choose a layer path, not just one layer. A hunk can be upgraded in `content_upgrade_*`, renamed in
   `rename_*`, then moved in `move_or_reorder_blocks`. Prefer paths that shift the largest honest portion into
   `rename_*`, `move_or_reorder_blocks`, `remove_duplicates`, then `static_tool_conformance_*`; use
   `content_upgrade_*` only for the irreducible semantic remainder.
5. Rebuild the branch using the five commit layers below, in order.
6. Verify each scaffold commit with the review command for that layer. The output must match the layer claim: mechanical layers show only mechanical changes, content layers show only meaningful anchored upgrades, movement layers show only moved or reordered blocks, and dedup layers show only deduplication.
7. Verify the endpoint check. For a first scaffold, the diff against the comparison target must be empty. For a scaffold-only revision, the diff against the previous scaffold tip must be empty. For an endpoint-changing revision, the diff against the previous scaffold tip must contain only the requested final-tree change.

## Commit Layers

Build the scaffold in these exact five layers and order. Each layer keeps its stated purpose. If a layer has no hunks, record that it was intentionally empty/skipped in an empty commit.

Review scaffold commits are allowed to be non-runnable if their claim is honest and mechanically verifiable. The final tip must satisfy the endpoint check.

Run test, lint, type, and functional verification at the final tip. Do not move hunk-coupled cleanup into an earlier
layer only to make an intermediate scaffold commit pass lint, type, or test checks. Per-layer review commands validate
the layer claim; final-tip checks validate behavior.

1. `static_tool_conformance_*`

   Static-tool, parseability, and review-minded typing/schema improvements go exclusively here unless separating them is practically impossible.
   Import-only adjustments go here only when they are independent of later relocation or duplicate cleanup.

   This includes replacing `Any`, `cast`, loose mock payloads, or manual shape checks with typed/Pydantic validation, even when stricter helper validation changes where invalid internal data would fail.

   Verify with word diff.

2. `content_upgrade_*`

   Meaning-changing migration/refactor edits go exclusively here unless separating them is practically impossible. Upgrade each hunk where it exists at the review base. For `same-purpose base pair` hunks, upgrade both sides until the final intended content is identical on both sides. Remove only `deleted-obsolete` review-base hunks here.

   A hunk is not obsolete when the final tree keeps the same responsibility elsewhere; that removal is duplicate or same-purpose cleanup.

   For migrations between files or locations, the review-base location rule means upgraded hunks are prepared before they move; do not create them directly at their final destination.

   For `one-way-migrated` hunks, prefer upgrading the source/base hunk in place so a later layer can move or reorder
   the prepared hunk mechanically. Delete a review-base hunk here only when it is `deleted-obsolete` or cannot honestly
   be prepared for a later mechanical layer.

   `git ddiff` alignment is a critical review-quality metric for this layer. Structure upgraded helper/function/class order so Difftastic pairs each review-base hunk with its intended replacement. If `git ddiff` aligns a hunk with the wrong replacement and the endpoint can stay unchanged, revise the content-layer ordering before moving on.

   Verify with difftastic.

3. `rename_*`

   Name-only alignment goes exclusively here unless separating it is practically impossible. Behavior and structure changes stay out of this layer.

   If a hunk will later move, apply name-only alignment before the move so the movement layer can relocate unchanged hunks.

   Verify with word diff.

4. `move_or_reorder_blocks`

   Hunk relocation between files and hunk reordering within a file go exclusively here unless separating them is practically impossible. The diff must move or reorder prepared hunks without changing their content.

   For migrations, this layer moves the already-upgraded and already-renamed hunks from their review-base location to their final location.

   A `one-way-migrated` hunk should reach this layer as identical prepared content that can move from the source/base
   location to the endpoint location. If it cannot be expressed as a moved/reordered block with only mechanical
   integration residue, record why.

   Verify with `--color-moved`. The diff must be explainable as relocation or reordering of already-prepared hunks. Pure added, deleted, or edited lines are allowed only as mechanical integration residue of the move, such as deleting an emptied source file/module/class shell or inserting moved methods into an existing class. They must not carry semantic content; if they do, move that change to the earlier content or rename layer.

   Relocation-coupled imports follow the hunk path. If an import line is needed at the destination and absent there,
   move the import line here. If the destination already contains an equivalent import, keep the source import through
   this layer and remove it in `remove_duplicates`.

5. `remove_duplicates`

   Deduplication goes exclusively here unless separating it is practically impossible. This layer is strictly deduplication-only. Do not use this layer for `deleted-obsolete` hunks; those belong in `content_upgrade_*`.

   A source hunk is not obsolete when the final tree keeps the same responsibility elsewhere. Removing that source hunk
   is duplicate or same-purpose cleanup, not obsolete deletion.

   Use this layer for `base duplicate` hunks and for `same-purpose base pair` hunks that were made identical earlier.
   For `one-way-migrated` hunks, use this layer only if the chosen scaffold path intentionally creates or retains an
   identical duplicate instead of using a pure move. Do not use this layer for a pure move; a moved hunk should not leave
   a duplicate copy behind.

   Use this layer for source imports whose destination equivalent already exists after relocation. Whole-file, module-shell,
   or class-shell deletion belongs here only when every contained responsibility is already retained elsewhere or is pure duplicate/mechanical residue.

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
git diff comparison-target..HEAD
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
- for every empty layer, the candidate hunks considered and the concrete reason each hunk could not honestly fit there
- final-tip test/lint/type commands run
- endpoint preservation result
- range-diff command for comparing scaffold versions
- every layer review command needed to inspect the scaffold
- final review surface command
