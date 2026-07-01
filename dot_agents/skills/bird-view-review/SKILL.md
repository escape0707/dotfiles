---
name: bird-view-review
description: Use when the user wants a fast bird's-eye review after implementation and before line-by-line or hunk-by-hunk review, especially to summarize endpoint-level technical choices, decision points, tradeoffs, or likely iteration items before spending time on strict diff review.
---

# Bird View Review

Use this skill for a quick decision-map pass over an implemented endpoint before detailed review.

## Goal

Surface the important technical choices while iteration is still cheap. Help the user decide what to keep, change, or defer before doing strict hunk-by-hunk review.

## Workflow

1. Treat the pass as review-only unless the user explicitly asks for edits.
2. Ground the review in the actual endpoint:
   - Inspect `git status --short --branch`.
   - Identify the intended comparison base from the user, branch history, or scaffold context.
   - Use `git diff --stat`, `git diff --name-status`, targeted `git diff`, and `rg` to understand the final tree.
   - Avoid summarizing unrelated upstream drift; prefer the branch merge-base or explicit scaffold base.
3. Produce a concise decision map, not a line review.
4. Focus on choices that can change the endpoint shape or review strategy before detailed review.
5. For each worthy point:
   - Quote the relevant code or diff snippet.
   - State the decision made.
   - Explain why it matters.
   - Give concrete alternatives when useful.
   - Recommend whether to keep, change in the next branch, or defer.
6. Proceed interactively when the user says `next`, `lgtm`, or challenges a point.
7. Keep a running mental ledger of accepted changes for the next revision, but do not edit until requested.
8. Stop once remaining points are only line-review details; then offer to switch to hunk-by-hunk review.

## Worth Surfacing

Surface these at bird-view level:

- Test contract choices, such as state assertions versus call/interaction assertions.
- Fixture and helper responsibility boundaries, especially hidden side effects.
- Broad endpoint changes outside tests, including production typing/API compromises.
- Data setup strategy, such as `flush()` versus `commit()`, generated data versus literals, or fixture-created DB state.
- Boundary realism choices, such as real DB rows versus mocks or stubs.
- Input-shape choices, such as using service-native DTO values versus relying on Pydantic coercion.
- Assertion scope, especially whole-table assertions versus target-scoped assertions.
- Whether old coverage was removed, relocated, broadened, or intentionally not preserved.
- Review-scaffold consequences only when they affect what the user must decide about the endpoint.

## Usually Skip

Do not spend bird-view attention on:

- Decisions already settled in the conversation.
- Pure scaffold-policy mechanics already dictated by a skill or instruction file.
- Required model filler values that do not affect the behavior under review.
- File placement or split decisions when the active workflow already mandates them.
- Tiny line-review nits unless they point to a repeated pattern worth fixing before hunk review.
- Generic praise or broad summaries that do not help the user make a decision.

## Response Shape

When starting the pass, give a compact map:

```text
I see these decision points before line review:
1. ...
2. ...
3. ...
```

Then discuss one point at a time. For each point, prefer:

````text
Decision point: <short name>

Quote:
```python
...
```

What I chose: ...
Why it matters: ...
Recommendation: ...
````

If the user says a point was already discussed or is not worthy, acknowledge it and move to the next real decision point.
