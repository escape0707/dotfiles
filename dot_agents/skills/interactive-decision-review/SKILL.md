---
name: interactive-decision-review
description: Use when the user requests interactive decisions for a complex change, or when implementation depends on material semantic, architectural, boundary, contract, ownership, or hard-to-reverse choices that require early user input.
---

# Interactive Decision Review

Collaboratively settle material decisions at the earliest evidence-backed stage,
then implement the approved decisions in reviewable batches. Reduce late
revision cost without turning mechanical work into approval ceremony.

## Responsibility

This skill owns decision discovery, interactive decision review, approved
implementation batches, and review checkpoints when material choices remain.

It does not replace domain-specific analysis, detailed hunk-by-hunk explanation,
or final verification. Mechanical and readily reversible details remain
delegated unless they expose a broader decision.

## Build the Decision Map

1. Restate the intended outcome, bounded scope, and controlling constraints.
2. Inspect the relevant implementation, tests, documentation, history, and call
   sites before asking the user to decide. Separate verified behavior from
   assumptions and unknowns.
3. Identify choices that can materially change business semantics, contracts,
   ownership, boundaries, data or transaction responsibility, error behavior,
   public interfaces, test claims, reversibility, or review scope.
4. Exclude decisions already settled by the user or repository, plus mechanical
   and readily reversible details that do not expose a broader concern.
5. Present a concise ordered map using `Decision N of M`. Use that label as the
   progress indicator without adding a duplicate progress summary. If later
   evidence changes the map, state what was added, removed, or regrouped instead
   of silently changing `M`.

Remain review-only while building and discussing the decision map unless the
user has approved rolling implementation of already accepted decisions. If
missing evidence requires a write-capable experiment, propose that bounded
experiment separately before running it.

## Decide Interactively

For each mapped decision:

1. Present one cohesive decision rather than a collection of independent
   questions or raw file hunks.
2. Quote the relevant code or other durable evidence with relative paths and
   line numbers. Include enough surrounding context to explain the current
   behavior and responsibility.
3. State the decision in one sentence, then explain the credible alternatives
   and their concrete effects on behavior, boundaries, implementation, testing,
   and future change.
4. Give a grounded recommendation. Distinguish verified facts, explicit
   assumptions, and unresolved evidence.
5. Use a representative proposed change or code example when it clarifies the
   choice; do not produce a speculative full implementation.
6. Wait for the user’s decision. Answer objections against the same decision
   before moving forward.
7. Record the outcome as accepted, rejected, revised, or deferred, including any
   concern the user wants preserved.

Do not split one intent into artificial micro-decisions. Group repeated
instances only after verifying that they share the same semantics and
consequences.

## Implement Approved Decisions

1. By default, complete the bounded decision pass, summarize its accepted,
   rejected, revised, and deferred outcomes, and obtain authorization before
   editing.
2. If the user approves rolling implementation, implement only decisions
   already accepted; unresolved later decisions remain untouched.
3. Translate accepted decisions into the smallest coherent implementation
   batch. Include necessary mechanical support without reopening settled intent.
4. Do not broaden the batch to fix adjacent concerns. Record them separately
   unless they block correctness within the approved scope.
5. If implementation reveals a new material choice, invalid assumption,
   contract mismatch, or scope expansion, stop at a safe boundary and add it to
   the decision map before proceeding.
6. After each approved batch, report the behavior and files changed, run
   proportionate validation, and provide the focused comparison the user needs
   for review.

An implementation batch is a review checkpoint, not automatically one decision,
one file, or one commit.

## Choose Commit Boundaries

When work occurs in a Git repository, derive a commit map from the approved
change intents before implementation:

- Give each commit one durable, reviewable claim rather than mirroring
  conversation order, file order, or temporary implementation steps.
- Keep supporting imports, types, tests, and fixtures with the behavior that
  gives them meaning.
- Separate mechanical renames, moves, formatting, or generated changes only
  when the separation produces an honestly checkable and useful review surface.
- Allow one decision to require several commits and several inseparable
  decisions to share one commit. Do not force a one-to-one mapping.
- Commit each completed and proportionately validated implementation batch
  according to that map instead of leaving the approved work only in the
  workspace.
- Preserve new iterative commits while the direction remains unsettled. Amend,
  squash, reorder, or otherwise rewrite history only after the direction is
  stable and the user approves the proposed cleanup.
- Do not manufacture empty commits or fixed layer sequences solely to satisfy a
  workflow.

Once the decision pass is complete and the user authorizes implementation, that
authorization includes creating new commits for the approved work unless the
user requests workspace-only changes. It does not authorize rewriting existing
history, pushing, or publishing.

## Change Review Mode

If the user delegates the remaining mapped decisions, state the bounded scope
and resolve them using the inspected evidence and recorded preferences.

If the user requests a fast route, remove intermediate waiting points while
retaining the decision map, explicit assumptions, scoped implementation, commit
discipline, and proportionate validation.

Reopen an accepted decision only when new evidence invalidates an assumption or
exposes a material consequence absent from the original review. State the new
evidence and affected decision explicitly.

## Complete and Hand Off

1. Reconcile the final tree and commit series against the decision ledger.
   Confirm that accepted decisions were implemented and that rejected or
   deferred scope did not enter the change.
2. Run validation proportionate to the affected behavior and risk. Report exact
   commands, results, and anything intentionally delegated or still unverified.
3. Route remaining review at the correct level:
   - Return to the decision map for material semantic or scope questions.
   - Use the relevant domain skill for specialized correctness review.
   - Use hunk-by-hunk explanation only when the remaining questions concern the
     concrete implementation diff.
4. Report the created commits, review commands, deferred concerns, and current
   delivery state.
5. Push, publish, open a pull request, or rewrite existing history only when the
   user has authorized that delivery action.

Do not declare completion while an approved decision remains unimplemented or a
required verification result remains unknown.
