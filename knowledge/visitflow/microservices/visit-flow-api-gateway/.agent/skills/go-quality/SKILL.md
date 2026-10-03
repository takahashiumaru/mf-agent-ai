---
name: go-quality
description: "Write, modify, review, or refactor Go code in this repository, especially interfaces, errors, context propagation, concurrency, packages, or dependency structure."
---

# Go Quality

## Required Workflow

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

Before editing:

1. Read `AGENTS.md`, `.agent/INDEX.md`, and the relevant module/tests.
2. Trace callers, interfaces, and side effects.
3. Inspect 1-3 sound nearby implementations.
4. Identify compatibility, context, error, concurrency, and test risks.
5. Plan the smallest safe change.

When the user requests planning/review first, stop after the plan and wait. Otherwise proceed after sufficient analysis.

## Decision Priority

Correctness and data integrity outrank style, performance, and consistency with legacy code. Best practice is guidance, not permission for unrelated refactoring.

Prefer simple over clever, explicit over magical, readable over compressed, and composition over unnecessary abstraction.

## Repository Boundaries

- Keep HTTP parsing in `controller/`, business orchestration in `service/`, persistence in `repository/`, and DTOs in `model/web`.
- Use explicit constructor injection as in `route/users_route.go`.
- Do not add a DI framework, generic repository, `BaseService`, or abstraction without a concrete need.
- Existing combined domain/GORM models are ACCEPTABLE; do not create a parallel model layer for a focused change.

## Errors

- Never ignore meaningful errors.
- Prefer explicit error returns for new APIs; expected application errors must not use panic as normal control flow.
- Preserve identity with `errors.Is`/`errors.As`; wrap with `fmt.Errorf("operation: %w", err)` when useful.
- Log a failure once at the boundary that can act on it.
- Preserve current HTTP mapping when compatibility requires the legacy panic boundary.

LEGACY — `helper.PanicIfError` across services/repositories. Migrate only when all affected interfaces, callers, mocks, and tests are in scope.

## Context

- New request-bound functions should accept `context.Context` first.
- Start with `c.Request.Context()` and pass it to database, HTTP, and external I/O.
- Do not replace request context with `context.Background()` or store it in long-lived structs.
- Derive timeouts only when justified and always cancel them.

MIGRATE-WHEN-TOUCHED — service interfaces that accept `*gin.Context` and plain user/session GORM calls without `WithContext`.

## Interfaces and Dependencies

- Create small consumer-oriented interfaces only at real abstraction/test boundaries.
- Do not create `IUserService`-style duplicates merely because a struct exists.
- Avoid new mutable package globals.
- Before changing an interface, update every implementation and handwritten mock under `test/`.

DANGEROUS — the mutable global DB in `auth/auth.go`; do not copy it.

## Functions, Values, and Collections

- Prefer focused functions, early returns, shallow nesting, and business-meaningful names.
- Do not split straightforward code into meaningless helpers.
- Use values for required small scalars; pointers require mutation, size, nil semantics, or compatibility justification.
- Preserve empty-slice JSON behavior where API contracts expect `[]`.
- Avoid per-item database calls; collect and batch when semantics permit.

## Concurrency

Before adding a goroutine, prove useful independent work exists. Define owner, cancellation, boundedness, error propagation, and synchronization. Run `go test -race` for relevant changes.

ACCEPTABLE — the two bounded independent structure reads in `UserServiceImpl.VerifyPassword`.

LEGACY/DANGEROUS — detached notification goroutines and inconsistently locked IP-blocker maps. Do not reproduce these designs.

## Formatting and Performance

- Run `gofmt`; use repository lint/goimports tooling when available.
- Do not claim performance improvement without a benchmark/profile for meaningful runtime work.
- Prefer readable code when measured differences are irrelevant.

## Review Gate

- Dependency direction preserved.
- Errors and context reviewed.
- No unjustified interface/global/goroutine.
- Behavior protected by focused tests.
- No unrelated refactor.

For more detail, read `../../GO_BEST_PRACTICES.md`, `../../CODE_STYLE.md`, and `../../CODE_QUALITY.md` only when the task needs it.
