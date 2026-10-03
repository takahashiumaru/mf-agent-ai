# Code Quality

This reference classifies maintainability and legacy risk. Mandatory rules live in `../AGENTS.md`; the authoritative completion checklist is `QUALITY_GATES.md`; commands/facilities are in `TESTING.md`. Treat examples as scoped illustrations.


## Primary Goals

Every changed line should improve or preserve:

- correctness and business invariants;
- readability and explicit ownership;
- maintainability and compatibility;
- testability through injected dependencies;
- observability without secret leakage;
- database/transaction safety;
- query efficiency without speculative optimization.

The goal is not theoretical purity. The goal is the smallest safe improvement that fits this backend.

## Mandatory Implementation Order

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

Do not optimize blindly. Validate suspected slow queries with structure, indexes, realistic data characteristics, and preferably execution plans.

## Do Not Over-Engineer

Do not introduce these without a demonstrated need:

- generic/base repository or service layers;
- an interface for every struct;
- reflection-heavy mapping/filter frameworks;
- generic utility dumping grounds;
- CQRS, event sourcing, or a DDD rewrite;
- dependency-injection frameworks replacing straightforward route constructors;
- a separate persistence-model architecture during an unrelated feature;
- design patterns that add more indirection than behavior.

The current manual constructor wiring and layer-specific interfaces are sufficient for ordinary features and tests.

## Pattern Classification

Use these labels during reviews:

- **PREFERRED:** safe, clear, tested repository pattern for new code.
- **ACCEPTABLE:** correct in context, though another choice may be equally good.
- **LEGACY:** retained for compatibility; do not copy into new code.
- **MIGRATE-WHEN-TOUCHED:** improve locally when the affected behavior is already being changed and tests can protect it.
- **DANGEROUS:** correctness/security/resource risk; do not introduce, and fix in scope when safely possible.

## Repository Pattern Matrix

### PREFERRED

- Thin controller and explicit constructor flow in `route/office_route.go` and `controller/office_controller_impl.go`.
- Context-bound, service-owned transaction with one passed `tx` in `service/office_service_impl.go`.
- Explicit ID-scoped partial update and reload in `repository/leave_repository_impl.go`.
- UTC boundary/range predicates in `repository/presence_repository_impl.go`, protected by `test/presence_repository_coverage_test.go`.
- Chunked conflict-aware leave-quota insertion in `repository/leave_quota_repository_impl.go`.
- Repository SQL tests using MySQL GORM + `go-sqlmock` in `test/repository_mock_db_test.go` and repository coverage tests.
- Controller contract tests with injected Testify mocks, e.g. `test/office_controller_coverage_test.go`.
- Bounded detached notifications via `helper.RunAsyncNotification` when post-request async delivery is acceptable.

### ACCEPTABLE

- Domain structs as GORM models and explicit `ToXResponse` methods: not pure layering, but established and understandable.
- Targeted association `Joins` for list/single reads.
- Offset pagination for bounded administrative lists.
- Panic compatibility at the current HTTP boundary while interfaces cannot return errors.

### LEGACY compatibility

- Recoverable errors propagated exclusively through panic (`helper.PanicIfError`).
- Passing `*gin.Context` through services instead of standard context at lower layers.
- Pointer IDs and pointer-to-map filter signatures without nil semantics.

Retain these when a narrow change must preserve an existing interface. Do not use them in a new lower-level API.

### MIGRATE-WHEN-TOUCHED

- Opening transactions for read-only office-user lookup methods.
- `service.DB.Begin()` without request context.
- File/CSV parsing and other slow work after opening a transaction.
- One insert per CSV row.
- Unbounded CRUD list queries.
- Function-wrapped indexed date predicates instead of ranges.
- Creating repository dependencies inside helpers rather than injecting them.
- Raw goroutines capturing request context instead of bounded detached work.

### DANGEROUS

- Ignored `Exec`/GORM errors.
- Request-derived sort identifiers used without allowlisting, or search values interpolated instead of parameter-bound, by the shared pagination helper.
- Using read-replica transaction results to decide source writes that must be atomic.
- Constant `9999` count results from `CalculateTotalPages` treated as real totals.
- Unassigned GORM chain calls whose clauses may be lost.
- Concurrent unsynchronized logger file rotation/writes.
- `Unscoped` deletion without an explicit hard-delete requirement.
- `Save` on partial/incompletely loaded models.
- Database/network calls in large or unbounded loops without reviewing whether batching can preserve behavior.

## Working with Legacy Code

- Preserve externally observable behavior unless change is explicit.
- Characterize behavior with a focused test before risky cleanup.
- Improve only the touched seam when safe; do not launch a repository-wide rewrite.
- Separate mechanical cleanup from business/query behavior changes where practical.
- Do not use “consistency” to spread a bad pattern.
- If a compatibility constraint blocks the ideal pattern, document it in code/review and choose the safest local option.

## Review Checklist

### Behavior and architecture

- Is the requirement clear and covered by the correct layer?
- Does the controller only parse/respond?
- Does the service own validation, business rules, and transaction scope?
- Does the repository own GORM/SQL?
- Are dependencies explicit and direction preserved?
- Are company/user/structure authorization filters preserved?

### Go correctness

- Are all meaningful errors handled exactly once?
- Is error identity preserved with `%w` where required?
- Is context propagated to DB/network operations?
- Are goroutines bounded, cancellable, race-safe, and observable?
- Are nil pointers, empty slices, bounds, and zero values handled?
- Is control flow readable without unnecessary abstraction/nesting?
- Are secrets and personal data excluded from logs?

### GORM and transactions

- Is every operation using the supplied context-bound `tx`?
- Is the owner/boundary explicit and short?
- Can a replica read be stale relative to a write?
- Does `Updates(struct)` unintentionally skip zero values?
- Should `RowsAffected` be checked?
- Is not-found distinct from DB failure where required?
- Is hard/soft delete behavior intentional?
- Are all GORM/commit/rollback errors checked?

### Query performance

- Is the query selective and tenant-scoped?
- Are relevant deployed indexes present and correctly ordered?
- Is a function/cast defeating an index?
- Are only needed columns/relations loaded?
- Was N+1 or a DB call inside a loop introduced?
- Is pagination bounded and sorting allowlisted/deterministic?
- Can joins multiply rows/counts?
- Would batch/set-based work reduce load safely?
- Does a high-impact change require `EXPLAIN` evidence?

### Tests

- Is there a regression test for changed behavior?
- Are transaction begin/commit/rollback expectations covered where relevant?
- Do SQL tests assert important predicates, joins, and arguments rather than brittle irrelevant formatting?
- Are zero-value update, not-found, duplicate, and concurrent-state cases considered?
- Are unrelated tests untouched?

## Testing Strategy

- Controller/API contract: Gin recorder plus an injected mock service (`test/office_controller_coverage_test.go`).
- Service/business behavior: handwritten Testify mocks and sqlmock transaction expectations (`test/leave_service_safe_updates_coverage_test.go`).
- Repository query behavior: MySQL dialector over sqlmock (`test/repository_mock_db_test.go`, `test/presence_repository_coverage_test.go`).
- Domain mapping: direct value assertions in `model/domain/*_test.go`.

For query optimization, a sqlmock test proves SQL shape, not real performance. Add safe execution-plan or integration evidence when performance is the reason for the change.

## Definition of Done

For modified Go/GORM code:

- code is `gofmt`-formatted;
- affected tests pass;
- broader tests pass when practical;
- business behavior is preserved unless intentionally changed;
- meaningful errors are handled;
- context propagation is correct;
- transaction atomicity and source/replica choice are correct;
- update/delete semantics are explicit;
- query shape, relationships, pagination, sorting, and indexes were reviewed;
- no obvious N+1 or unbounded query was introduced;
- no unrelated refactor or dependency was introduced;
- logs contain useful IDs but no secrets.

Run repository-configured checks when available:

- `go test ./...`
- `go vet ./...`
- `make lint` / `golangci-lint run ./...`
- `make static` / `staticcheck ./...`

The Makefile configures tests, formatting, lint, staticcheck, and gocritic. Do not claim a check passed unless it was actually run successfully in the current environment.
