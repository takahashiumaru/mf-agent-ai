# Code Quality

This reference classifies maintainability and legacy risk. Mandatory rules live in `../AGENTS.md`; the authoritative completion checklist is `QUALITY_GATES.md`; commands/facilities are in `TESTING.md`. Treat examples as scoped illustrations.


## Primary Goals

Every change should improve or preserve:

- correctness and business invariants;
- readability and maintainability;
- testability;
- observability without secret exposure;
- database and transaction safety;
- query efficiency;
- compatibility with callers and clients.

The smallest coherent change is usually better than an opportunistic rewrite.

## Required Workflow

Before writing or modifying Go/GORM code:

1. understand the required behavior;
2. inspect the affected data flow;
3. inspect the existing preferred repository pattern;
4. check Go correctness;
5. check GORM correctness;
6. check transaction correctness;
7. check database/query performance;
8. check relevant indexes;
9. check tests;
10. implement the smallest safe change.

Do not optimize blindly. Require query/index/plan evidence before major performance work.

## Do Not Over-Engineer

Do not introduce these without a demonstrated problem that current patterns cannot solve:

- generic/base repositories or services;
- extra abstraction layers and one-implementation interfaces;
- reflection-heavy mapping/filter frameworks;
- global service locators;
- CQRS or event sourcing;
- DDD or Clean Architecture rewrites;
- premature caching/concurrency;
- generic helper packages with mixed responsibilities.

The current horizontal layered architecture has imperfections, but a feature or bug fix does not authorize redesigning it.

## Pattern Classification

### PREFERRED

- Controller request translation, service business logic, repository GORM ownership.
- DTO validation before writes.
- `CreateInBatches`/`OnConflict` with explicit business keys and checked errors.
- Parameterized raw SQL and allowlisted filters.
- Focused tests and handwritten mocks at current abstraction boundaries.

### ACCEPTABLE

- Existing layer interfaces even when broad, because route wiring/tests depend on them.
- Small unpaginated lookup lists when table size is demonstrably bounded.
- `Save` after loading and deliberately modifying a complete row.
- Simple `SELECT *` for small single-row CRUD when it improves maintainability and cost is immaterial.

### LEGACY

- Panic-based recoverable error propagation.
- Services accepting/storing Gin-specific context contracts deep in business code.
- Concrete repository construction inside service methods.
- Fire-and-forget goroutines that capture request context.
- Manual transaction commits/restarts inside normal service flows.
- Repository methods returning HTTP-layer projections and services writing Gin responses.
- Repeated query/write calls inside input/data loops.

Preserve legacy behavior when required, but do not copy it into a new module.

### MIGRATE-WHEN-TOUCHED

- Oversized service functions mixing validation, queries, file work, calculation, notifications, and mapping.
- Unbounded list queries on tables whose cardinality may grow.
- Wide join projections using `alias.*`.
- Long batch/template processing inside transactions.
- Exact-string not-found/error classification.
- Inconsistent pointer-to-scalar and naming conventions.

Local improvement requires regression tests and must not expand into an unrelated refactor.

### DANGEROUS

- `Unscoped()` hard deletes.
- User-controlled SQL identifiers/order fragments.
- Ignored GORM/batch/commit errors.
- Cross-tenant queries without company/structure/period scope.
- Base-DB operations inside an active transaction.
- Remote calls while locks/transactions are held.
- Unbounded goroutines or goroutines using Gin context after handler return.
- Enabling `AutoMigrate` without the production schema process.
- Exposing secrets or copying existing embedded credentials.

## Review Checklist

### Behavior and architecture

- Is the requested behavior explicit, and are existing clients preserved?
- Is logic in the correct controller/service/repository layer?
- Were all interface callers, route constructors, and mocks updated?
- Did the change avoid a broad unrelated cleanup?
- Are status transitions, tenant scope, timezone behavior, and audit fields preserved?

### Go correctness

- Are meaningful errors checked and identity preserved?
- Is context propagated and cancellation retained?
- Are nil pointers, empty inputs, zero values, and bounds handled?
- Are functions readable with controlled nesting and side effects?
- Does concurrency have ownership, bounds, cancellation, and error handling?
- Is mutable data protected from races?

### GORM/database correctness

- Is the correct read/write/transaction handle used?
- Do reads that depend on earlier writes use the same `tx.Write` transaction?
- Does a partial update correctly persist zero/false/empty/null?
- Are not-found and `RowsAffected` semantics correct?
- Is delete soft, hard, or a status transition as intended?
- Are raw SQL values bound and identifiers trusted?
- Were hooks/associations/upsert conflict keys checked?

### Performance

- Is there a query/database call inside a loop?
- Could preload/join/batch lookup avoid N+1 without overfetching?
- Are selected columns, joins, counts, and sorting necessary?
- Is list pagination bounded?
- Do verified indexes support high-impact predicates/order?
- Is the transaction short and free of avoidable I/O/CPU work?
- Is optimization based on `EXPLAIN` or measured evidence?

### Security and observability

- Are company, structure, subordinate, period, ownership, and checkpoint rules enforced?
- Are sort/filter fields allowlisted?
- Are errors/logs useful without leaking tokens, credentials, or payloads?
- Does error logging occur once at the owning layer?

### Tests

- Is there a regression test for changed behavior?
- Are success, validation, absence, authorization/tenant, zero-value, and error paths covered where relevant?
- Were mocks updated rather than bypassed?
- Was the affected package run before the full suite?

## Testing and Verification

Use repository commands according to risk and availability:

```sh
go test ./path/to/affected/package
go test ./...
go test -race ./path/to/affected/package
go vet ./...
golangci-lint run ./...
staticcheck ./...
```

The configured Makefile exposes `make test`, `make fmt`, `make lint`, and `make static`. Do not claim a check passed unless it was actually run successfully. Do not run `go mod tidy` merely as validation because it can modify module files.

Database-sensitive changes need more than unit tests when practical: verify generated SQL, expected `RowsAffected`, transaction rollback, soft-delete scope, and representative MySQL behavior. Stored procedures/raw cross-schema queries require a safe compatible environment.

## Definition of Done

For modified Go code:

- code is `gofmt` formatted;
- affected tests pass, followed by the broader suite when practical;
- intentional behavior changes are documented and tested;
- meaningful errors are handled;
- context and transaction behavior are correct;
- tenant/authorization constraints remain intact;
- query shape and relevant indexes were reviewed;
- no obvious N+1, unbounded query, or unsafe update was introduced;
- no secret, generated artifact, debug binary, or unrelated refactor was added;
- documentation is updated when a repository convention changes.

## Review Outcome Language

When reporting a finding, state:

1. the concrete behavior/risk;
2. the evidence path;
3. the failure mode or cost;
4. the smallest safe correction;
5. the verification required.

Avoid style-only recommendations presented as correctness requirements.
