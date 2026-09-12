---
name: quote-explain-hunk
description:
  Use when the user asks to review or explain an existing change, patch, diff,
  or implementation interactively, one review point and its concrete hunks at a
  time.
---

# Quote Explain Hunk

Review concrete code through dependency-ordered, evidence-backed explanations,
one digestible hunk at a time.

## Responsibility

Explain existing code independently or with `interactive-decision-review`.
Understanding code need not produce decisions or implementation work.

Review can uncover corrections, new decisions, or changes to plan and scope.
Use `interactive-decision-review` for material choices, preserving review state.
Accepting steering does not authorize edits. By default, finish the full pass
before reconciling steering and obtaining implementation authorization. Only
explicit authorization for bounded or rolling implementation permits mid-pass
changes.

Keep progress, approvals, deferred judgments, and steering in conversation
context. Do not create or expand repository documents to track review; update
durable documentation only when requested or required by approved work.

## Prepare the Review Map

1. Inspect `git status --short --branch` and identify the exact implementation.
2. Establish the comparison base from the requested range, history, or merge
   base. Exclude unrelated upstream drift.
3. Inspect commits, changed files, targeted diffs, final code, call sites, and
   tests before explaining hunks. Prefer `git ddiff` or `git dshow <commit> --
   <path>` when Difftastic gives the clearest view.
4. Group by durable intent, not file order or incidental diff boundaries. Order
   explanations by dependency: introduce inputs, imports, types, and helpers
   before consumers, with enough context to explain their purpose.
5. Label points `Review point N of M`, without a duplicate progress summary.
   Explain additions, removals, or regrouping when the map changes.

## Explain Each Review Point

A point can contain several hunks. For each hunk:

1. Identify the point and affected relative paths. Quote the actual hunk with
   line numbers and an exact inspection command. Use diff format for changes
   and syntax-appropriate code blocks for pure additions or removals.
2. For unfamiliar data shapes, demonstrate representative input and output
   before terminology. Distinguish illustrative examples from actual
   code or data; do not substitute approximations for the hunk being reviewed.
3. Connect syntax to old and new behavior at the user's demonstrated knowledge
   level. Explain ownership and the concrete correctness, contract, testing,
   and maintenance consequences.
4. Distinguish verified facts, inferences, and missing evidence. Give a grounded
   conclusion or recommendation.
5. Wait for understanding and approval, or explicit deferral, before advancing.
   Answer questions against the same hunk; return to deferred judgments once
   their needed context is covered. Distinguish hunk approval from point approval.

For repeated patterns, compare every location and its consequences before
abbreviating. List the locations, quote a representative instance, and explain
why it covers the others. Never hide a unique change behind a representative.

## Complete and Hand Off

1. Reconcile the map against the comparison range. Account for every meaningful
   hunk as reviewed, explicitly abbreviated, delegated, or still unreviewed.
2. Reconcile accumulated steering before seeking implementation authorization:
   accepted changes, rejected suggestions, deferred concerns, and missing evidence.
3. For authorized implementation, use `interactive-decision-review` with the
   bounded scope, decisions, comparison range, and review state. Afterward,
   resume the pass and re-review changed hunks and unchanged code whose meaning
   was affected. Retain other approvals and deferred judgments; do not require
   the user to invoke both skills again at each handoff.
4. If the user delegates remaining review or approves a batch through their own
   editor, honor that scope and identify what was not reviewed individually.
5. Report the comparison range, inspection commands, coverage, outstanding
   concerns, and remaining verification or delivery work. Do not claim complete
   review coverage while unique changes remain unaccounted for.
