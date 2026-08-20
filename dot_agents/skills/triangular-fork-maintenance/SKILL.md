---
name: triangular-fork-maintenance
description: Use when maintaining a triangular Git fork, rebasing branches onto upstream, evaluating conflicts between overlapping branches or refactors, realigning dependent branches, or preparing focused upstream PR history.
---

# Triangular Fork Maintenance

Synchronize a fork where branches pull from `upstream` and push to `origin`.
Preserve private commits, signed history, branch purpose, and focused upstream
PR diffs throughout rebases and cleanup.

This skill owns Git topology, history transformation, conflict diagnosis, and
safe delivery. It does not decide unresolved application semantics merely to
complete a rebase. When a conflict exposes a material ownership, boundary, or
contract decision, use `interactive-decision-review` before resolving it.

## Inspect the Topology

1. Require a clean worktree before rewriting history.
2. Confirm:
   - `origin` is the fork.
   - `upstream` fetches from the source repository and has a no-push URL.
   - `remote.pushDefault=origin` and `push.default=current`.
   - Local branches track their upstream integration base, not the fork branch.
3. Fetch and prune both remotes.
4. Inventory each branch’s purpose, dependency order, old tip, and base before
   mutation.
5. Classify each relationship:
   - Independent branches share no prerequisite or semantic responsibility.
   - Dependent branches require an explicit parent and update in stack order.
   - Competing branches change the same responsibility or intended architecture
     and require intent reconciliation before rewriting history.
6. Compare commit ranges, changed paths, final diffs, affected call sites, and
   tests. Same-file edits signal possible collision but do not prove semantic
   conflict; different-file edits can still change the same contract or owner.
7. Check relevant PR states with `gh`; Git ancestry alone cannot detect every
   squash or rebase merge.

## Refresh in Dependency Order

1. Rebase the private integration branch or root of the local stack onto the
   current upstream base.
2. Move an intentional mirror or backup branch exactly to the updated tip only
   when its defined purpose is to remain an alias. Otherwise, treat it as a
   dependent branch with its own history.
3. Rebase dependent branches in topological order, each onto its updated parent.
4. Drop prerequisite patches already present upstream only after verifying
   semantic equivalence.
5. Start private work from the updated integration branch. Prepare an upstream
   PR branch from the current upstream base and transplant only its approved,
   reviewable commits, excluding private configuration and unrelated stack
   history.
6. Fetch upstream again before delivery and repeat affected steps if it moved.

## Evaluate and Resolve Conflicts

1. Inspect the current patch, original commit, upstream replacement, surrounding
   final code, callers, and tests. Conflict markers alone do not explain either
   branch’s intent.
2. Classify the semantic relationship:
   - Mechanical: location, rename, formatting, or context changed while the
     intended behavior remains compatible.
   - Equivalent or subsumed: upstream already implements the patch’s intent.
   - Complementary: both changes remain necessary in the final design.
   - Competing: the branches assign incompatible behavior, ownership, boundary,
     or contract semantics.
3. Resolve toward the intended final state. Do not select blanket “ours” or
   “theirs”, concatenate both implementations, or preserve obsolete structure
   solely to resemble the old patch.
4. For competing changes, invoke `interactive-decision-review` before choosing
   the final semantics. For equivalent changes, record the evidence before
   dropping or adapting the duplicate patch.
5. Inspect cleanly applied overlapping patches and skipped commits too. A rebase
   without conflict markers does not establish semantic compatibility.
6. Use `git rebase --show-current-patch` to identify the active change and
   `git -c core.editor=true rebase --continue` after resolving and staging it.
7. Preserve intermediate work with new commits until its direction settles;
   rewrite only when explicitly approved or preparing final review history.
8. Never use destructive reset or checkout commands to recover from uncertainty.

## Reduce Future Conflicts

1. Before concurrent branches grow, identify their semantic owners, explicit
   dependencies, shared seams, and intended final boundaries.
2. Represent a true prerequisite as an explicit branch stack. Keep independent
   branches based on upstream instead of copying prerequisite commits or
   developing accidental dependencies.
3. Keep each branch focused on one semantic responsibility. Isolate broad
   renames, formatting, generated churn, and other mechanical changes when they
   would obscure concurrent behavioral work.
4. When a prerequisite or competing branch merges, update promptly and
   re-evaluate the surviving branch against the new final code. Drop superseded
   work instead of replaying the old diff mechanically.
5. For a shared interface, model, repository, registry, or configuration seam,
   establish one owner or prerequisite change before multiple branches reshape
   it. Create a shared abstraction only when verified consumer semantics support
   it, not merely to avoid textual conflicts.

## Verify Before Pushing

1. Use `git range-diff` with the recorded old and new ranges to confirm patch
   equivalence.
2. Inspect `git diff upstream/main...<branch>` for the intended scope and absence
   of private scaffolding on upstream PR branches.
3. Verify every rewritten commit reports a good signature with `%G? = G`.
4. Run checks proportionate to conflict or code-change risk; a conflict-free
   metadata-only rebase does not require costly tests.
5. Confirm the worktree is clean and branch tracking still targets upstream.

## Push Safely

1. Fetch `origin` immediately before pushing so leases use current fork refs.
2. Push branches in dependency order with the simple form:

   ```shell
   git push --force-with-lease
   ```

3. Never use plain `--force` or construct a manual lease unless the user
   explicitly requests it.
4. Verify each local tip equals its corresponding `origin` tip after pushing.

## Clean Merged Branches

- Retain the private integration base, intentional mirrors or backups, active
  dependent branches, and open PR branches.
- Treat a feature branch as redundant only after confirming its PR is merged or
  closed and no unique work remains. For squash merges, combine PR state with
  patch or tree comparison instead of relying on `git branch --merged`.
- Show exact local and fork deletion candidates and obtain approval before
  deleting them.
- Record branch-tip SHAs before deletion so recovery remains possible.
