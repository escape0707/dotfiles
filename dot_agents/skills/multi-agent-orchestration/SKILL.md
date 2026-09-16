---
name: multi-agent-orchestration
description: >-
  Coordinate user-requested bounded execution, peer delegation, and advisory
  consultation through private GitHub relays or suitable native Codex messaging.
---

# Multi-Agent Orchestration

The root Main Agent owns overall direction, shared decisions, integration, and
final delivery. Workers own their assigned outcomes. Roles follow responsibility,
not model family or reasoning level. Apply this skill as Main, worker, or advisor
according to the assignment.

## Resolve Your Role First

Before announcing an execution or delegation plan, read the assignment and its
referenced protocol and context. Determine who owns overall direction, what this
session must deliver, and where its results return. A session receiving an
existing relay assignment is its worker or advisor; execute that assignment and
return to Main. The harness's local `/root` identity does not establish the
workflow's Main role. Apply Main-only guidance only when assigned that role.

## Delegation Patterns

- **Bounded execution:** perform selected investigation, implementation, or
  downstream execution and validation stages. Main retains responsibilities not
  delegated.
- **Peer delegation:** own a substantial concern, choose approaches within its
  boundaries, and discuss material decisions with the user. Main coordinates
  shared consequences.
- **Advisory consultation:** investigate or explain a bounded question.
  Task-relevant findings and user decisions return only to Main, which decides
  any onward steering. Pure explanation can end locally without a report.

Assign any useful subset of stages. Main can retain all discussion, decisions,
and implementation while delegating only formatting, compilation, testing, or
execution in another environment. Check-only permission does not authorize
implementation repairs.

Invoking this skill or receiving an assignment does not itself authorize further
delegation. Use explicit delegation authority from the user or assignment within
the platform's constraints. An assigned worker or advisor executes its outcome
directly by default; do not pass the whole assignment to a child and become its
supervisor unless orchestration is itself assigned. Authorized assistance with
bounded subtasks does not transfer ownership of the assigned outcome.

Choose reasoning capability, trust, and environment access separately. A
closed-weight Main can own implementation while a trusted open-weight worker
performs downstream operations in a sensitive environment. Follow requested
model and effort settings; verify the actual session capabilities before relying
on them. Restricted data stays within its permitted environment; workers return
only allowed evidence.

## Transport Selection

Use private GitHub relay branches and commits for non-native coordination.
Read [GitHub relay](references/github-relay.md) when establishing or using one.

Prefer native Codex messaging when Main already runs in a suitable local Codex
harness, the assignment needs no direct human interaction with the worker, and
its access and disclosure requirements fit the available capabilities. Do not
assume that viewing a subagent conversation grants the user direct control.

Do not use isolated local Markdown handoffs as another coordination transport.
Manual transfer is for necessary artifacts unsuitable for Git; read
[manual artifacts](references/manual-artifacts.md) when needed. If neither
permitted coordination method works, report the blocker.

Read [advisory consultation](references/advisory.md) when originating or handling
an advisory conversation.

## Frame the Assignment

Inspect the current work and prior reports before delegating. Define one coherent
outcome, with:

- context, settled user decisions, and unresolved questions;
- scope, exclusions, ownership, mutation and publication authority;
- authoritative inputs, relevant repository/worktree/branch and base commits;
- dependencies, acceptance criteria, and required evidence;
- interaction and return arrangements, including any deferred review.

Reuse completed audits through exact report and commit references, with a short
orientation to what remains applicable. Do not ask a worker to rediscover settled
context or treat an old report as proof of current state.

Give capable workers freedom to choose methods within the assignment. Prescribe
commands when needed for reproducibility, a configured gate, safety, or the
bounded execution requested. Combine related mechanical work rather than
creating one round per command.

## Coordinate Parallel Work

1. Separate orthogonal concerns and assign shared contracts, dependencies, and
   integration to named owners. Trace the actual data flow before choosing
   boundaries. Distinguish an agreed interface from code available to consumers.
2. Establish each worker's actual writable workspace, branch, and baseline before
   edits. A new worktree does not change an existing session's write permissions.
   Preserve user work, requested archives, and running previews when reconciling
   workspaces.
3. Let independent work proceed while dependencies are pending. Deliver shared
   changes with exact commits and tell consumers what is ready. Coordinate before
   changing an active worker's worktree, shared configuration, or dependencies.
4. Carry material user decisions and changed assumptions back to Main promptly;
   do not wait for final implementation to reveal a cross-worker conflict. Main
   reconciles affected contracts and sends focused steering to their owners.
5. Distinguish publication from notification and receipt. Use an available
   notification mechanism or provide a short user-forwardable message naming
   the branch, round, and report. A GitHub commit does not wake an idle session.

User decisions made with a worker or advisor remain user decisions. Do not seek
duplicate approval merely because they came through another conversation. Main
raises genuine conflicts or new consequences with the user. Platform constraints
still apply; scope changes do not imply unrelated permissions.

Use `interactive-decision-review` for material choices and `quote-explain-hunk`
for interactive code explanation. Preserve their review and implementation
boundaries. Do not turn deferred review into approval or delay an implementation
report solely because review was explicitly deferred.

## Integrate and Verify

Main reads the original report, user decisions, deviations, work commits, and
relevant advisory reports before directing further work. Verify material claims
with targeted checks; do not repeat the worker's entire task.

Match evidence to the claim: input identity, schema validity, recomputation,
mocked behavior, assembled application behavior, and deployed behavior establish
different things. Run required gates in the relevant environment. Repeat checks
when changes or unresolved evidence justify them.

Integrate coherent changes with their dependency and lockfile consequences.
Keep unrelated user work out of checkpoints, and choose commits by durable
intent rather than round order. Honor publication and history-rewrite authority;
verify changes to other repositories or external systems separately.

Report implementation, validation, review, publication, and remaining work
accurately. Handle settled mechanical corrections directly within authorization;
use another assignment when the remaining work benefits from delegation.
