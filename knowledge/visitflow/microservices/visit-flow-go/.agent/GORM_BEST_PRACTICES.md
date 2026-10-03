# GORM Best Practices

Use this document for new/changed database code. See `GORM.md` for the repository's current mechanics and exceptions.

## Core Principle

Every query should retrieve and modify only the rows, columns, and relationships required for the operation. Correct tenant scope and transaction behavior take priority over convenience.

## Context

- Keep request cancellation on database calls.
- Existing services create a context-bound `DatabaseResolver`; repository methods must use its `Read`/`Write` handles.
- For a new standard-context API, call `db.WithContext(ctx)`.
- Do not switch to a base/global `*gorm.DB` inside an active operation.
- Do not introduce `context.Background()` to bypass cancellation.

## Error Handling and Results

- Always inspect `.Error` from GORM operations, including `Begin`, `Commit`, `Rollback`, batch writes, raw SQL, and counts.
- Use `errors.Is(err, gorm.ErrRecordNotFound)` in new explicit-error code.
- Decide whether absence means an empty result, a business not-found, or an HTTP mapping; do not treat all absence as infrastructure failure.
- When correctness requires proof that a row changed, inspect `RowsAffected`. This is especially important for conditional status transitions, ownership-scoped updates/deletes, and optimistic “update if current status” operations.
- Legacy panic propagation may be retained within an unchanged module, but new repository contracts should prefer explicit errors when the full call chain can support them.

## Read and Write Handles

- Use `db.Read` for ordinary reads and `db.Write` for mutations under the existing resolver architecture.
- If a read must see an earlier uncommitted write or make a decision atomically with later writes, run that read through the same `tx.Write` transaction. `db.Read` may use a separate transaction/replica and is not suitable for read-your-writes guarantees.
- After commit, replica-backed `db.Read` may still lag. Do not promise immediate consistency unless the endpoint deliberately reads from the source/write handle and that behavior is tested.
- Always include required `company_id`, structure/ownership, period, and soft-delete scope.

## Create

```go
result := db.Write.Create(item)
if result.Error != nil {
    return fmt.Errorf("create item: %w", result.Error)
}
```

Check generated IDs only after a successful create. Inspect model associations before passing populated object graphs: GORM may persist associations. Prefer a deliberately populated persistence struct rather than a request-derived graph.

Use `CreateInBatches` for large homogeneous inserts, with a bounded batch size verified for row width and database limits. `service/structure_service_impl.go` and recommendation repositories demonstrate batching.

## Partial Updates

`Updates(struct)` skips zero-value fields. This is unsafe when `0`, `false`, `""`, or null is an intended new value.

Preferred options:

1. pointer fields in an update DTO to distinguish omitted from explicitly supplied values;
2. build an allowlisted `map[string]interface{}` from provided fields;
3. use `Select("field_a", "field_b").Updates(model)` when the field set is fixed;
4. use `Update("column", value)` for a single explicit field.

`repository/visit_repository_impl.go` (`UpdateApproved`) is a useful map-update example. Conditional assignment maps in customer/location upserts are also preferred. Keep column names server-defined; never accept arbitrary field names from a client.

After an ownership/status-scoped update, check both `Error` and `RowsAffected` if “no matching row” must fail.

## `Save`

`Save` writes all fields and may persist stale/zero values that were not intended to change. Do not use it for a partial update.

`VisitCustomerRepository.Update` loads an existing row, applies fields, and then calls `Save`; classify this as **ACCEPTABLE only for that full-row workflow**. For new partial updates, prefer an explicit map or selected columns.

## Delete

- Ordinary `Delete` on models embedding `gorm.Model` is soft delete.
- Set `DeletedByID` consistently when the model uses audit fields.
- `Unscoped().Delete` is **DANGEROUS** and must be justified by a verified rebuild/cleanup rule, scoped with a selective predicate, and tested.
- A domain “delete” may be a status transition; confirm the business lifecycle before deleting rows.
- Check `RowsAffected` when deleting a missing or unauthorized row must be distinguishable.

## Transactions

- The service owns the business transaction; repositories receive and reuse its resolver.
- Keep all related writes on `tx.Write`; never call the base DB mid-transaction.
- Keep transaction scope short and deterministic.
- Avoid nested transactions and manual commits inside the standard deferred pattern.
- Do not commit a partial business operation merely to satisfy a foreign key; restructure write order when possible. The manual commit/restart patterns in location and visit-customer services are **LEGACY** and require local investigation.
- Return errors in new transaction APIs so rollback follows normal control flow. The repository's panic/recover rollback is a compatibility mechanism, not a new-code ideal.
- Do not perform slow file, network, template generation, or large CPU work inside a transaction unless correctness genuinely requires locks to remain held.
- Preserve the original business/database error if rollback also fails. Attach or log the rollback failure as secondary context; do not replace the cause that triggered rollback. If rollback is the only failure, return it.
- Do not automatically retry deadlocks, lock timeouts, or transient connection errors. Retry the whole transaction only when the operation is idempotent/replay-safe, attempts and backoff are bounded, and tests cover duplicate side effects.

The current `go-helper` begins separate read and write transactions and routinely finalizes only the write transaction. This is an unresolved legacy behavior; do not expand it into a new abstraction without verifying the helper/runtime semantics.

## Relation Loading

### Preload

- Preload only relations needed by the response/business rule.
- Select child columns when useful, as in `repository/visit_product_repository_impl.go`.
- Never add `Preload(clause.Associations)` to list endpoints without bounded cardinality and measured need.
- Remember that each preload can add queries, allocations, and payload size.

### Joins

- Prefer joins for filtering, aggregation, or flat projections.
- Select explicit projection columns for performance-sensitive endpoints.
- Check one-to-many joins for duplicate root rows and incorrect counts; use grouping/distinct only with verified semantics.
- Do not join tables whose columns/filters are unused.

### Separate batch lookup

Batch related IDs with one `IN` query and index results in a map when preload/join would distort the query. `service/html_service_service_impl.go` batch-fetches customer addresses and groups them in memory; `service/structure_service_impl.go` batch-fetches clusters/priorities. These are **PREFERRED** examples.

## N+1 Queries

Treat a repository/database call inside a loop as a review warning:

```text
for each item -> query relation
```

Prefer:

```text
collect unique IDs -> one bounded batch query -> map by ID -> process locally
```

Potential legacy N+1 sites include per-structure queries in `service/process_data_visit_service_impl.go`, per-member structure lookups in `service/visit_service_impl.go`, and customer-log reads/writes inside request-item loops in `service/customer_service_impl.go`. Verify actual cardinality and query traces before changing behavior.

## Select, Pagination, Count, and Sorting

- Avoid `SELECT *` for wide/high-volume list/report queries when only a subset is used.
- Do not add `Select` mechanically to low-volume CRUD; maintainability also matters.
- Public list endpoints should have a validated maximum limit. Existing pagination uses `Limit`, `Offset`, `Order`, search, and total calculation.
- Large offsets become increasingly expensive; for high-volume ordered data, investigate keyset pagination using a stable unique tie-breaker.
- Never pass an arbitrary client `Order` expression directly. Sort columns/directions must be allowlisted.
- Build count queries without pagination/order, and check join multiplication. Prefer `COUNT(DISTINCT root.id)` when that matches semantics.
- Avoid calculating the same count repeatedly in one request.

## Batch and Upsert

- Prefer set-based updates, `IN` queries, or `CreateInBatches` over one write per row.
- Bound batch sizes and avoid enormous `IN` lists; chunk when required.
- Reuse the existing `clause.OnConflict` pattern with explicit conflict columns and assignment columns.
- Conflict columns express business identity. Verify actual unique indexes before changing them.
- Check every batch/upsert error; one observed direct `CreateInBatches` call in `service/structure_service_impl.go` does not inspect its result and must not be copied.

## Raw SQL and Hooks

- Bind every value: `db.Raw("... WHERE id = ?", id)`.
- Never concatenate untrusted values into raw SQL, table names, columns, filters, or ordering.
- Fixed cross-schema identifiers still require deployment/permission review.
- Prefer GORM/query builders when they remain readable; raw SQL is appropriate for stored procedures and genuinely complex set-based reports.
- No actual GORM lifecycle hooks were found. Re-search for hooks before changing lifecycle behavior.

## Locking and Associations

- No `clause.Locking` convention exists. Add row locking only for a proven race/invariant, inside a short transaction, with deadlock/retry behavior considered.
- Avoid automatic association saves for large graphs. Persist explicit child batches when ownership and failure semantics need to be clear.

## Review Rule

Before approving a query, answer: expected cardinality, tenant scope, selected columns, relation strategy, relevant indexes, pagination bound, sorting cost, count semantics, transaction handle, and error/RowsAffected behavior.
