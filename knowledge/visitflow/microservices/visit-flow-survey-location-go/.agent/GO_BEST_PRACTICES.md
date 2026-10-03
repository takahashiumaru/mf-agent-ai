# Go Best Practices

These rules combine repository compatibility with idiomatic Go. They govern new and modified code; they do not authorize broad rewrites of legacy modules.

## Required Pre-Implementation Check

Before writing or modifying Go/GORM code:

1. understand the required behavior;
2. inspect the affected data flow;
3. inspect the nearest preferred repository pattern;
4. check Go correctness;
5. check GORM correctness;
6. check transaction correctness;
7. check database/query performance;
8. check relevant indexes;
9. check tests;
10. implement the smallest safe change.

Do not optimize blindly. For suspected slow queries, gather evidence from query shape, indexes, and preferably execution plans before a major optimization.

## Pattern Classification

- **PREFERRED:** use for new code.
- **ACCEPTABLE:** compatible and safe in its current context, but not universally ideal.
- **LEGACY:** preserve when required; do not copy into new code.
- **MIGRATE-WHEN-TOUCHED:** improve locally when tests and scope make it safe.
- **DANGEROUS:** requires explicit justification and focused verification.

## General Principles

- Prefer simple, explicit code over clever control flow or reflection.
- Keep functions focused around one business operation; extract named helpers when a branch or calculation can be tested independently.
- Keep ownership clear: controllers translate HTTP, services own business orchestration, repositories own persistence.
- Prefer early returns for validation and error cases over deep nesting.
- Minimize side effects and make them visible at the service boundary.
- Prefer composition and explicit dependencies over generic base layers.
- Preserve behavior and compatibility before local cleanup.


## Error Handling

### Preferred for new/refactored boundaries

- Return meaningful errors explicitly.
- Wrap with `fmt.Errorf("operation: %w", err)` when callers need context and error identity.
- Use `errors.Is`/`errors.As` for classification; preserve the wrapped cause.
- Treat expected not-found and business validation as ordinary outcomes, not process panics.
- Log an error once at the layer that has request/business context or owns final handling.

### Repository compatibility

The dominant code calls `helper.PanicIfError`, and recovery middleware translates panics to HTTP responses. This is **LEGACY/MIGRATE-WHEN-TOUCHED**, not the preferred design for new abstractions. Do not replace it in one method if callers, deferred rollback, and middleware still depend on panic propagation. A safe migration must change the entire affected call chain and tests together.

Introduce an explicit-error repository contract only when the task can update its interface, implementation, service/controller callers, transaction rollback path, mocks, and error-mapping tests as one coherent change. Otherwise retain compatibility and isolate the legacy behavior.

Never ignore an error merely because surrounding legacy code does. In particular, check results from GORM, `CreateInBatches`, file operations, JSON parsing, commits, and external calls.

## Context

- Propagate the request context into database and network work.
Repository methods accept service-selected `*gorm.DB`. Use the writer transaction for dependent reads; inspect current service/helper context handling before claiming established propagation.
- Use `c.Request.Context()` when an API accepts standard context.
- Do not introduce `context.Background()` inside synchronous request flows; it discards cancellation and deadlines.
- Do not store context in long-lived structs.
- Detached goroutines need an explicit lifetime, timeout, and data copy. Do not retain a Gin context after the handler returns.


## Interfaces and Dependency Injection

- Keep existing controller/service/repository interfaces where they are an active boundary and support handwritten mocks.
- Prefer small interfaces defined around actual consumer needs.
- Do not introduce an interface merely because a struct exists.
- Avoid `BaseRepository`, `BaseService`, or generic CRUD abstractions; module behavior and query rules differ materially.
- Avoid hidden mutable package globals.

## Functions and Control Flow

- Use descriptive domain names, even when existing historical names contain spelling inconsistencies.
- Break apart functions when doing so exposes independent validation, mapping, calculation, or persistence steps.
- Do not extract one-line helpers that hide straightforward behavior.
- Avoid `else` after a terminating return when an early return is clearer.
- Avoid changing a large legacy service solely to satisfy an arbitrary line limit.
- Keep transaction orchestration visible; do not hide commits or database selection in generic helpers without a repository-wide design.

## Structs, Values, and Pointers

- Use values for small immutable DTOs and results when absence is not meaningful.
- Use pointers when mutation is intended, nil distinguishes “not provided,” or the established interface requires one.
- For update DTOs, pointer fields are preferred when explicit zero/false/empty differs from omission.
- Do not use pointer-to-scalar parameters mechanically for every ID in new internal APIs; preserve them only where compatibility requires it.
- Never reuse a partially populated GORM model as a full replacement without understanding zero-value behavior.

## Collections and Allocation

- Return initialized empty response slices when the JSON contract expects `[]`, matching existing `To...Responses` mappers.
- Do not micro-optimize small collections without evidence.

## Concurrency

- Do not add goroutines merely to reduce apparent request latency.
- Every goroutine must have an owner, termination condition, bounded work, cancellation/timeout policy, and error handling.
- Do not capture mutable request objects or Gin contexts beyond request lifetime.
- Avoid unbounded goroutine creation in loops; use a bounded worker strategy only when justified.
- Run race-sensitive changes with `go test -race` where practical.
- Fire-and-forget FCM goroutines in visit/location services are **LEGACY**. New reliable delivery should use an established durable mechanism; none is present in this repository, so do not invent one in a focused change.

## Package Design

- Keep new code in the existing feature/layer packages unless a cohesive new package has a clear owner.
- Do not turn `helper/` into a dumping ground. A helper should be broadly reusable, stateless where practical, and free of hidden domain rules.
- Avoid circular dependency workarounds and reflection-heavy generic helpers.
- Do not introduce CQRS, event sourcing, DDD rewrites, or new architecture for theoretical purity.

## Naming and Comments

- Follow Go initialism conventions in new private names (`ID`, `URL`, `HTTP`) without renaming public legacy symbols incidentally.
- Comments should explain why a rule, query, timezone conversion, hard delete, or exception exists.
- Do not comment obvious assignments or restate function names.

## Logging

- Use the installed request/error middleware for request-level logging.
- Include safe identifiers such as operation, record ID, company/structure, and period when useful.
- Never log JWTs, DSNs, credentials, API keys, uploaded document contents, or full sensitive payloads.
- Avoid logging the same error in repository, service, controller, and middleware.
- Preserve stack/error visibility for failures while returning safe client messages.

## Preferred New-Code Rule

Choose in this order:

1. a sound **PREFERRED** repository pattern;
2. idiomatic Go behavior compatible with the current interfaces;
3. the smallest compatibility accommodation required by legacy callers.

Do not copy a poor legacy pattern only because it already exists.
