---
name: refactor-review-scaffold
description: Only use this skill when the user specifically invoked it.
---

# Refactor Review Scaffold

Use this after the implementation has reached a working final state and the user wants the migration made reviewable. Do not over-constrain the initial implementation with this workflow unless the user asks up front.

Although this skill is named for test migration, the workflow applies to complex migrations, rewrites, and refactors where the final diff mixes meaningful changes with mechanical noise.

## Goal

Turn a hard-to-review migration into a sequence where each commit has one review purpose:

- isolate mechanical noise such as wrapping, unwrapping, renaming, moving, or reordering
- preserve the final desired file content
- make the meaningful transformation easy to inspect with `git diff`, `git ddiff`, and difftastic
- support hunk-by-hunk explanation as a coworker during review

The finish line is not just a correct migrated file. The finish line is a reviewable PR boundary and commit history. Recommended review commands should be run by Codex before handoff, and their output should be checked for simplicity; if the output is still noisy, continue reshaping mechanical commits or suggest a better command.

## Workflow

1. Identify the old source file, final migrated file, and review base.
   - Prefer final review from `git diff upstream/main...HEAD`.
   - For file-to-file migration review, compare exact blobs when path changes:
     `git ddiff OLDREV:path/to/old.py NEWREV:path/to/new.py`.

2. Let the agent implement freely first.
   - Solve the task end to end before optimizing the diff shape.
   - Verify the final implementation with the relevant tests, type checks, and linters.
   - Treat this final state as the behavior-pinned target that review scaffolding must preserve.

3. Rebuild review commits only after the final implementation is correct.
   - Prefer this structure for old-to-new migrations:
     1. `static_tool_conformance_old` and `static_tool_conformance_new`: make only formatter, linter, import-order, and type-checker conformance changes on both sides. Verify this is mechanical.
     2. `content_upgrade_old` and `content_upgrade_new`: make the meaningful content changes while blocks are still anchored on their own side.
     3. `rename_old` and `rename_new`: normalize names on both sides to improve alignment. Verify this is rename-only.
     4. `move_blocks_from_old_to_new`: move or reorder the prepared blocks from old to new. Verify this is move-only.
     5. `remove_old_duplicates`: if a logical hunk already existed on both sides, remove the old-side duplicate only after the move commit. Verify this is deletion-only.
   - Static tool conformance changes include `-> None`, mock/fixture annotations, import sorting/removal, formatter wrapping, replacing broad test-helper annotations with precise test-local shapes, and type-only casts when they have no runtime behavior effect.
   - Do not put assertion changes, fixture behavior changes, mock return behavior changes, service call changes, input value changes, or coverage changes in the static conformance commit. Those belong in the content-upgrade commit.
   - If an atomic hunk exists in both old and new files, preserve one identical final version on both sides through the move commit. Do not hide duplicate removal in the content-upgrade or move commit.
   - Keep the meaningful content-upgrade commit small enough to review with difftastic.
   - For the content-upgrade commit, make difftastic clarity the primary review bar. If `git ddiff` is noisy, improve the scaffold where practical before falling back to plain `git diff`.
   - Preserve parseable source structure during content-upgrade scaffolds when practical. Prefer upgrading tests inside the old file's existing module/class wrapper over replacing the old file with a dangling snippet, because difftastic aligns full syntax trees much better.
   - Review scaffolding commits may be non-runnable and may bypass pre-commit hooks if their claim is honest and mechanically verifiable. Their syntax only needs to be good enough for the chosen review tools such as difftastic/tree-sitter. The final result commit/state is what must be runnable and tested.
   - Each review commit should make one clear claim and include the intended review command in the commit message when useful.

4. Verify mechanical commits with simple tools before asking the user to trust them.
   - For content-upgrade commits:
     `DFT_GRAPH_LIMIT=100000000 git ddiff A..B -- old/path.py new/path.py`
     Use this as the primary review command; use `git diff --anchored='    def test_'` only as a fallback or companion view when difftastic still needs help.
   - For static tool conformance commits:
     `DFT_GRAPH_LIMIT=100000000 git ddiff A..B -- old/path.py new/path.py`
     `git diff --color-words='[A-Za-z_][A-Za-z0-9_]*|[^[:space:]]' A..B -- old/path.py new/path.py`
     Expect only annotation, import, wrapping, formatter, and type-helper noise.
   - For restore commits:
     `git diff --quiet BEFORE_REVIEW_COMMITS HEAD -- path/to/file.py`
   - For rename-only commits:
     `git diff --color-words='[A-Za-z_][A-Za-z0-9_]*|[^[:space:]]' A..B -- path/to/file.py`
   - For reorders and same-file block moves:
     `git diff --color-moved=blocks --color-moved-ws=ignore-all-space A..B -- path/to/file.py`
   - For cross-file block moves:
     `git diff --color-moved=blocks --color-moved-ws=ignore-all-space A..B -- old/path.py new/path.py`
   - For duplicate cleanup:
     `git diff --color-moved=no A..B -- old/path.py new/path.py`
     Expect only removed duplicate blocks from the old side.
   - For function/test-name set checks, prefer existing shell tools such as `rg`, `sort`, `diff`, and `comm` over custom scripts.
   - Actually run the proposed review commands and inspect the output before presenting them. Do not recommend commands blindly.

5. Choose diff tools by the kind of noise.
   - Word-level renames or `self` additions:
     `git diff --color-words='[A-Za-z_][A-Za-z0-9_]*|[^[:space:]]'`
   - Moved blocks:
     `git diff --color-moved=blocks --color-moved-ws=ignore-all-space`
   - Large test files where test definitions anchor review:
     `git diff --anchored='    def test_'`
   - Once wrapping/rename/reorder noise is isolated, use difftastic:
     `DFT_GRAPH_LIMIT=100000000 git ddiff ...`
   - When a commit series is rewritten for review, use `git range-diff` to compare the old and new series and explain whether the durable story changed.
   - When two commits should be patch-equivalent despite metadata or rebasing differences, use `git patch-id --stable` to compare stable patch IDs.

6. During final review, walk only the final squashed surface unless the user asks about internal commits.
   - Quote the relevant old hunk and new hunk.
   - Explain what behavior is preserved, strengthened, or intentionally added.
   - When reviewing a migrated test file, also quote the corresponding old test when applicable.
   - Include the `git ddiff` command for the content-upgrade commit in the final handoff.
   - Stop after one logical hunk and wait for `next`.

## Test Migration Heuristics

- One PR should finish one old test file migration, not necessarily one changed file.
- Removing the old file is appropriate after the migrated coverage is present.
- Some tests may stay in the old unit-test file if they are truly unit tests and do not need DB-backed behavior.
- Prefer exact old setup values for migrated behavior tests unless there is a concrete reason to change them.
- Prefer explicit IDs and scalar expected values owned by the test. Setup helpers should create state, not return ORM objects for assertions.
- Verify persisted state through the public service/API under test when that is the intended contract.

## Do Not

- Do not leave temporary review files in `/tmp` or the worktree when branch commits can make the review path clearer.
- Do not use custom scripts when existing git/diff tools can verify the mechanical change clearly.
- Do not rewrite or squash active work unless the user asks for history cleanup.
