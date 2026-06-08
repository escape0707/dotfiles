---
name: backtrack-summary
description: Summarize the chain of problems, decisions, fixes, and remaining state that led a long thread to its current point. Use when the user asks to backtrack, recap how we got here, summarize the chain of problems, recover context after finishing a subtask, or explain the causal path across debugging, setup, CI, GitHub, environment, or code-investigation work.
---

# Backtrack Summary

## Goal

Produce a compact causal recap that helps the user return to earlier problems without rereading the whole thread.

## Workflow

1. Start from the current endpoint: what just got completed, verified, or left pending.
2. Walk backward through the thread and identify only the major pivots: original problem, failed hypotheses, decisive evidence, chosen fixes, environment/tooling blockers, and unresolved follow-ups.
3. Convert the pivots into a forward causal chain: "A led to B led to C".
4. Separate confirmed facts from judgments. Use phrases like "proved by", "verified with", or "likely because" when the confidence differs.
5. Preserve concrete anchors that make later backtracking efficient: file paths, commands, issue/PR numbers, branch names, CI run identifiers, exact versions, and test names.
6. Exclude routine tool chatter, repeated attempts that taught nothing new, and low-level logs unless they explain a turning point.

## Output Shape

Prefer a short numbered list for causal chains. Keep each item one sentence unless a second clause carries important evidence.

For very small threads, use one paragraph. For long investigations, use 6-12 numbered items plus a final "Current state" item if useful.

## Quality Bar

- Make the first item the true root problem, not the most recent subtask.
- Make the last item the present state and any known next action.
- Mention when a result was transient, flaky, sandbox-specific, or environment-specific.
- Do not overstate certainty. If the thread only suggests a cause, say that it suggests a cause.
- Do not turn the summary into a full timeline; group repeated attempts into the lesson they established.
