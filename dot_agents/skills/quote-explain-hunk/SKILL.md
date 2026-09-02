---
name: quote-explain-hunk
description:
  Use when the user asks to review or explain an existing change, patch, diff,
  or implementation interactively, one review point and its concrete hunks at a
  time.
---

# Quote Explain Hunk

Interactively review an existing implementation through digestible,
evidence-backed change explanations.

## Responsibility

This skill owns post-implementation explanation and review of a concrete diff.
It organizes review by durable change intent while quoting every meaningful
implementation hunk.

It does not design unresolved semantics or implement corrections during the
review pass. When a hunk exposes a material decision, return to
`interactive-decision-review`. Remain review-only until the user completes or
explicitly ends the review pass and authorizes corrections.

## Prepare the Review Map

1. Inspect `git status --short --branch` and identify the exact implementation
   being reviewed.
2. Determine the comparison base from the user, branch history, merge base, or
   reviewed commit range. Do not mix unrelated upstream drift into the review.
3. Inspect the commit series, changed-file inventory, targeted diff, final code,
   relevant call sites, and tests before explaining individual hunks. Prefer
   `git ddiff` or `git dshow <commit> -- <path>` when Difftastic provides the
   clearest review surface.
4. Group the changes into durable intents rather than raw file order or Git’s
   incidental hunk boundaries. Review supporting imports, types, fixtures, and
   helpers with the consumer that gives them meaning.
5. Present a concise ordered map using `Review point N of M`. Use that label as
   the progress indicator without adding a duplicate progress summary. If later
   inspection changes the map, state what was added, removed, or regrouped.

Do not abbreviate repeated changes until their locations, semantics, and
consequences have been compared.

## Explain Each Review Point

A review point represents one durable change intent and can contain several
concrete hunks. For each review point:

1. Label it `Review point N of M` and identify every affected relative path.
2. Quote each unique consumer hunk with its relative path and line number.
   Include the exact targeted command the user can run to inspect it.
3. Use diff format for a modification, a syntax-appropriate code block for a
   pure addition or removal, and prose for explanation. Quote the actual change
   rather than reconstructing an approximate example.
4. Explain the old behavior, new behavior, owning responsibility, and concrete
   correctness, contract, testing, or maintenance consequences.
5. Distinguish verified behavior, inference, and missing evidence. State a
   grounded review conclusion or recommendation.
6. Pause for the user’s questions and judgment. Answer against the same review
   point before continuing, then record accepted corrections, deferred concerns,
   and rejected suggestions.

For repeated instances of one pattern, list every affected location, quote a
representative instance, and explain the evidence that makes the remaining
instances equivalent. Do not hide a unique semantic change behind a
representative hunk.

## Complete and Hand Off

1. Reconcile the review map against the comparison range. Account for every
   unique behavioral change as individually reviewed, explicitly abbreviated as
   a verified repeated pattern, delegated, or still unreviewed.
2. Summarize accepted corrections, rejected suggestions, deferred concerns, and
   unresolved evidence without silently treating the implementation as fully
   approved.
3. If the user authorizes corrections, hand the bounded correction set to
   `interactive-decision-review` for implementation and commit handling. After
   implementation, review every resulting behavioral change at the requested
   granularity.
4. If the user delegates the remaining review or requests a fast-forward,
   consolidate the remaining intents and locations, but state which points were
   not reviewed individually.
5. Report the comparison range, targeted review commands, reviewed points, and
   remaining delivery or verification work.

Do not claim complete review coverage when any unique change remains unaccounted
for.
