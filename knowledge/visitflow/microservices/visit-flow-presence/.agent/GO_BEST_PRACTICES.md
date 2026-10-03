# Go Best Practices

These rules apply when writing, reviewing, refactoring, or optimizing Go in this repository. Existing behavior and public contracts still matter, but an unsafe legacy pattern is not a template for new code.

## Mandatory Pre-Change Checklist

Before writing or modifying Go/GORM code:

1. Understand the required behavior.
2. Inspect the affected data flow.
3. Inspect the existing preferred repository pattern.
4. Check Go correctness.
5. Check GORM correctness.
6. Check transaction correctness.
7. Check database/query performance.
8. Check relevant indexes.
9. Check tests.
10. Implement the smallest safe change.

Do not optimize blindly. For a suspected slow query, gather evidence from its structure, indexes, frequency, row counts, and preferably an execution plan before a major rewrite.

## General Principles

- Prefer simple, explicit code over clever helpers or hidden side effects.
- Keep ownership clear: controllers parse/respond, services enforce business behavior and coordinate transactions, repositories execute database operations.
- Keep functions focused enough that error, transaction, and side-effect paths are visible. Do not split code merely to meet an arbitrary line count.
- Prefer early returns and named intermediate values over deep nesting.
- Minimize side effects and make external I/O visible at the call site.
- Write code that can be tested with constructor-injected repositories/services, as demonstrated by `route/office_route.go` and `test/office_controller_coverage_test.go`.
- Prefer composition and direct constructors over new frameworks or base types.

The compact preferred data flow is `route/office_route.go` → `controller/office_controller_impl.go` → `service/office_service_impl.go` → `repository/office_repository_impl.go`.

## Error Handling

### Preferred for new lower-level code

- Return meaningful errors explicitly from parsing, calculation, network, and reusable helper functions.
- Wrap with `fmt.Errorf("context: %w", err)` when callers may need `errors.Is` or `errors.As`.
- Handle an error once at the layer that can add context or decide policy; do not log the same error in every layer.
- Never discard meaningful errors from GORM, file operations, HTTP bodies, row iteration, transaction begin/commit/rollback, JSON, or CSV parsing.
- Use typed/sentinel errors for stable programmatic decisions; do not make new behavior depend on driver error strings.

### Current compatibility boundary

The current HTTP stack uses `helper.PanicIfError` and global recovery in `app/router.go`/`exception/error_handler.go`. This is **LEGACY but compatibility-sensitive**: many service/repository interfaces do not return errors, and tests expect panics. Do not mix a partial error-return redesign into a small feature.

When touching existing flows:

- Preserve the current external behavior unless an error-handling migration is the task.
- Prefer returning errors inside newly extracted helpers, then translate once at the existing service/controller boundary.
- Preserve `errors.Is` identity for authentication sentinels and the concrete `*exception.ErrorSendToResponse` type where the mapper uses type assertions.
- Do not panic for a newly designed recoverable business condition if the whole affected interface can safely return an error; otherwise use the existing business-error boundary consistently and test it.

Exact-string matching for `record not found` and MySQL duplicate/FK errors in `exception/error_handler.go` is **MIGRATE-WHEN-TOUCHED**, not a pattern to extend.

## `context.Context`

- Propagate the request context into database and network calls.
- New non-Gin lower-level functions should normally take `context.Context` as their first parameter.
- Existing service interfaces take `*gin.Context` last; follow that signature when extending the same interface, but do not spread Gin into new domain/repository-independent helpers.
- Prefer `db.WithContext(c.Request.Context())` at Gin boundaries. Existing services also pass `*gin.Context` directly to `WithContext`; retain that only for local compatibility, not as the model for new lower-level APIs.
- Never store a context permanently on a service/repository struct.
- Do not use `context.Background()` inside synchronous request flows.
- Detached work must have an explicit lifetime and timeout. `helper.RunAsyncNotification` is preferable to the older raw goroutines because it creates a 15-second timeout and recovers panics.
- Respect cancellation in HTTP clients and long-running loops. Stop work when the context is done when practical.

`service/attendance_correction_service_impl.go` contains an older `service.DB.Begin()` without context; this is **LEGACY**. New transaction code should follow the context-bound pattern in `service/office_service_impl.go`.

## Interfaces and Dependency Injection

- Keep the existing service/repository interfaces where they provide route-layer injection and test seams.
- Add methods to the smallest relevant interface. Update implementations, route wiring, and handwritten mocks together.
- Do not create an interface merely because a concrete struct exists.
- Do not add `BaseRepository`, `BaseService`, or generic CRUD interfaces; domain repositories have materially different queries and transaction needs.
- Prefer explicit constructor injection. Route functions already inject repositories, DB, validator, and services.
- Avoid package globals and hidden service locators. Creating a repository ad hoc inside a helper, as `getOfficeUser` does in `service/presence_service_impl.go`, is **MIGRATE-WHEN-TOUCHED** because it weakens testability and dependency visibility.

## Functions and Control Flow

- Validate inputs before opening a transaction or performing expensive I/O when behavior permits.
- Keep transaction orchestration readable: begin, check error, defer finalization, perform only transaction-scoped work.
- Extract repeated business calculations only when the extracted function has a clear name and contract.
- Avoid boolean arguments with unclear meaning; prefer named methods or small option types only when the call sites benefit.
- Check slice/map bounds before indexing. `repository/meeting_repository_impl.go` reads `recursiveResults[0]` without checking length; do not copy this hidden-panic pattern.
- Avoid shadowing important values such as `err`, `tx`, dates, or IDs when it obscures which value is used.

## Structs, Values, and Pointers

- Use values for small immutable inputs/results when zero value is valid and copying is cheap.
- Use pointers when mutation is intended, nil is meaningful, the object is large, or an existing interface requires it.
- Keep pointer DTO fields for optional/patch semantics; they distinguish omitted from explicit zero.
- Avoid new pointer-to-scalar parameters such as `*int` when a plain `int` communicates the contract. Existing repository/service signatures use many pointer IDs; preserve them only for compatibility.
- Avoid pointer-to-map and pointer-to-slice unless mutation/replacement semantics genuinely require it. Existing `*map[string]string` filter APIs are compatibility patterns, not preferred new API design.
- GORM create/update methods commonly need model pointers so IDs/timestamps can be populated.

## Collections and Allocation

- API list converters intentionally return initialized empty slices so JSON is `[]`, not `null`; preserve that external behavior.
- Preallocate when the final size is known or bounded and the code is on a meaningful path, as with CSV rows or batch mappings.
- Avoid repeated append/reallocation or repeated linear scans on large collections. Build a map keyed by ID/date when merging datasets.
- Nested scans over external and ERP presence records in `service/presence_service_impl.go` are **MIGRATE-WHEN-TOUCHED** for large inputs; preserve behavior but consider keyed maps after adding tests.

## Concurrency

- Do not add a goroutine without a clear owner, cancellation policy, error path, and concurrency bound.
- Never capture `*gin.Context` for use after the request returns. Pass the required immutable values and a bounded standard context instead.
- Do not launch notifications before a transaction commits when delivery must describe committed state. Prefer scheduling after successful commit or a durable outbox if reliability becomes a requirement.
- Avoid unbounded fan-out in loops; use bounded workers only with demonstrated need.
- Run `go test -race ./...` when changing shared state or goroutines.
- `helper/logger.go` uses unsynchronized global file state and asynchronous writes; it is **DANGEROUS**. Do not copy that pattern. If logger concurrency is in scope, serialize ownership or protect rotation/writes with synchronization and run race tests.

## Package Design

- Keep packages cohesive around their present roles.
- Do not turn `helper/` into a dumping ground. New helpers need a clear, reusable responsibility; domain-specific behavior belongs in its domain service/repository.
- Avoid circular-dependency workarounds, reflection-heavy utilities, and new abstraction layers used only once.
- Domain models currently depend on web DTOs for `ToXResponse`; this is established architecture. Do not perform a broad layering rewrite during a feature.

## Naming

- Follow idiomatic Go initialisms (`ID`, `URL`, `HTTP`) in new identifiers where compatibility allows.
- Use descriptive names: `tx`, `readDB`, and `writeDB` should reflect actual ownership.
- Keep existing public/database spellings such as `qouta` when changing them would break routes/tables/interfaces; do not introduce that spelling into unrelated new concepts.
- Avoid capitalized local variables and vague names such as `data`, `value`, or `result` when a domain name is available.

## Logging and Observability

- Use the existing structured request metadata: user ID, user name, endpoint, method, status, latency, and trace ID (`helper/logger.go`).
- Log once at the boundary that owns recovery/retry/operation outcome.
- Include stable identifiers and operation names, not full payloads.
- Never log JWTs, DSNs, Firebase tokens, credentials, file contents, or personal data unnecessarily.
- Do not claim GORM query collection is present unless the active logger/plugin actually populates it.

## Comments

- Explain why a business rule, timezone conversion, index hint, or unusual transaction choice exists.
- Do not narrate obvious assignments or stale copied comments.
- Keep compatibility warnings close to fragile status strings, table names, or SQL only when they add information tests cannot express.

## New Code Rule

Choose patterns in this order:

1. **PREFERRED repository pattern** that is safe and tested.
2. Idiomatic Go that fits the current architecture.
3. Compatibility constraint required by existing APIs/data.

Do not copy a poor legacy pattern merely because it already exists. Improve locally when safe, preserve behavior, and add focused tests.
