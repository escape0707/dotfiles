---
name: triangular-fork-maintenance
description: Use when updating a triangular Git fork, rebasing private branches onto upstream, realigning dependent branches, or preparing focused upstream PR history.
---

# Triangular Fork Maintenance

Synchronize a fork where branches pull from `upstream` and push to `origin`.
Preserve private commits, signed history, branch purpose, and focused upstream
PR diffs throughout rebases and cleanup.

## Inspect the Topology

1. Require a clean worktree before rewriting history.
2. Confirm:
   - `origin` is the fork.
   - `upstream` fetches from the source repository and has a no-push URL.
   - `remote.pushDefault=origin` and `push.default=current`.
   - Local branches track their upstream integration base, not the fork branch.
3. Fetch and prune both remotes.
4. Inventory each branch’s purpose and dependency order. Record its old tip and
   base before mutation.
5. Check relevant PR states with `gh`; Git ancestry alone cannot detect every
   squash or rebase merge.

## Refresh in Dependency Order

1. Rebase the private local `main` stack onto current `upstream/main`.
2. Move its backup branch, such as `gh-runner`, exactly to the updated `main`.
3. Rebase tracker and other private dependent branches onto updated `main`.
4. Rebase child work onto its updated parent, dropping prerequisite patches
   already present upstream.
5. Start implementation branches from updated local `main`. Before an upstream
   PR, transplant only approved correction commits onto current
   `upstream/main`, excluding private configuration and tracker history.
6. Fetch upstream again before delivery and repeat affected steps if it moved.

## Handle Rebases Deliberately

- Inspect each conflict against the branch’s purpose; never resolve mechanically
  with blanket “ours” or “theirs”.
- Use `git -c core.editor=true rebase --continue`.
- Review skipped commits and confirm they are already represented upstream.
- Preserve intermediate work with new commits until its direction settles;
  rewrite only when explicitly approved or preparing final review history.
- Never use destructive reset or checkout commands to recover from uncertainty.

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

- Retain the private base, its intentional backup, active trackers, and open PR
  branches.
- Treat a feature branch as redundant only after confirming its PR is merged or
  closed and no unique work remains. For squash merges, combine PR state with
  patch or tree comparison instead of relying on `git branch --merged`.
- Show exact local and fork deletion candidates and obtain approval before
  deleting them.
- Record branch-tip SHAs before deletion so recovery remains possible.
