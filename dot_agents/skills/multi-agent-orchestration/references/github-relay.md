# GitHub Relay

## Repository and Channels

Use the private `<github-login>/agent-relay` repository for the authenticated
GitHub identity. Reuse existing infrastructure. If the repository is missing,
report the prerequisite; create it only when the user requests it. Keep relay
state separate from project repositories, without a repository-binding config.

Local layout:

```text
~/workspaces/agent-relay/
├── repo/
└── worktrees/
    └── <relay-branch-safe-name>/
```

Each channel has one Main–worker or Main–advisor writer pair. Parallel workers
use separate branches. Follow the user's branch convention, for example
`codex/relay-capital-ui`. Project changes stay on project branches; reference
their commits instead of copying large diffs into the relay.

Fetch the relevant branch and reuse or establish its isolated worktree. Use the
intended Git operations to establish access; do not add authentication probes.
Give a new session a short bootstrap naming this skill, its role, relay branch,
and assigned round. Provide the project workspace and model/effort settings when
needed to start the intended session.

Formal prompts, responses, and relay commits use English unless the user requests
another language or task semantics require it. User conversation follows the
established language.

## Rounds and Status

Only Main creates formal rounds. Workers keep related user additions within the
current round and report changed scope; they do not invent a next round or suffix.
Published prompts remain immutable. Send subsequent steering through forward
commits carrying a clearly identified supplementary artifact or a new round.

```text
rounds/
└── 0001-<slug>/
    ├── prompt.md
    ├── response.md       # absent while pending
    ├── artifacts/        # optional
    └── artifacts.json    # optional, only when useful
```

Preserve existing branches, round paths, and history when adopting this skill.
Do not introduce registries, session/status files, heartbeats, locks, cumulative
summaries, or narrative logs as protocol state.

- `prompt.md` present, `response.md` absent: pending/open.
- `response.md` present: terminal, with outcome `Completed`, `Partial`, or
  `Blocked`. All three require Main to decide any follow-up; none automatically
  authorizes a rerun.

Judge completion against the assigned outcome. Implementation can be `Completed`
with tests or documentation review explicitly deferred. Required unfinished work
is `Partial`, or `Blocked` when a blocker prevents progress. State what remains.

An explicitly selected round takes precedence. Otherwise, for `next round`,
synchronize the branch and select the lowest-numbered pending round. If none
exists, report that without creating one. Main keeps one open round per channel
unless intentionally queuing independent work. A separately assigned
retrospective can finish while earlier paused work remains open.

`pause` stops execution and leaves the round open; publish a partial response only
when requested. `resume` reconstructs the open round from its prompt, Git state,
artifacts, and actual machine state without repeating non-idempotent actions.
Interpret `next` and `continue` in the active conversation; neither automatically
abandons the current discussion for a new round.

## Prompt and Response

Adapt headings to the task, preserving these distinctions without duplicating
metadata already clear from the path.

A prompt establishes the objective, context and prior evidence, allowed scope,
ownership and permissions, settled decisions and open questions, deliverables,
acceptance evidence, and return policy. Name the exact response path. Describe
outcomes rather than imposing an expert worker's implementation recipe.

A response contains:

```markdown
# Round 0001 — Response

## Outcome
Completed / Partial / Blocked

## Findings
Evidence and conclusions.

## User Decisions / Instructions
Durable choices relevant to Main, or None.

## Actions Performed
Actual operations and side effects.

## Changes
Work repository, branch, base/result commits, and summary; or no project changes.

## Validation
Checks, results, evidence limits, and deferred reviews.

## Artifacts
Committed references and any prepared manual package, or None.

## Advisory Consultations
Original report locations relevant to this task, or None.

## Deviations
Material departures, including user-authorized scope changes, or None.

## Issues / Decisions Needed
Unresolved matters for Main, or None.
```

Existing `Nested Relays` sections remain readable as consultation references;
do not rewrite historical reports. Ordinary clarification needs no transcript.

Prepare required artifacts and any manual package before publishing a terminal
response. If a required artifact cannot be produced, state the omission and its
effect on the outcome rather than promising it in a `Completed` response.

Publish material interim steering in a supplementary round artifact when needed;
do not create `response.md` merely to notify Main while the round remains open.
Notify Main through the available mechanism or a user-forwardable message.

## Publication and Recovery

Published history moves forward. Do not force-push, amend, or rebase published
relay history by default. Correct a response with an explicit forward commit;
do not silently change its meaning. Suggested commit labels:

```text
[relay][R0001][prompt] <title>
[relay][R0001][response] <title>
[relay][R0001][response-fix] <correction>
```

If a push is rejected because the remote moved, fetch and preserve the other
endpoint's work, then integrate unpublished changes and push a forward-moving
result. Recover interrupted work from actual state rather than adding recovery
metadata. Follow the user's normal Git permission and publication rules.

## Channel Completion and Cleanup

When the channel's overall task finishes or the user cancels it, automatically
suggest cleanup. A terminal round alone does not establish channel completion.

Name the exact relay branches, local worktrees, and temporary artifacts proposed
for removal. Identify unread reports, unpublished work, and evidence that would
be lost; preserve required evidence before deletion. Ask for approval of the
concrete cleanup. Do not delete anything merely because cleanup was suggested.

Relay cleanup does not imply deleting project branches, requested prototype
archives, or running previews. Do not create a final-summary file by default.
