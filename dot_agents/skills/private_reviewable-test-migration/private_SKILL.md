---
name: reviewable-test-migration
description: Only use this skill when the user specifically invoked it.
---

# Reviewable Test Migration

Use this after the implementation has reached a working final state and the user wants the migration made reviewable. Do not over-constrain the initial implementation with this workflow unless the user asks up front.

## Goal

Turn a hard-to-review test migration into a sequence where each commit has one review purpose:

- isolate mechanical noise such as wrapping, unwrapping, renaming, moving, or reordering
- preserve the final desired file content
- make the meaningful transformation easy to inspect with `git diff`, `git ddiff`, and difftastic
- support hunk-by-hunk explanation as a coworker during review

The finish line is not just a correct migrated test file. The finish line is a reviewable PR boundary and commit history. Recommended review commands should be run by Codex before handoff, and their output should be checked for simplicity; if the output is still noisy, continue reshaping mechanical commits or suggest a better command.

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
   - Actually run the proposed review commands and inspect the output before presenting them. Do not recommend commands blindly.

4. Choose diff tools by the kind of noise.
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

5. During final review, walk only the final squashed surface unless the user asks about internal commits.
   - Quote the relevant old hunk and new hunk.
   - Explain what behavior is preserved, strengthened, or intentionally added.
   - When reviewing a migrated test file, also quote the corresponding old test when applicable.
   - Stop after one logical hunk and wait for `next`.

## Review Values

- Review ergonomics matters more than preserving legacy test style. Once a migrated test endpoint is correct, cleanup
  in the touched file is in scope when it makes the final review stricter, smaller, or easier to reason about.
- Before line-by-line review, summarize only meaningful technical decisions Codex introduced. Do not repeat decisions
  already settled with the user or mandated by this skill.
- Do not invent generic cleanup topics. Quote file evidence before presenting a decision point. If no honest, worthy
  point remains, say so and move to implementation.
- Prefer explicit behavior and test signatures over narration. Test names, helper names, typed parameters, and exact
  assertions should carry the review, not boilerplate comments or docstrings.

## Test Migration Heuristics

- One PR should finish one old test file migration, not necessarily one changed file.
- Removing the old file is appropriate after the migrated coverage is present.
- Some tests may stay in the old unit-test file if they are truly unit tests and do not need DB-backed behavior.
- Prefer exact old setup values for migrated behavior tests unless there is a concrete reason to change them.
- Prefer explicit IDs and scalar expected values owned by the test. Setup helpers should create state, not return ORM objects for assertions.
- Verify persisted state through the public service/API under test when that is the intended contract.
- Prefer module-level pytest tests and module-level underscore helpers. Keep a test class only when it provides real
  value such as marks, class-scoped fixtures, behavior grouping, inheritance, or plugin integration.
- Remove boilerplate test/helper docstrings and comments that restate the code. Keep a docstring or comment only for a
  non-obvious contract, edge case, or review hazard.
- Name helpers concisely without filler such as `test`. Create helpers should build valid persisted state; separate
  active-user/auth-context mutation into an explicit helper such as `_set_current_user`.
- Fixtures should patch or provide scoped dependencies, not secretly create database rows. Prefer a simple typed data
  stub over `MagicMock` when the code under test only reads attributes.
- For same-session integration setup, prefer `flush()` to obtain generated IDs and make rows queryable. Use `commit()`
  only when committed transaction behavior or cross-session visibility is part of the test.
- Prefer deterministic literals, with a UUID suffix only when uniqueness matters, over Faker. Use Faker only when
  realistic variation is part of the behavior being tested.
- Keep useful dimensions in generated names when they aid failure readability, for example including tag type in tag
  names for tenant/type filtering tests.
- Modernize touched SQLAlchemy tests toward `select()`, `scalar()`, and `scalars()` rather than legacy
  `query(...).first()` style.
- Use strict domain types in tests and service DTOs. If a service currently accepts strings but tests should pass enums,
  prefer a minimal production type-hint widening that preserves existing callers over casts or broad production API
  rewrites.
- Do not keep service integration tests that only prove Pydantic or framework validation. Keep tests that exercise
  service-owned behavior; rely on static typing and boundary tests for framework coercion.
- Make invalid-branch tests minimal. Avoid setup that could mask accidental database queries or current-user access.
- Prefer scoped, exact assertions over broad table assertions. Use `pytest.raises(..., match=...)` for expected error
  messages, and avoid pointless `assert ... is None` for "does not raise" methods.
- Keep long fixture names when they improve searchability; do not introduce local aliases just to shorten repeated
  fixture names.

## Do Not

- Do not leave temporary review files in `/tmp` or the worktree when branch commits can make the review path clearer.
- Do not use custom scripts when existing git/diff tools can verify the mechanical change clearly.
- Do not rewrite or squash active work unless the user asks for history cleanup.
