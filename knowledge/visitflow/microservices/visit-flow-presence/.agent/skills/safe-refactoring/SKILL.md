---
name: safe-refactoring
description: Use when asked to refactor, clean up, modernize, optimize, or improve legacy Go, GORM, database, API, or infrastructure code.
---

# Safe Refactoring

## Core Principle

Leave affected code slightly better without turning a focused change into a repository rewrite. Best practice is guidance, not permission for blind refactoring.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Before editing, define current behavior, desired behavior, callers, interfaces, API/database compatibility, transaction boundaries, and tests that must remain unchanged.

## Pattern Classification

Use these labels with evidence:

- **PREFERRED:** copy for new code.
- **ACCEPTABLE:** valid; no migration required.
- **LEGACY:** keep for compatibility but do not copy.
- **MIGRATE-WHEN-TOUCHED:** improve locally when related code is already changing and tests can protect behavior.
- **DANGEROUS:** meaningful correctness, security, integrity, concurrency, or reliability risk; prioritize a scoped fix.

Repository examples:

- **PREFERRED:** compact office vertical slice and context-bound service/repository flow.
- **PREFERRED:** half-open date range in `repository/presence_repository_impl.go`.
- **MIGRATE-WHEN-TOUCHED:** broad `Updates(struct)`, pointer-to-pointer GORM calls, pointer IDs/maps, exact database-error strings, and read-only transactions.
- **LEGACY:** unbounded CRUD lists, function-wrapped date filters, one insert per CSV row, and raw service goroutines.
- **DANGEROUS:** disabled role enforcement, unsafe dynamic sort/search SQL, replica reads controlling writes, ignored GORM errors, and unsynchronized shared logger state.

## Safe Local Improvements

When behavior-preserving, low-risk, and testable, improve directly relevant code by:

- handling ignored errors and preserving context;
- making GORM update columns/zero values explicit;
- assigning chain-returning query methods;
- batching an N+1/repeated DB operation without changing semantics;
- simplifying control flow or relevant duplication;
- improving local naming and adding regression tests;
- removing dead code proven unused within the affected scope.

## Scope Boundaries

Do not casually introduce generic repositories, base services, DI frameworks, reflection-heavy helpers, global error rewrites, domain/persistence splits, CQRS, event sourcing, package-wide moves, framework replacement, or unrelated schema redesign.

If improvement requires broad API changes, large migrations, architecture changes, many unrelated callers, or business-policy decisions, document the debt and obtain direction rather than expanding scope silently.

## Completion Gate

- Behavior/API/transaction invariants remain covered.
- Callers, interfaces, mocks, and schema/query behavior were checked.
- Affected tests pass; risky fixes have regression coverage.
- No unrelated cleanup is mixed into the diff.
- Performance claims have evidence and security controls are not weakened.

Read `.agent/CODE_QUALITY.md`, `.agent/ARCHITECTURE.md`, and the task-specific skills before refactoring.
