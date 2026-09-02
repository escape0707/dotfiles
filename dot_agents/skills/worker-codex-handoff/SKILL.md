---
name: worker-codex-handoff
description: >-
  Never invoke unless the user explicitly chooses `$worker-codex-handoff` by
  name. Coordinate substantial work with a separate user-operated Codex through
  repository-local prompt and response artifacts; do not use for ordinary
  subagent delegation.
---

# Worker Codex Handoff

Coordinate substantial work between the main Codex and a separate,
user-operated Codex session that shares the same repository workspace.

The main Codex owns scope, synthesis, independent verification, and final
delivery. The worker Codex owns one bounded investigation, review, decision
pass, or implementation outcome and reports its evidence through a matching
response artifact.

This workflow is distinct from subagents. The main Codex writes the complete
worker prompt to a repository-local Markdown file and names the matching
response path. The user sends the worker only the prompt path. After the worker
finishes, the user returns only the response path to the main Codex. The user
does not need to copy the prompt or response contents between conversations.

## Repository-Local Handoff Contract

Use an existing repository handoff convention when one is defined. Otherwise
use:

```text
handoff/worker-codex/prompts/NNN-<short-name>-prompt.md
handoff/worker-codex/responses/NNN-<short-name>-response.md
```

The short name must use lowercase kebab-case. Keep the number and short name
identical between the prompt and response. Increment numbers monotonically and
never overwrite an earlier round.

Before creating a round, inspect repository instructions, existing handoff
files, current worktree state, and the evidence needed to make the prompt
accurate. The prompt must name its exact response path.

Use this lifecycle:

1. The main Codex writes one complete repository-local prompt.
2. The main returns a short relay message:

   ```text
   Continue from <prompt-path>.
   ```

3. The user sends that path to the separate worker Codex and interacts with it
   directly.
4. The worker performs only the bounded scope and writes its report to the
   required response path.
5. The worker gives the user a short relay message:

   ```text
   Response: <response-path>.
   ```

6. The user returns that response path to the main Codex.
7. The main reads the response before independently verifying its material
   claims or preparing another round.

A prompt or response artifact is coordination state, not automatically durable
project documentation.

## Delegate Outcomes, Not Commands

Use a separate worker when the task benefits from substantial independent
inspection, long evidence gathering, direct user interaction, specialized tool
state, or isolation from the main conversation context.

Keep deterministic mechanical work with the main Codex when the intended edits,
commands, and validation are already settled. Do not delegate merely to make a
capable worker reproduce a command-by-command script.

A worker prompt should define:

- the intended outcome;
- exact scope and exclusions;
- settled user decisions and unresolved questions;
- ownership and mutation boundaries;
- evidence and acceptance criteria;
- the required response path and concise report structure.

Give the worker room to choose implementation and inspection details. Prescribe
exact commands only when required for destructive-target safety,
reproducibility, a configured gate, or another concrete invariant.

Size each round around one coherent outcome, risk boundary, or recoverability
class—not one command, file, or validation step. Combine mechanical,
order-independent work after the relevant decisions are settled.

For interactive review:

- use `quote-explain-hunk` when the user wants concrete content or changes
  explained one review point at a time;
- use `interactive-decision-review` when the review exposes material semantic,
  ownership, lifecycle, contract, or hard-to-reverse choices;
- write the final worker response only after the interactive review concludes.

Run validation in proportion to risk. Avoid repeating identical checks,
creating correction rounds for trivial wording, or preserving temporary
ceremony after the result is independently verifiable.

## Verify and Close Each Handoff

When the user returns a response path:

1. Read the response before acting on its conclusions.
2. Reconcile it with the original prompt and decisions made during the worker
   conversation.
3. Independently verify material claims, changed scope, destructive outcomes,
   configured gates, and preserved user work.
4. Do not duplicate the worker's entire task when targeted verification settles
   the result.
5. Treat user-authorized scope changes made during the worker conversation as
   new implementation evidence requiring verification.
6. Report discrepancies before preparing more work.

Handle small mechanical corrections directly when their intent is already
settled. Create another worker round only when the remaining work benefits from
independent judgment, direct user interaction, isolated tool state, or a
meaningfully separate risk boundary.

Before a Git checkpoint:

- exclude unrelated user changes;
- keep dependency definitions and lockfile consequences together;
- choose commits by durable intent rather than conversation or round order;
- exclude temporary prompt and response artifacts unless the repository
  explicitly treats them as history;
- obtain approval before rewriting existing commits or published history;
- run only the checks required to support the checkpoint claims.

Keep prompt and response artifacts until the main Codex has verified the result
and any durable evidence has been consolidated. Then remove the temporary
handoff files before the final checkpoint unless the user explicitly chooses to
retain them.

If a worker changed another repository, global configuration, or an external
system, verify and checkpoint that state separately rather than silently folding
it into the current repository result.
