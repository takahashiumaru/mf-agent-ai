---
name: go-quality
description: Use when writing, modifying, reviewing, or refactoring Go code, especially interfaces, errors, context propagation, dependencies, or concurrency.
---

# Go Quality

## Outcome

Produce simple, idiomatic Go that preserves Visit Flow behavior and its existing layer boundaries. Best practice is guidance, not permission for broad cleanup.

## Before Editing

1. Read `../../../AGENTS.md`, then `../../INDEX.md`.
2. Read `../../GO_BEST_PRACTICES.md`, `../../CODE_STYLE.md`, and `../../PREFERRED_PATTERNS.md` as relevant.
3. Inspect the affected interface, implementation, callers, and tests.
4. Classify nearby patterns as PREFERRED, ACCEPTABLE, LEGACY, MIGRATE-WHEN-TOUCHED, or DANGEROUS.
5. Define behavior that must remain stable and choose the smallest safe change.

## Rules

- Prefer simple over clever, explicit over magical, and composition over unnecessary abstraction.
- Keep HTTP concerns in `controller/`, business rules in `service/`, and persistence in `repository/`.
- Preserve meaningful errors. Use `errors.Is`, `errors.As`, and `%w` when identity matters.
- This repository commonly uses `helper.PanicIfError`; preserve that boundary unless the task explicitly changes error architecture.
- Propagate the request context to database and external I/O. Do not replace it with `context.Background()` in request flows or store request contexts in long-lived structs.
- Add interfaces only at useful seams. Do not create `IThing` wrappers merely because a struct exists.
- Prefer focused functions, early returns, meaningful names, and limited nesting; do not fragment simple logic into trivial helpers.
- Keep dependencies explicit and avoid new mutable package globals.
- Do not create catch-all `utils`, `helpers`, or `common` packages for unrelated behavior.
- Before adding goroutines, prove value, bound concurrency, define ownership/cancellation, propagate errors, and prevent leaks and races.
- Use `gofmt`; use repository-supported tooling rather than introducing a new formatter casually.
- For meaningful runtime optimization, benchmark or profile before and after.

## Repository Examples

- PREFERRED: `../../../route/company_route.go` explicitly wires repository, service, and controller dependencies.
- LEGACY REFERENCE: `../../../service/company_service_impl.go` illustrates layer placement, not a new transaction template. Separate read-handle finalization is unresolved; Company Update reloads via a reader. Use `../../PREFERRED_PATTERNS.md#example-boundaries` and keep dependent reads in the writer transaction.
- PREFERRED: `../../../repository/visit_repository_impl.go` `UpdateApproved` uses an explicit update map where zero values matter.
- LEGACY — DO NOT COPY FOR NEW CODE: broad repository construction inside service methods; prefer injected dependencies when a focused change makes that safe.

## Verification

- Run targeted tests first, then affected packages and broader tests according to risk.
- Run `gofmt` on changed Go files and `go vet`/lint when relevant and available.
- For concurrency changes, consider `go test -race`.
- Confirm no new abstraction, package dependency, goroutine, or error translation is unjustified.

## Common Mistakes

- Replacing established panic-to-middleware error flow in only one layer.
- Adding an interface with one implementation and no consumer-owned seam.
- Using background context to make cancellation problems disappear.
- Claiming code is faster without a representative benchmark or profile.
- Expanding a local task into a repository-wide rewrite.
