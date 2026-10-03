# Code Quality

This reference classifies maintainability and legacy risk. Mandatory rules live in `../AGENTS.md`; the authoritative completion checklist is `QUALITY_GATES.md`; commands/facilities are in `TESTING.md`. Treat examples as scoped illustrations.


## Primary Goals

Every changed line should improve or preserve:

- correctness;
- readability;
- maintainability;
- testability;
- observability;
- database safety;
- query efficiency;
- compatibility with intentional API/domain behavior.

Quality is not measured by abstraction count. Prefer the smallest design that makes ownership and failure behavior clear.

## Mandatory Workflow

Before writing or modifying Go/GORM code:

1. Understand the required behavior.
2. Trace the affected data flow.
3. Inspect the preferred repository pattern nearest to the change.
4. Check Go correctness.
5. Check GORM correctness.
6. Check transaction correctness.
7. Check database/query performance.
8. Check relevant indexes.
9. Check tests and handwritten mocks.
10. Implement and verify the smallest safe change.

Do not optimize blindly. Use query structure, indexes, metrics, and preferably execution plans as evidence.

## Do Not Over-Engineer

Do not introduce these merely for theoretical purity:

- generic repositories or `BaseRepository`/`BaseService` types;
- an interface for every concrete struct;
- reflection-heavy mapping/filter/update frameworks;
- a second domain/persistence model layer for one field or endpoint;
- service locators or a DI framework;
- CQRS, event sourcing, or a DDD rewrite;
- generalized batching, caching, or concurrency before a real need exists;
- a new logging or error framework for a small change.

This repository is small and manually wired. Local improvements with tests are preferable to architectural replacement.

## Pattern Classification

Use these labels in reviews and plans.

### PREFERRED

- Controller/service/repository separation for local APIs.
- Explicit constructor injection in `route/`.
- Services owning atomic multi-repository operations.
- `DB.Transaction` callbacks for multi-write authentication flows.
- Repositories using the passed DB/transaction and bound SQL values.
- Explicit response DTO mapping.
- Set-based joins/CTEs instead of queries inside loops.
- Handwritten interface mocks plus sqlmock for transaction/query behavior.

### ACCEPTABLE

- Existing combined GORM/domain models.
- Existing layer interfaces where they provide a real test seam.
- Offset pagination for bounded, modest datasets.
- Raw SQL isolated in a repository for MySQL-specific hierarchy work.

### LEGACY

- Panic-driven recoverable error flow.
- Gin context coupled into service interfaces.
- Required scalar IDs passed by pointer.
- Unstructured/mixed logging and `fmt.Println` diagnostics.
- Full-row loads followed by narrow response mapping.
- Broad accumulation in `helper`.

### MIGRATE-WHEN-TOUCHED

- Add `context.Context` and `WithContext` when a repository/service signature is already in scope.
- Replace panic-only results with explicit errors when all callers and mocks can be updated safely.
- Extract cohesive steps from oversized authentication methods when adding related behavior.
- Replace raw request sorting/search construction with allowlists and bound values.
- Replace ambiguous zero-value struct updates with explicit update maps or selected columns.

### DANGEROUS

- Using a root/global DB inside a transaction.
- Copying the resolver pattern that opens both read/write transactions but completes only one.
- Ignoring the DB returned by chain methods such as `Where`.
- Raw SQL or `Order` built from untrusted request text.
- `Unscoped` deletion without an explicit hard-delete requirement.
- Unbounded list queries on potentially large tables.
- Goroutines without cancellation/lifecycle/error ownership.
- Unsynchronized shared mutable maps.
- Logging secrets or complete tokens.
- Enabling `AutoMigrate` in startup.

## Working with Legacy Code

Existing code is evidence of behavior, not automatic evidence of quality.

When touching legacy code:

- preserve externally required behavior unless the task explicitly changes it;
- improve the local path when the improvement is small and testable;
- do not broaden the refactor into unrelated modules;
- add a regression test before changing high-risk behavior;
- update every caller/mock when changing an interface;
- state compatibility constraints in code review or handoff.

If a safe local improvement would require a large interface migration, keep the focused change compatible and document the follow-up rather than partially applying two patterns.

## Repository-Specific Review Checklist

### Go and architecture

- Is HTTP parsing confined to controllers?
- Is business orchestration in a service rather than a controller/repository?
- Is persistence in a repository?
- Are dependencies explicit rather than global?
- Are functions focused with readable control flow?
- Are pointer parameters justified?
- Are new interfaces small and necessary?
- Are shared mutable values race-safe?
- Does every goroutine have bounded lifecycle and error handling?

### Errors and context

- Are meaningful errors checked?
- Is error identity preserved with `%w` where needed?
- Is the same failure logged only once?
- Is request context propagated to DB/network calls?
- Are cancellation/deadline errors allowed to propagate?
- Is panic avoided for recoverable new behavior?

### Transactions and GORM

- Is one layer clearly responsible for the transaction?
- Does every operation inside it use the supplied `tx`?
- Are errors returned from transaction callbacks?
- Are expensive external/CPU/file operations outside the transaction?
- Are zero, false, empty-string, and NULL updates handled intentionally?
- Is `Save` avoided for partial updates?
- Is soft versus hard delete intentional?
- Is `RowsAffected` checked when zero affected rows changes correctness?
- Are returned GORM chain handles retained?

### Query performance

- Does the query select only required columns?
- Is there a DB/repository call inside a loop?
- Could an association load create N+1 or an excessive payload?
- Is the result bounded with validated pagination?
- Are sort/filter columns allowlisted?
- Are relevant deployed indexes known?
- Can joins multiply root rows or make counts wrong?
- Is a count query necessary?
- Is a slow/high-frequency query backed by an execution plan?

### Security and compatibility

- Are SQL values bound rather than concatenated?
- Are secrets/tokens/passwords absent from logs and responses?
- Are authentication, ownership, soft-delete, and role semantics preserved?
- Are public JSON fields and status codes intentionally changed?
- Are database schema assumptions verified outside this repository when necessary?

### Tests

- Is there a regression test for changed behavior?
- Were handwritten mocks updated with interface changes?
- Do transaction tests verify commit/rollback where relevant?
- Do repository tests assert important predicates, not merely execute DryRun?
- Does the test cover zero-value updates and not-found behavior when relevant?

## Preferred Examples

- HTTP delegation and response envelope: `controller/role_controller_impl.go`.
- Manual dependency injection: `route/users_route.go`.
- Short atomic write transaction: login, logout, and refresh callbacks in `service/user_service_impl.go`.
- Correct affected-row check: `repository/session_repository_impl.go`.
- Explicit report projection and set-based joins: `repository/user_role_repository_impl.go` (retain returned filter chains when improving it).
- Parameterized recursive SQL: `repository/users_repository_impl.go`.
- Manual service mocks: `test/user_service_test.go`.
- Transaction/replay tests: `test/session_refresh_coverage_test.go`.

## Legacy Patterns Agents Must Not Copy

- `helper.PanicIfError` as the default error API for new code.
- Unused preliminary `Begin()` calls in role services.
- Paired resolver transactions where only one is completed.
- `helper.ApplyFilter` and `UserAccessReport` discarding returned GORM chains.
- Raw unvalidated `sort` passed to `Order` and interpolated search helpers.
- `users.*` or full `domain.User` loading when a small projection is sufficient.
- Process-global mutable DB/auth state.
- Fire-and-forget notification goroutines as the default async design.
- The IP blocker's inconsistently locked process-local maps.
- Placeholder/misleading parameter names copied between modules.

## Definition of Done

For modified Go code:

- code is `gofmt` formatted;
- affected-package tests pass;
- broader tests pass when practical;
- business behavior is preserved unless intentionally changed;
- meaningful errors are handled;
- context reaches database/network operations where the changed path supports it;
- transaction ownership and rollback behavior are correct;
- query shape, selected columns, bounds, N+1 risk, and indexes were reviewed;
- no unrelated refactor or new dependency was introduced;
- documentation is updated if a convention or public behavior changed.

Run repository-configured checks when available and relevant:

```text
go test ./...
go vet ./...
golangci-lint run ./...
staticcheck ./...
```

The Makefile exposes `make test`, `make fmt`, `make lint`, `make static`, and `make critic`. External tools may not be installed; report what actually ran rather than implying success.
