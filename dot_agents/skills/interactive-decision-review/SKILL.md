---
name: interactive-decision-review
description: Use when the user requests interactive decisions for a complex change, or when implementation depends on material semantic, architectural, boundary, contract, ownership, or hard-to-reverse choices that require early user input.
---

# Interactive Decision Review

Settle material decisions before implementation, then implement authorized work
in coherent, reviewable batches without making routine details approval gates.

## Responsibility

This skill owns decision discovery, interactive decisions, implementation
batches, and handoffs when material choices remain. Mechanical, readily
reversible details stay delegated unless they expose a broader concern.

Use it independently or with `quote-explain-hunk`, according to the user's task.
Implementation does not require an interactive hunk review: the user's own
editor review and batch approval are sufficient when that is their preference.

Keep decisions, approvals, deferred judgments, and steering in conversation
context. Do not create or grow repository documents to track the interaction.
Update durable documentation only when requested or required by approved work.

## Build the Decision Map

1. Establish the intended outcome, scope, and controlling constraints.
2. Inspect relevant code, tests, documentation, history, and call sites. Separate
   verified behavior from assumptions and missing evidence.
3. Identify material choices about semantics, contracts, ownership, boundaries,
   data responsibility, public interfaces, error behavior, testing, or scope.
4. Exclude settled choices and routine details that expose no broader concern.
5. Order decisions by their dependencies. Label them `Decision N of M`, without
   a duplicate progress summary. Explain additions, removals, or regrouping
   rather than silently changing the map.

Remain read-only while forming and discussing the map unless implementation
is already authorized for that scope. Propose any necessary write-capable
experiment as a bounded action before running it.

## Decide Interactively

For each decision:

1. Present one cohesive choice. Introduce prerequisite concepts at the user's
   demonstrated knowledge level before asking them to decide.
2. Quote relevant evidence with relative paths and line numbers. For unfamiliar
   data shapes or contracts, show a small representative example before relying
   on terminology; label illustrative examples separately from actual evidence.
3. Explain credible alternatives and their effects on behavior, boundaries,
   implementation, testing, and future change. Give a grounded recommendation,
   distinguishing facts, assumptions, and unresolved evidence.
4. Use a proposed code example when helpful, without speculative full
   implementation or artificial micro-decisions. Group repeated instances only
   after verifying that their semantics and consequences agree.
5. Wait for the user's decision. Resolve questions against the same decision
   before advancing; preserve explicitly deferred judgments.
6. Track accepted, rejected, revised, and deferred outcomes and concerns in
   conversation context. Review can steer the plan and scope, not just fix bugs.

## Implement Approved Decisions

1. By default, finish the decision pass and any code-review pass from which it
   arose. Reconcile accumulated steering into a coherent batch and obtain
   implementation authorization. Accepting a decision alone does not authorize
   implementation during an unfinished review pass.
2. If the user explicitly authorizes a bounded implementation during review or
   grants rolling implementation authority, pause review and implement only
   that scope. Preserve the review position, approvals, and unresolved choices.
3. Include the mechanical support needed for the approved change. Do not expand
   into adjacent fixes; retain those concerns in the conversation unless they
   block correctness within scope.
4. If implementation exposes a new material choice or invalidates an assumption,
   stop at a safe boundary and revisit the affected decision before proceeding.
5. Validate the batch proportionately and report its behavior, changed files,
   and focused comparison for review. Do not treat a batch as automatically one
   decision, file, or commit.

## Choose Commit Boundaries

Derive commit boundaries from approved change intents:

- Give each commit a durable, reviewable claim. Keep supporting code, types,
  tests, and fixtures with the behavior that gives them meaning.
- Separate mechanical changes only when that creates a useful review boundary.
  Decisions and commits need not map one-to-one; avoid empty commits, temporary
  scaffolding, and fixed layer sequences created just to satisfy a workflow.
- Commit each completed, validated batch rather than leaving authorized work
  uncommitted, unless the user requests workspace-only changes.
- Make new commits while iterating. Amend, squash, or otherwise rewrite history
  only after the direction settles and the user authorizes that cleanup.

Implementation authorization includes new commits, but does not itself
authorize rewriting history, pushing, or publishing.

## Change Review Mode

If the user delegates remaining decisions, state the bounded scope and resolve
it using inspected evidence and recorded preferences. For a requested fast
route, remove intermediate waits while retaining the map, explicit assumptions,
scoped implementation, commit discipline, and proportionate validation.

Reopen an accepted decision when new evidence invalidates its assumptions or
reveals material consequences. Identify the evidence and affected decision.
Do not turn explanation-only review into mandatory design or implementation.

## Complete and Hand Off

1. Reconcile the final tree and commits against the conversational decisions.
   Confirm accepted work is implemented and rejected or deferred scope excluded.
2. Report completed checks, their results, and any remaining verification or
   delegated work. Do not declare completion while required work is outstanding.
3. Use `quote-explain-hunk` when interactive implementation review is requested;
   otherwise honor the user's chosen review method. Use domain-specific review
   where needed. Carry decisions, plan changes, comparison range, validation,
   and deferred judgments across handoffs without requiring repeated invocation.
4. After authorized implementation during review, resume the paused pass.
   Re-review changed hunks and unchanged code whose meaning was affected;
   retain other approvals and deferred judgments.
5. Report commits, review commands, open concerns, and delivery state. Push,
   publish, open a PR, or rewrite history only with authorization for that action.
