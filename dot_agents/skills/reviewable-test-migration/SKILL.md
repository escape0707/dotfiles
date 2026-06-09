---
name: reviewable-test-migration
description: Use when a completed test migration, test-file move, or large test rewrite needs to be reshaped into reviewable commits and reviewed with diff tools; especially when the user asks to split noise from meaningful changes, compare old and new test files, preserve final HEAD content, or review migration hunks one at a time.
---

# Reviewable Test Migration

Use this after the implementation has reached a working final state and the user wants the migration made reviewable. Do not over-constrain the initial implementation with this workflow unless the user asks up front.

## Goal

Turn a hard-to-review test migration into a sequence where each commit has one review purpose:

- isolate mechanical noise such as wrapping, unwrapping, renaming, moving, or reordering
- preserve the final desired file content
- make the meaningful transformation easy to inspect with `git diff`, `git ddiff`, and difftastic
- support hunk-by-hunk explanation as a coworker during review

## Workflow

1. Identify the old source file, final migrated file, and review base.
   - Prefer final review from `git diff upstream/main...HEAD`.
   - For file-to-file migration review, compare exact blobs when path changes:
     `git ddiff OLDREV:path/to/old.py NEWREV:path/to/new.py`.

2. Build review commits only after the final implementation is correct.
   - Use small commits for mechanical changes: class wrapping, file rename, function rename, reordering, formatting-only shape changes.
   - Put semantic migration or behavior changes in a separate commit.
   - If a review-only rename improves alignment, add one commit that renames tests to old counterpart names, then another commit that restores final names. Verify the restored HEAD is byte-identical to the intended final content.

3. Verify mechanical commits with simple tools before asking the user to trust them.
   - For restore commits:
     `git diff --quiet BEFORE_REVIEW_COMMITS HEAD -- path/to/file.py`
   - For rename-only commits:
     `git diff --color-words='[A-Za-z_][A-Za-z0-9_]*|[^[:space:]]' A..B -- path/to/file.py`
   - For reorders:
     `git diff --color-moved=blocks --color-moved-ws=ignore-all-space A..B -- path/to/file.py`
   - For function/test-name set checks, prefer existing shell tools such as `rg`, `sort`, `diff`, and `comm` over custom scripts.

4. Choose diff tools by the kind of noise.
   - Word-level renames or `self` additions:
     `git diff --color-words='[A-Za-z_][A-Za-z0-9_]*|[^[:space:]]'`
   - Moved blocks:
     `git diff --color-moved=blocks --color-moved-ws=ignore-all-space`
   - Large test files where test definitions anchor review:
     `git diff --anchored='    def test_'`
   - Once wrapping/rename/reorder noise is isolated, use difftastic:
     `DFT_GRAPH_LIMIT=100000000 git ddiff ...`

5. During final review, walk only the final squashed surface unless the user asks about internal commits.
   - Quote the relevant old hunk and new hunk.
   - Explain what behavior is preserved, strengthened, or intentionally added.
   - When reviewing a migrated test file, also quote the corresponding old test when applicable.
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
