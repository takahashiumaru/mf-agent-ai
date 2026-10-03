# Database Performance

This service uses MySQL through GORM, with a source and read replica configured by `go-helper`. Performance changes must preserve business correctness, transaction semantics, tenant scope, and API results.

## Core Principle

Before adding or approving an important query, determine:

- expected and worst-case row counts;
- query frequency and concurrency;
- selective filters and tenant/company scope;
- available single/composite indexes;
- join cardinality;
- sort and pagination behavior;
- selected columns and loaded relations;
- whether the query runs inside a transaction or loop.

Do not optimize from intuition alone. For suspected slow queries, inspect SQL and indexes, then use `EXPLAIN` (or `EXPLAIN ANALYZE` when the deployed MySQL version supports it and execution is safe).

## Current Preferred Patterns

- **Sargable time ranges:** `repository/presence_repository_impl.go` converts Jakarta day/month input to UTC boundaries and queries `in_date_time >= ? AND in_date_time < ?`. Tests in `test/presence_repository_coverage_test.go` protect this shape.
- **Report projections:** presence and leave report repositories use `Select`/`Scan` instead of loading complete writable models.
- **Required-relation joins:** leave, attendance-correction, office-user, and work-hour-user repositories join explicitly needed relations.
- **Batch quota insert:** `repository/leave_quota_repository_impl.go` chunks 100 rows and uses conflict-do-nothing.
- **Parameterized SQL:** raw queries/stored procedures bind values in the representative repository paths.

Prefer these patterns when they match the operation.

## N+1 and Repeated Calls

Database or network work inside a loop is a mandatory review point.

Typical replacement:

`N point queries → one WHERE id IN ? query → map by ID in Go`

or:

`N inserts → slice Create/CreateInBatches`

or:

`N relation reads → targeted Preload/Join`

Repository-specific hotspots:

- `service/office_user_service_impl.go` and `service/work_hour_user_service_impl.go` insert each parsed CSV assignment separately after one bulk delete. Prefer batch insert when touched, while preserving duplicate/audit behavior.
- `service/leave_service_impl.go` performs repository/approval work per leave day. This may reflect the domain's one-row-per-day design; measure and batch only operations that retain per-day correctness.
- `service/presence_service_impl.go` merges two datasets with nested scans and performs per-record writes. Consider date-keyed maps and batched creates after regression tests.
- `service/attendance_correction_service_impl.go` and the approval methods in `service/leave_service_impl.go` make multiple local/external repository calls in one transaction. Review latency and source/replica correctness together.

Do not replace N+1 with a huge join that multiplies rows or returns unused data.

## Index Awareness

Inspect `model/domain` tags and the deployed schema before designing access paths. Important declared indexes include:

- `presences`: `idx_presences_user_in`, `idx_user_id`, `idx_in_date_time` (`model/domain/presence.go`).
- `leaves`: composite `idx_leave`, plus status/end-date/company indexes (`model/domain/leave.go`).
- `leave_quota`: user/category/company composite uniqueness and supporting indexes (`model/domain/leave_quota.go`).
- `calendars`: company/date uniqueness (`model/domain/calendar.go`).
- `office_users` and `work_hour_users`: composite assignment uniqueness (`model/domain/office_user.go`, `model/domain/work_hour_user.go`).
- meeting/visit members: structure/visit/period/company indexes (`model/domain/meeting_member.go`).

Presence reports explicitly `FORCE INDEX` names such as `idx_cal_company_date`, `idx_presences_user_in`, and `idx_leaves_user_date`. These hints assume indexes that are not fully defined by the local migration system; verify the deployed schema before changing query or index names.

Do not add an index for every filter. Each index consumes storage and increases insert/update/delete cost. Add one only for a demonstrated access pattern and verify the plan.

## Composite Indexes

Column order matters. Design around real equality/range/order predicates and tenant scope. Conceptually:

```sql
WHERE company_id = ?
  AND status = ?
ORDER BY created_at DESC
```

may benefit from an index beginning with equality columns and then the ordering column, but only the actual workload and query plan can establish the right order.

Review:

- leftmost-prefix usability;
- equality columns before range columns where appropriate;
- whether `ORDER BY` can use the same index;
- selectivity and data distribution;
- overlap with existing indexes;
- write amplification.

Schema source of truth is not present locally, so index changes require identifying the external migration process first.

## Query Plans

For a slow/high-impact query:

1. Capture the actual SQL and representative bound values without exposing secrets/PII.
2. Check table sizes and existing indexes.
3. Run `EXPLAIN` in a safe environment.
4. Inspect access type, chosen key, estimated rows, join order, temporary tables, and filesort.
5. If safe/supported, use `EXPLAIN ANALYZE` to compare estimates with actual execution.
6. Change one material factor, then measure again.

Do not preserve or add a `FORCE INDEX` merely because it improves one synthetic case; hints can become harmful as data changes.

## Full Scans and Sargability

High-volume tables need selective predicates. Watch for:

- missing `WHERE`/company scope;
- leading-wildcard search (`%term%`);
- functions on indexed columns;
- type casts on join/filter columns;
- `OR` across unrelated columns;
- unbounded list queries.

Current risks:

- Attendance correction filters wrap `in_date_time` in `DATE_FORMAT(DATE_ADD(...))` (`repository/attendance_correction_repository_impl.go`).
- Leave-quota year filtering uses `date_format(start_date, '%Y')` (`repository/leave_quota_repository_impl.go`).
- Calendar deletion filters with `LEFT(date,4)` (`repository/calendar_repository_impl.go`).
- Presence report join expressions cast/time-adjust timestamp columns in `repository/presence_repository_impl.go`.

These are **MIGRATE-WHEN-TOUCHED** on large tables. Prefer precomputed start/end boundaries and range predicates where semantics allow, as the current presence lookup does. Test timezone boundaries.

The inspected `gitlab.com/VNEU/go-helper/helper` v0.5.9 `registerFullScanCallback` checks SQL text for `WHERE`/`LIMIT` and runs `EXPLAIN` when debug mode enables it. This is not a substitute for deliberate review and may not represent production settings.

## Selected Columns

- Avoid `SELECT *` on wide, high-frequency lists and reports when only a few columns are returned.
- Select only required columns from joined tables.
- Keep full-model selects for simple low-volume point reads where clarity outweighs negligible savings.
- Be careful that partial models later passed to `Save`/full updates can overwrite data; use explicit update columns.

## Pagination and Counting

- Every list over potentially growing data must have a bounded, validated maximum limit.
- Several smaller CRUD lists (`OfficeRepository.FindAll`, `WorkHourRepository.FindAll`, `LeaveCategoryRepository.FindAll`) are currently unbounded. This is **LEGACY**; new large-list endpoints must paginate, and existing ones should migrate only with API compatibility planning.
- Existing offset pagination is suitable for modest pages. Large offsets still scan/discard rows; investigate keyset pagination for high-volume chronological/ID-ordered feeds.
- Use a stable deterministic sort, ideally supported by an index.
- Allowlist sort columns/direction and bind search values. In `gitlab.com/VNEU/go-helper/helper` v0.5.9, `GetPagination` copies request-derived `sort` into `OrderBy`, and `SearchCondition` interpolates the search value into SQL. This is **DANGEROUS** for safety and plan stability.
- Avoid repeated count queries when the caller does not use the total.
- Count after applying the same filters. Joins may multiply rows, requiring `COUNT(DISTINCT base.id)`.
- The inspected `go-helper` v0.5.9 `CalculateTotalPages` implementation returns `9999`; it is not a valid count. Do not treat it as performance/correctness evidence.

## Joins and Aggregation

- Join only tables required for filtering, projection, or returned relations.
- One-to-many joins can duplicate parent rows and corrupt pagination/counts.
- Push straightforward `COUNT`, `SUM`, grouping, and monthly aggregation to MySQL rather than loading thousands of rows into Go.
- Keep business state transitions and external side effects in services; SQL aggregation should not become an opaque replacement for domain rules.
- Complex report SQL in `repository/presence_repository_impl.go` and `repository/leave_repository_impl.go` deserves query-plan tests against production-like volumes before major changes.

## Large `IN` Lists and Batches

- `IN ?` is appropriate for moderate batched IDs, as used for assignment deletion.
- Deduplicate IDs first.
- Split very large lists to respect packet/placeholder limits and reduce lock duration.
- Choose batch sizes from measurement and row width. The current quota batch size of 100 is repository evidence, not a universal constant.
- Avoid one update per row when a safe set-based update expresses the same rule.

## Transactions and Load

- Validate/parse input before opening a transaction where possible.
- Keep transactions short to reduce locks, connection occupancy, and deadlocks.
- Avoid file creation, CSV parsing, remote HTTP/Firebase calls, notification dispatch, and heavy CPU loops inside transactions unless correctness requires them.
- `service/leave_service_impl.go`, `service/office_user_service_impl.go`, and `service/work_hour_user_service_impl.go` open transactions before file I/O/parsing; this is **MIGRATE-WHEN-TOUCHED**.
- Do not use a replica read to make a correctness-sensitive decision for a source write; replica lag can produce stale quota/state decisions.
- When concurrent balance updates matter, use atomic conditional SQL, write-source row locking, or optimistic conditions and check `RowsAffected`.

## Connection Pool

Database initialization is delegated by `app/database.go` to `gitlab.com/VNEU/go-helper/helper.ConnectMysqlDatabaseResolver` v0.5.9. Its `connectMysqlDatabase` function sets:

- `SetMaxIdleConns(10)`
- `SetMaxOpenConns(100)`
- `SetConnMaxLifetime(time.Hour)`
- no observed `SetConnMaxIdleTime`

Do not guess better values. Tune with database capacity, application replica count, request concurrency, wait duration, connection churn, and MySQL limits. Expose/measure `database/sql` pool stats before changing settings.

## Query Performance Review Checklist

Before approving a significant query:

1. Is `WHERE` selective and tenant-scoped?
2. Do deployed indexes support filters/joins/order?
3. Are functions preventing index range use?
4. Is it loading unused columns?
5. Is it loading unused relations?
6. Can it cause N+1 or repeated calls?
7. Is pagination bounded and deterministic?
8. Is sorting index-supported or likely to filesort?
9. Are calls happening inside loops?
10. Can inserts/updates/lookups be safely batched?
11. Can joins multiply rows or break counts?
12. Does it need `EXPLAIN` verification?

If the answer is unknown for a high-impact path, investigate before optimizing or approving it.
