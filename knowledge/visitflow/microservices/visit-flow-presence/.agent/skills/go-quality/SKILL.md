---
name: go-quality
description: Use when writing, modifying, reviewing, or refactoring Go code, especially interfaces, errors, context propagation, concurrency, or dependency structure.
---

# Go Quality

## Core Principle

Prefer simple, explicit, testable Go that preserves this repository's dependency direction. Correctness and compatibility outrank stylistic cleanup.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Before editing, trace the affected route, controller, service, repository, models, callers, and tests. Inspect one to three nearby good examples; do not scan the whole repository.

## Repository Pattern Classification

- **PREFERRED:** the compact vertical slice in `route/office_route.go`, `controller/office_controller_impl.go`, `service/office_service_impl.go`, and `repository/office_repository_impl.go`.
- **PREFERRED:** request-bound DB usage such as `service/office_service_impl.go`. Existing signatures pass Gin context to `WithContext`; for a new API that accepts `context.Context`, pass `c.Request.Context()` at the boundary rather than widening Gin dependencies downward.
- **ACCEPTABLE:** manual constructor wiring in `route/`; do not add a DI framework for ordinary work.
- **MIGRATE-WHEN-TOUCHED:** pointer-to-scalar IDs and pointer-to-map filters used across service/repository interfaces. Improve only when callers can be changed safely.
- **LEGACY:** panic-based recoverable error propagation through `helper.PanicIfError`. Preserve boundary compatibility unless the task explicitly changes error architecture; do not spread it into reusable lower-level helpers.
- **DANGEROUS:** raw goroutines capturing request state in `service/attendance_correction_service_impl.go` and `service/meeting_service_impl.go`.

## Rules

- Keep Gin parsing and response construction in `controller/`, business rules and orchestration in `service/`, and persistence in `repository/`.
- Prefer early returns, focused functions, limited nesting, and names that describe business intent.
- Add an interface only at a real boundary or when the existing layer requires it. Do not create `IUserService`, generic repositories, or base services by habit.
- Inject dependencies explicitly. Do not add mutable package globals.
- Preserve error identity with `fmt.Errorf("...: %w", err)` when callers use `errors.Is` or `errors.As`; never silently discard meaningful errors.
- Log an error once at the layer that can add useful context or convert it to the HTTP response. Do not log secrets or duplicate the same failure at every layer.
- Propagate the request context into DB, HTTP, and external I/O. Do not replace it with `context.Background()` inside a synchronous request flow or store it on long-lived structs.
- Use pointers when mutation, size, or meaningful `nil` requires them; otherwise prefer values. Follow existing DTO optionality when API compatibility matters.
- Avoid dumping unrelated helpers into `helper/`; add code to the cohesive owning package.

## Concurrency Gate

Before adding a goroutine, prove the benefit and define ownership, cancellation, bounded concurrency, error/panic handling, shared-state synchronization, and shutdown behavior. Prefer `helper.RunAsyncNotification` for existing bounded notification work, while checking that it runs only after the relevant commit.

## Completion Gate

- Run `gofmt`/repository formatting on changed Go files.
- Run affected tests, then broader tests in proportion to risk.
- Review context, error identity, dependency direction, and goroutine lifetime.
- Do not claim runtime improvement without benchmarks or profiles when measurement is practical.

Read `.agent/CODE_STYLE.md`, `.agent/ERROR_HANDLING.md`, and `.agent/GO_BEST_PRACTICES.md` for established details.
