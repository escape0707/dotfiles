---
name: deliver-in-steps
description: Only use this skill when user specificlly invoked it.
---

# Deliver In Steps

Use a review-gated workflow. Keep each implementation step small enough to review and, when appropriate, commit independently.

## Core Workflow

1. Break the work into small, reviewable, commit-sized steps.
2. For a large change or a new project, before editing code:
   - Restate the goal and the key constraints.
   - Inspect the relevant files.
   - Read the existing `PLAN.md`, or create it if it does not exist.
3. Propose the plan and get approval before implementation unless the user has explicitly chosen the fast route.
4. After each step:
   - Summarize which files changed and what changed.
   - Run the agreed validation, or give the exact command the user should run.
   - Pause for review.
5. If the user says `LGTM`, commit and continue to the next step.
6. If the user says `fast route`, keep the work structured but do not wait for confirmation between steps.

## PLAN.md

Use `PLAN.md` only when the task is large enough to benefit from explicit step tracking.

- Track progress with checkboxes.
- Update it after each commit-sized step.
- Keep it short and actionable.

## Practical Rules

- Default to the review-gated path when the user asks for planning, approval checkpoints, or careful iteration.
- Skip `PLAN.md` for genuinely small tasks.
- Keep updates concise and concrete so the user can approve or redirect quickly.
