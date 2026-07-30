---
name: interactive-skill-crafting
description: Use when the user wants to create or update a SKILL.md collaboratively through an explicit hunk-by-hunk decision process.
---

# Interactive Skill Crafting

Collaboratively create or revise one skill through small, user-approved content
hunks. Treat the conversation as the source of truth, and do not edit the target
file until the content decision pass is complete.

## Prepare

1. Confirm the skill’s name, purpose, target path, and whether it is new or
   existing.
2. When updating a skill, read its complete `SKILL.md` before proposing changes.
3. Inventory the user’s approved decisions, unresolved choices, and constraints.
4. Keep the resulting skill minimalist and concise. Prefer in-place revisions
   over appending overlapping instructions or explanations.

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

1. Assemble only approved content after the decision pass.
2. Preserve approved wording byte-for-byte when practical. Limit integration
   edits to headings, numbering, deduplication, and grammatical continuity.
3. Present any material integration change before editing.
4. Audit the result for contradiction, duplication, stale wording, and scope
   creep, then show the complete diff for final approval.

## Install and Verify

1. Respect the target’s configuration manager. For a chezmoi-managed skill, edit
   its source file, apply only that target, and verify source and target match.
2. Validate the frontmatter, skill name and directory, Markdown, and clean diff.
3. Commit and push only after final approval, following the repository’s normal
   workflow.
