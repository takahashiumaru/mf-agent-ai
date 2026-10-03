# GORM Best Practices

Use this with `.agent/GORM.md`, which describes current behavior. This document defines what future changes should prefer and which existing patterns are legacy.

## Required Review Sequence

Before changing a GORM path, trace controller → service → repository → model/table, then verify context, transaction handle, update semantics, relation loading, query shape, indexes, and tests. Implement the smallest safe change; do not optimize without evidence.

## Context

- Every request-scoped query should use a context-bound DB.
- **PREFERRED for new code:** derive `service.DB.WithContext(c.Request.Context())` at the Gin boundary and pass that handle into repositories. Existing services often use `service.DB.WithContext(c)` (`service/office_service_impl.go`); preserve it for a narrow compatible change, but prefer the standard request context in new lower-level APIs.
- Repositories should use the DB handle they receive; they must not reopen or reach for a base/global DB.
- `service.DB.Begin()` without `WithContext`, present in `service/attendance_correction_service_impl.go`, is **LEGACY**.
- Do not lose cancellation when switching between base DB, read resolver, and transaction handles.

## Error Handling and Not Found

- Inspect `.Error` for every `Create`, query, update, delete, raw SQL, scan, begin, commit, and rollback.
- `repository/leave_quota_repository_impl.go` has standalone `db.Exec(...)` calls whose results are ignored; this is **DANGEROUS** and must not be copied.
- Decide not-found semantics at the repository/service contract:
  - Required record: propagate `gorm.ErrRecordNotFound` through the current error boundary.
  - Optional lookup: check `errors.Is(err, gorm.ErrRecordNotFound)` and return an explicit absence representation.
- `LeaveQuotaRepository.Validate` deliberately treats not-found as absence. This is an **ACCEPTABLE compatibility pattern**, though a `(value, found, error)`-style API would be clearer in a future interface migration.
- Do not compare newly introduced errors by text. Preserve `%w` wrapping when identity matters.

## Create

- Pass a model pointer to `Create`, check `.Error`, and use the same pointer when generated IDs/timestamps are needed.
- Do not pass `&modelPointer` (pointer-to-pointer) unless there is a proven reason. Existing `db.Create(&office)` forms where `office` is already a pointer are **MIGRATE-WHEN-TOUCHED**; prefer `db.Create(office)`.
- Understand that associations may be auto-created/saved depending on populated fields. Construct only the graph intended for persistence.
- For many rows, batch rather than issuing one insert per row.

`repository/leave_quota_repository_impl.go` is the preferred existing bulk example: chunks of 100 with `clause.OnConflict{DoNothing: true}`. Preserve its conflict semantics; do not silently turn “ignore duplicate” into update/replace.

## Partial Updates

GORM `Updates(struct)` normally omits zero values. This affects `0`, `false`, `""`, zero timestamps, and nil pointers.

Use the least ambiguous option:

1. Pointer fields in patch DTO/domain values when nil means “not supplied”.
2. `map[string]interface{}{...}` for an explicit set of columns including zero/null.
3. `Select("column_a", "column_b").Updates(model)` when a typed struct is useful and the column set is explicit.
4. `Update("column", value)` for one explicit column.

For non-zero sparse updates, the current `repository/leave_repository_impl.go` pattern—`Model`, explicit `Where("id = ?", ...)`, `Updates`, then reload—is **PREFERRED within this repository**. Add `RowsAffected` checks when “ID did not exist” differs from success.

Do not assume a boolean/string/numeric zero was persisted. Add a regression test for zero-value updates.

## `Save`

Do not use `Save` for partial updates. It writes all fields, can overwrite data loaded incompletely or changed concurrently, and can create when the primary key is absent. `Save` is not an established pattern here. Use explicit updates.

## Delete

- Confirm whether the module expects GORM soft delete, hard delete, or a business status transition.
- Set audit fields in the same transaction when required.
- `Unscoped().Delete` is irreversible at the ORM level and must have an explicit requirement plus tests.
- This repository intentionally mixes soft and hard deletion; do not infer semantics from a neighboring module.
- Prefer status transitions over deletion when records are part of approvals/audit history and the existing domain requires preservation.

## Transactions

### Preferred local transaction

The service owns the boundary, starts a context-bound transaction, checks begin error, defers `helper.CommitOrRollback(tx)`, and passes the same `tx` to every repository call. See `service/office_service_impl.go`.

`helper.CommitOrRollback` recovers a panic, checks `Rollback().Error`, and re-panics; on a normal return it checks `Commit().Error`. It does not wrap transaction errors: a rollback failure panics before the original panic is restored, and a commit failure becomes the propagated panic. This is compatibility behavior, not ideal error preservation. Any future error-return transaction helper must be migrated end-to-end rather than mixed into one method.

Rules:

- Never use `service.DB` or another base handle after the transaction starts for operations that must be atomic.
- Keep the transaction short; parse/validate files and perform remote I/O outside it when correctness allows.
- Avoid nested transactions unless savepoint semantics are explicitly required and tested.
- Ensure every failure reaches rollback; in a future error-return API, prefer `db.Transaction(func(tx *gorm.DB) error { ... })`.
- Do not commit a partial multi-repository business operation.

### Read/write resolver warning

Complex flows use `goHelper.CreateTransaction`, returning separate `.Read` and `.Write` transactions (`service/leave_service_impl.go`, `service/attendance_correction_service_impl.go`, `service/meeting_service_impl.go`). The resolver API is **LEGACY** in this repository; using its replica `.Read` for a decision that controls `.Write` is **DANGEROUS**:

- `.Read` may use a replica and observe stale data.
- Read decisions and `.Write` mutations are not one atomic transaction.
- The local code defers finalization only for `.Write`; `.Read` lifecycle is not clearly closed here.

Decision rule:

- New local-only workflow: use one source/write transaction for every read that controls its writes.
- Existing external repository requires `DatabaseResolver`: pass the resolver only at that compatibility boundary; use `.Write` for local correctness-sensitive reads when its API permits.
- External API forces `.Read` for a correctness-sensitive decision: do not claim atomicity. Flag the limitation and coordinate a shared-interface change rather than hiding it.

Any migration needs focused integration tests and coordination with the shared module.

## Relations: `Preload` and `Joins`

- Load only relations required by the operation/response.
- `Joins("User")`/`Joins("LeaveCategory")` are the prevalent repository pattern for filtering/projecting related records (`repository/leave_repository_impl.go`).
- `Preload` is rare; `LeaveQuotaRepository.Validate` preloads only `LeaveCategory`.
- Do not use `Preload(clause.Associations)` on list/report queries. It hides extra queries, memory, and payload size.
- Use `Joins` when filtering/projecting across relations is the goal, but check duplicate parent rows for one-to-many relations.
- Use separate batched lookups when a join would multiply rows or create an unwieldy query.
- Always assign chain results (`tx = tx.Joins(...)`). GORM chain methods return a new `*gorm.DB`; ignoring it can drop the clause. The unassigned conditional join in `repository/leave_repository_impl.go` is **DANGEROUS**; fix it when that query is in scope and protect the expected join with a SQL test.

## N+1 Queries

Treat any repository/database call inside a loop as a review warning:

```text
for each item → query/create/update
```

Prefer, depending on semantics:

- one `IN ?` query and an in-memory map;
- a targeted `Preload`;
- a join/projection;
- `CreateInBatches`/slice `Create`;
- a set-based update.

Concrete hotspots:

- CSV assignment imports perform one `Create` per row in `service/office_user_service_impl.go` and `service/work_hour_user_service_impl.go` (**MIGRATE-WHEN-TOUCHED**; batch after preserving audit/conflict behavior).
- Leave creation performs validation/create/approval work per generated day in `service/leave_service_impl.go` (**review carefully before batching because each day has separate business state**).
- Presence reconciliation updates/creates inside a loop in `service/presence_service_impl.go` (**candidate for batching only after preserving per-record update semantics**).

## Column Selection

- Use `Select` for large/report queries when only a projection is needed; `repository/presence_repository_impl.go` and `repository/leave_repository_impl.go` already do this.
- Do not add `Select` mechanically to small point lookups.
- Avoid loading large text/blob columns and unused associations on hot list endpoints.
- Keep scan aliases aligned with `gorm:"column:..."` report structs.

## Pagination and Count

- List endpoints over growing tables must have a validated, bounded limit.
- Existing pagination uses external `goHelper.PaginationData` with `Limit`, `Offset`, and `OrderBy`.
- Validate/clamp page and limit at the boundary. In `gitlab.com/VNEU/go-helper/helper` v0.5.9, `GetPagination` copies the request's `sort` value into `OrderBy`, while `SearchCondition` interpolates the request's search value into SQL. This is **DANGEROUS**: allowlist sort identifiers/direction and bind search values as parameters. Fix affected endpoints with compatibility tests.
- Offset pagination is acceptable for modest administrative lists. For deep/high-volume pages, evaluate keyset pagination using a stable indexed key.
- Count the filtered base query, not a joined row-multiplied result. Use `Distinct(primary_key)` where needed.
- The external `go-helper` v0.5.9 implementation of `CalculateTotalPages`, inspected for this repository, returns constant `9999`; total counts produced through it are **LEGACY/INCORRECT**. Do not build new API behavior on that value.

## Batch Operations and Upsert

- Use slice `Create`, `CreateInBatches`, or explicit chunking for large inserts.
- Choose batch size using row width, MySQL packet limits, lock time, and measurement—not guesswork.
- Check the entire batch error and define whether partial success is acceptable.
- The only established upsert is `OnConflict{DoNothing:true}` for leave quotas. Do not invent update-on-conflict semantics without a business rule and unique-key analysis.

## Locking and Concurrent Updates

No `clause.Locking` use exists. Do not add locks routinely.

However, quota/state read-modify-write flows may lose updates under concurrency. For correctness-sensitive counters/transitions, consider one of:

- atomic conditional update (`SET remaining = remaining - ? WHERE remaining >= ?`), checking `RowsAffected`;
- source/write transaction plus `clause.Locking{Strength: "UPDATE"}`;
- optimistic version/check conditions.

Choose only after reproducing the race and checking indexes/deadlock impact.

## Raw SQL, Hooks, and Associations

- Bind values: `db.Raw("... WHERE id = ?", id)` / `Exec(..., args...)`.
- Never concatenate untrusted values, table names, filters, or sorting fragments.
- Stored procedure names and SQL identifiers are compatibility-sensitive.
- As verified by a repository-wide hook-name search on 2026-09-19, no GORM lifecycle hook methods were present. This can become stale; search again before adding/changing model lifecycle behavior.
- Avoid saving populated association graphs accidentally; persist the intended model/columns explicitly.

## `RowsAffected`

Check `RowsAffected` when correctness depends on whether an update/delete matched a row, an optimistic condition succeeded, or a quota decrement was applied. Do not treat `Error == nil` as proof that a record changed.

## Performance Principle

On hot list/report paths, retrieve only the rows, columns, and relationships required for the operation. A full model is acceptable for a simple low-volume point lookup when it keeps code clear. Query count is part of the API design: review it in tests and, for important paths, with real execution evidence.
