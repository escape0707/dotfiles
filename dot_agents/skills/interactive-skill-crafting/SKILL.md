---
name: interactive-skill-crafting
description: Use when the user wants to create or update a SKILL.md collaboratively through an explicit hunk-by-hunk decision process.
---

# Interactive Skill Crafting

Collaboratively create or revise a skill or cohesive set of related skills
through small, user-approved content hunks. Keep decisions in the conversation,
not repository tracking documents. Do not edit targets during the decision pass.

## Prepare

1. Establish each skill's name, purpose, target path, and whether it is new or
   existing. For related skills, establish their responsibilities and handoffs.
2. Read each existing target's complete `SKILL.md` before proposing changes.
3. Inventory the user’s approved decisions, unresolved choices, and constraints.
4. Present a concise ordered hunk map using `Hunk N of M`. Use that label as the
   progress indicator without adding a duplicate progress summary. If later
   discussion changes the map, state what was added, removed, or regrouped
   instead of silently changing `M`.
5. Keep revisions concise and targeted. Appending exact approved wording is
   appropriate when it adds a distinct instruction without overlap.

## Decide Hunk by Hunk

1. Propose one cohesive content hunk at a time with its target section.
2. Use diff format for modifications and a Markdown block for pure additions or
   removals. Explain prose as prose.
3. State what the hunk adds, replaces, or deliberately leaves out.
4. Wait for approval. Revise the same hunk after questions or objections before
   moving on.
5. Do not edit the target while the decision pass is active.
6. If the user asks to skip ahead, present the complete candidate for one final
   approval.

## Assemble Faithfully

1. After the content decision pass, ask whether to retain the approved wording
   as targeted edits or prepare a fused revision, unless the user has already
   specified their preference.
2. Assemble only approved content. Preserve approved wording by default; limit
   routine integration to headings, numbering, and grammatical continuity.
3. If fusion is requested, integrate the changes into existing sections and
   remove overlap. Present the revised wording for approval before editing.
4. Audit the result for contradiction, duplication, stale wording, and scope
   creep, then show the complete diff for final approval.

## Install and Verify

1. Respect the target’s configuration manager. For a chezmoi-managed skill, edit
   its source file, apply only the approved targets, and verify each match.
2. Validate the frontmatter, skill name and directory, Markdown, and clean diff.
3. Commit and push after final approval or explicit delivery authorization,
   respecting review holds and the repository's normal workflow.
