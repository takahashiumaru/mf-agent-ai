---
name: safe-refactoring
description: "Safely clean up, modernize, optimize, or refactor legacy Go/GORM code without expanding a focused task into an architecture or schema rewrite."
---

# Safe Refactoring

Use with `go-quality`; add `gorm-quality` and `mysql-performance` for persistence logic.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Principle

Leave affected code slightly better without turning a small task into a repository rewrite. Best practice is guidance, not permission for blind refactoring.

## Before Refactoring

1. State current behavior and the behavior that must remain unchanged.
2. Inspect tests, callers, interfaces, models/schema, transaction boundaries, and API contracts.
3. Identify the PREFERRED replacement and why it adds measurable value.
4. Classify affected code: PREFERRED, ACCEPTABLE, LEGACY, MIGRATE-WHEN-TOUCHED, or DANGEROUS.
5. Add/strengthen regression tests for risky behavior.
6. Plan small reversible steps.

When the user asks for a plan/review first, stop after the plan and wait.

## Improve When Touched

Safe local improvements can include:

- checking an ignored error;
- propagating context on the changed path;
- simplifying relevant control flow/naming;
- replacing unsafe zero-value GORM updates;
- retaining discarded GORM chain results;
- removing a directly relevant N+1/repeated query;
- narrowing a full-row query projection;
- removing relevant dead code or unused transaction starts;
- adding regression/rollback/security tests;
- removing unnecessary abstraction in the touched path.

Make the improvement only when it is local, low risk, behavior-preserving, and testable.

## Do Not Expand Scope Casually

Do not introduce:

- architecture/package rewrites;
- framework/GORM replacement;
- package-wide moves;
- generic repository, `BaseRepository`, or `BaseService`;
- CQRS, event sourcing, DDD restructuring, or microservice splitting;
- repository-wide interface redesign;
- unrelated schema/API changes;
- new dependencies for a problem the standard library/current stack solves.

If improvement requires broad API changes, large migrations, many unrelated callers, or business behavior decisions, document technical debt and continue with the smallest safe compatible change.

## Repository Migration Targets

MIGRATE-WHEN-TOUCHED:

- panic-based recoverable errors toward explicit returns;
- Gin context in services toward `context.Context`;
- plain DB calls toward `WithContext`;
- required scalar pointer IDs toward values;
- full user rows toward explicit projections;
- raw sort/search toward allowlists and bound values;
- oversized authentication methods toward cohesive testable steps.

DANGEROUS — prioritize only when in scope:

- root/global DB inside transactions;
- paired resolver transactions with an unfinished sibling;
- discarded chain results;
- unsynchronized shared maps;
- sensitive logging or CI secret output;
- role enforcement assumptions that do not match current code.

## Verification

- Run focused tests before/after when feasible.
- Preserve status/JSON/error/not-found behavior unless intentionally changed.
- Verify transaction rollback and query count/shape for DB refactors.
- Use benchmarks/plans for claimed performance improvements.
- Review diff for unrelated churn and public interface changes.

Read `../../CODE_QUALITY.md`, `../../ARCHITECTURE.md`, and `../../WORKFLOWS.md` when planning broader refactors.
