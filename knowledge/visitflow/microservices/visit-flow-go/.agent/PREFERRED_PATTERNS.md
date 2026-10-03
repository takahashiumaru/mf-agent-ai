# Preferred Patterns

For new code, follow this document. For legacy code, preserve behavior and migrate toward these patterns only when safely touched.

## Required Workflow

Before implementation:

1. understand required behavior and API compatibility;
2. trace controller -> service -> repository -> database/response;
3. inspect two or more relevant implementations, including a sound recent pattern;
4. identify tenant, status, audit, transaction, and zero-value rules;
5. inspect tests and mocks;
6. review query/index/cardinality risk;
7. implement the smallest safe change;
8. verify with focused and broader tests.

## Layering and Dependencies — PREFERRED

```text
route wiring -> controller -> service -> repository -> GORM
```

- Controller: parse/validate transport shape, call one service operation, build HTTP response.
- Service: business validation, authorization/tenant decisions, orchestration, transaction ownership, DTO mapping.
- Repository: persistence only—queries, scans, batches, and database errors.
- Route: explicit constructor wiring and auth wrapper.

Use `route/company_route.go` and its controller/service/repository chain for wiring and layer layout only; apply the example boundaries below. Inject dependencies through constructors. Do not construct a new repository implementation inside a service method.

## Context — PREFERRED

- Preserve request cancellation through database and network calls.
- Existing interfaces use `*gin.Context`; derive/pass `c.Request.Context()` when calling standard-context APIs.
- New lower-level APIs should accept `context.Context` first when they are not constrained by existing interfaces.
- Never store context in service/repository structs or use `context.Background()` in a synchronous request flow.

## Errors — PREFERRED

- Return explicit errors from new internal functions.
- Wrap operation context with `%w`; classify using `errors.Is`/`errors.As`.
- Expected absence and business rejection are ordinary errors/results, not panics.
- Log once at the final owning boundary with safe identifiers.

Compatibility rule: if the existing public call chain relies on `PanicIfError`, retain it at the outer compatibility boundary. Do not create a half-migrated chain that breaks rollback or middleware mapping.

## Transactions — PREFERRED

- Service owns one transaction for one atomic business operation.
- Repositories reuse the passed transaction; never reach for the base DB.
- Use the same `tx.Write` transaction for reads that must observe previous uncommitted writes.
- Begin immediately before transactional DB work and finish as soon as possible.
- Perform avoidable file/network/CPU work outside the transaction.
- Preserve the triggering error if rollback also fails.
- No nested transaction or manual mid-flow commit without a documented invariant and tests.

The current resolver helper has unresolved read-transaction lifecycle behavior. Do not generalize it into new infrastructure.

## GORM Reads — PREFERRED

- `First`/`Take` for a required single row; handle `gorm.ErrRecordNotFound` with `errors.Is` in explicit-error code.
- `Find` for collections where zero rows is an empty result.
- Apply company/structure/ownership/period and soft-delete scope.
- Use bounded pagination for growing public lists.
- Select only materially needed columns on wide/hot queries.
- Check `Error`; use `RowsAffected` when existence/change is part of correctness.

## GORM Writes — PREFERRED

### Create

- Build a deliberate persistence model; do not persist an arbitrary request graph.
- Check `.Error`, then use generated ID.
- Use `CreateInBatches` for large homogeneous work and check its result.

### Partial update

- Represent optional update fields with pointers.
- Build a server-allowlisted `map[string]interface{}` or use `Select(...).Updates(...)`.
- Use `Update` for one explicit field.
- Check `RowsAffected` for conditional/ownership-scoped transitions.

`repository/visit_repository_impl.go` (`UpdateApproved`) is the established explicit-map example.

### Delete

- Decide whether the business operation is soft delete, hard delete, or status transition.
- Populate deletion audit fields consistently.
- Use `Unscoped` only for a verified destructive/rebuild requirement with selective scope.

### Upsert and batch

- Use explicit conflict keys and assignment columns.
- Confirm a matching unique index exists in the real schema.
- Deduplicate input and chunk large batches/`IN` lists.

## Relations and Query Shape — PREFERRED

- Use a small `Preload` for a needed declared association; select child columns when helpful (`repository/visit_product_repository_impl.go`).
- Use `Joins` for filtering, aggregation, or flat projections; guard against duplicate root rows/counts.
- Use batch lookup plus maps when joining/preloading would overfetch. Preferred examples:
  - `service/html_service_service_impl.go` batches customer addresses;
  - `service/structure_service_impl.go` batches cluster/priority data.
- Treat a query call inside a loop as an N+1 warning.

## Raw SQL — PREFERRED

- Keep raw SQL/stored procedure calls in repositories.
- Bind all values with placeholders.
- Keep table/column/order identifiers server-controlled.
- Use projection structs with explicit column aliases.
- Verify cross-schema availability and result mapping.
- Use `EXPLAIN` for slow/high-impact queries; do not optimize from intuition alone.

## Business Rules — PREFERRED

- Keep status/config/approval decisions in services.
- Reuse exact shared constants when they represent the same rule.
- Preserve database-configured approval sequences; do not replace them with a hard-coded state machine.
- Keep tenant and checkpoint checks next to the operation they protect.
- Extract duplicated policy only after variants are proven semantically identical.

## Functions and Testability — PREFERRED

- Separate pure validation/calculation/mapping from database orchestration.
- Use early returns and descriptive names.
- Prefer small consumer-focused interfaces.
- Pass time, file, network, or notification dependencies when deterministic testing needs control; do not create a framework for one call.
- Add regression tests for success, invalid input, absence, tenant/permission scope, zero-value updates, rollback, and batch behavior as relevant.

## Collections and Concurrency — PREFERRED

- Preallocate when size is known and significant.
- Deduplicate keys before batch queries.
- Return initialized empty slices when the API contract expects `[]`.
- Add goroutines only with explicit ownership, cancellation/timeout, bounded concurrency, and error behavior.
- Never retain Gin context after handler return.

## Avoid in New Code

- panic for expected business/database outcomes;
- hidden concrete dependencies;
- generic base repositories/services;
- `Save` for partial updates;
- `Updates(struct)` when zero values matter;
- unbounded public list queries;
- blind `Preload(clause.Associations)`;
- query/write calls per item when batching is equivalent;
- arbitrary client sort/filter SQL;
- `Unscoped` without explicit destructive intent;
- fire-and-forget side effects presented as reliable delivery;
- large architecture rewrites for local problems.

## Example boundaries

| Example | Safe lesson | Do not copy blindly |
| --- | --- | --- |
| `route/company_route.go` | Explicit dependency wiring | Route role lists do not establish active authorization |
| Company controller/service/repository chain | Layer layout and existing API contracts | Service opens legacy read/write transactions; repository Update reloads via `db.Read` after writing through `db.Write`. Dependent response reads must use the writer transaction |
| `VisitRepository.UpdateApproved` | Explicit field map for partial updates | Recheck tenant/status conditions, affected rows, and current callers |
| `visit_product` preload | Declared association loading | Recheck selected columns, relation cardinality, and query count |
| `test/test_db_helper_test.go` | SQL mock setup | Same Read/Write handle cannot prove replica separation or transaction visibility |

An example endorses the listed technique only. Existing behavior and known defects must be distinguished from the design intended for new code.
