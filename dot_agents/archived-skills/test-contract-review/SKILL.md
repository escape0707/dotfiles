---
name: test-contract-review
description: Use when creating, migrating, repairing, or reviewing tests requires reconstructing an unclear behavioral contract, selecting an honest test boundary, or reconciling weak legacy tests with incomplete or conflicting production evidence.
---

# Test Contract Review

Determine the behavioral claim a test can honestly make before preserving legacy
assertions, replacing doubles, or changing production code.

## Responsibility

This skill owns test-specific contract reconstruction, vertical scope, boundary
selection, collaborator realism, observation strategy, and coverage accounting.

Use it when contract evidence is ambiguous or contradictory. Routine test work
with an already settled contract and boundary does not require this workflow.

It does not approve unresolved product semantics, control interactive pacing,
explain implementation diffs, or own framework-specific setup and delivery.
Use `interactive-decision-review` for material choices and
`quote-explain-hunk` for post-implementation diff review.

## Reconstruct the Contract

1. State the provisional claim in behavioral terms: owner, preconditions, input,
   observable outcome, relevant side effects, and forbidden effects.
2. Inspect the strongest available evidence:
   - Public or internal documentation and schemas.
   - Domain types, invariants, and persisted constraints.
   - Callers, consumers, and boundary adapters.
   - Error behavior and recovery paths.
   - Issue, incident, and change history.
   - Current production implementation and served behavior.
   - Existing tests, fixtures, doubles, and assertions.
3. Record absent evidence instead of assuming it exists. Classify inspected
   behavior as intended contract, compatibility constraint, incidental
   implementation detail, contradiction, or unknown.
4. Treat existing tests and production code as evidence, not automatic design
   authority. A passing test proves only what its setup and assertions exercise;
   deployed behavior constrains compatibility but does not prove that every
   implementation detail is intentional.
5. Treat type-checker failures as evidence of a test, fixture, double,
   annotation, or production contract mismatch. Inspect runtime behavior and
   callers, then correct the responsible side instead of suppressing the
   diagnostic or weakening the type.
6. When sources disagree, quote the contradiction and identify the decision
   required to resolve it. Do not silently make the test match current code,
   legacy mocks, or the easiest available fixture.
7. Before designing the test, state the bounded contract it will prove, the
   behavior it must reject or leave untouched, and every material point it will
   not claim.

## Bound a Vertical Semantic Slice

1. Select one cohesive business behavior, service operation, or domain
   responsibility whose contract can be traced end to end.
2. Follow the behavior through its entry point, owning policy or orchestration,
   collaborators, state boundary, returned result, errors, and side effects.
   Identify which layer owns each decision instead of assigning the whole
   contract to the file currently under test.
3. Inventory every existing test and exercised path within the selected
   behavior. Account for happy paths, errors, early exits, persistence,
   cleanup, and forbidden collaborator access rather than reviewing only changed
   lines.
4. Separate semantic corrections from mechanical transformations. A repeated
   mock replacement, fixture conversion, typing cleanup, or session-injection
   pattern is mechanical only after contract and boundary equivalence are
   established for each consumer.
5. Prefer completing one slice’s contract and test design before repeating a
   technique across unrelated services. Reuse a pattern in another slice only
   after verifying that its owner, lifecycle, and behavioral claim match.
6. Keep unrelated production redesign and adjacent cleanup outside the slice.
   When the test exposes a material production defect or boundary change, review
   that correction separately before including it.

## Choose an Honest Test Boundary

1. Choose the narrowest boundary that exercises every semantic required by the
   claim. Base the choice on owned behavior, not the current test directory,
   constructor signature, fixture availability, or legacy use of mocks.
2. Distinguish behavior owned inside the boundary from external collaborator
   contracts:
   - Exercise an owned implementation for semantics the test claims to prove,
     including persistence, serialization, transaction, or adapter behavior.
   - Use a small fake for decisions against an existing stable port. Test the
     real adapter or repository contract separately.
   - Use a mock or spy when the interaction itself is the contract, such as
     retries, ordering, notification, or an external call.
   - Use a failing sentinel or unbound dependency when collaborator access is
     forbidden and accidental use must fail visibly.
3. Do not mock the behavior under test or reproduce its implementation inside a
   fake. Do not introduce a repository, gateway, or other production abstraction
   solely to make the test easier to isolate.
4. Keep doubles contract-shaped. Prefer a typed fake that implements only the
   required port and records relevant interactions over a permissive untyped
   object. Use a spec-constrained mock when runtime signature enforcement is
   more valuable than static typing.
5. Select the observation boundary according to the claim:
   - Assert returned results directly for pure decisions and read operations.
   - Use an independent observer only to prove durability, rollback, cleanup,
     cross-context visibility, cache behavior, or lifecycle ownership.
   - Do not let the test commit, finalize, or repair work owned by production.
6. Keep arrangement and lifecycle transitions visible. Create separate
   transactions, sessions, processes, or workers only when their independence
   proves part of the contract.
7. State what the chosen infrastructure proves and does not prove. Do not claim
   production locking, isolation, concurrency, timing, or external-system
   behavior from a substitute that lacks those semantics.

## Assert and Reconcile Coverage

1. Make each test’s name, arrangement, act boundary, and assertions express one
   concrete behavioral claim.
2. Assert exact domain results and owned state transitions. Assert call shape,
   ordering, or count only when that interaction is itself part of the contract.
3. For errors and early exits, verify the exact result or exception contract and
   the absence of forbidden state changes or collaborator access.
4. For rollback, compensation, and cleanup claims, let production create the
   prerequisite real state before injecting the later failure. Do not make a
   cleanup test pass vacuously by mocking away the state that requires cleanup.
5. Use domain types, schemas, and deterministic values when they express the
   contract. Do not rely on loose dictionaries, incidental coercion, or opaque
   generated values for behavior under assertion.
6. Maintain a coverage ledger for every pre-existing case in the selected slice:
   preserved, strengthened, corrected, merged as equivalent, removed as
   vacuous or obsolete, or deferred with a stated limitation.
7. Remove or merge a test only after identifying where its distinct behavioral
   claim remains covered. Passing test count alone does not establish equivalent
   coverage.
8. When a valid test claim conflicts with production behavior, treat the
   production correction as a separate material decision. Do not weaken the
   assertion or change the public behavior solely to finish the test work.

## Complete and Hand Off

1. Reconcile the final tests against the bounded contract and coverage ledger.
2. Run the targeted behavioral tests plus applicable lint and type checks.
   Report exact commands, results, and checks delegated elsewhere.
3. Report the contract proved, evidence used, selected boundary and doubles,
   production changes, removed or deferred coverage, infrastructure limits, and
   remaining unknowns.
4. Describe the tests as executable evidence for their bounded claims, not as
   complete authority for the surrounding service or domain.
