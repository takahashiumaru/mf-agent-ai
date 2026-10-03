# Database Performance

This is a review guide, not permission to change indexes or queries without evidence. Production MySQL version, schema migration ownership, row counts, and query latency are not established in this repository.

## Core Principle

Before adding or changing an important query, consider:

- expected and worst-case row count;
- tenant/period/status filters and their selectivity;
- existing indexes and composite-index order;
- joins and row multiplication;
- selected columns and wide/text/blob values;
- relation-loading strategy;
- sort and pagination behavior;
- query frequency and concurrency;
- transaction duration;
- whether an execution plan confirms the suspected cost.

Correctness and measured evidence come before micro-optimization.

Treat a query as significant when it powers a list/report/batch job, contains joins/aggregation/raw SQL, can return an unbounded set, runs inside a loop, or is invoked at high frequency. These queries require an explicit performance review; small keyed CRUD reads may only need a quick scope/index check.

## Repository Performance Profile

The codebase already uses:

- GORM `dbresolver` with source/replica routing;
- pagination in several visit/customer/location/report lists;
- joins and projections for compound responses;
- batch insert/upsert with sizes such as 100 and 500;
- raw set-based updates and stored procedures for reporting/batch flows;
- explicit index hints in `repository/customer_family_repository_impl.go`;
- in-memory maps after batch reads in `service/structure_service_impl.go` and `service/html_service_service_impl.go`.

Observed risks include unbounded `Find` methods, `SELECT alias.*` on join-heavy queries, function-wrapped date predicates, repository calls inside loops, repeated totals/counts, long processing inside transactions, and dynamic sort/filter fragments.

## N+1 Detection

Any database or network call inside a loop is a performance review trigger. Confirm whether the loop is bounded and whether each call is necessary.

Legacy candidates:

- `service/process_data_visit_service_impl.go`: two SKI queries per structure during processing.
- `service/visit_service_impl.go`: structure lookup per expanded joint-visit member.
- `service/customer_service_impl.go`: customer-log read and create/update per submitted family/address.
- mapping replacement flows that delete/create one link per iteration.

Preferred repository examples:

- `service/html_service_service_impl.go`: collect customer IDs, fetch all addresses once, group in a map.
- `service/structure_service_impl.go`: collect unique customer IDs, batch-fetch clusters/priorities, enrich slices in memory, then upsert batches.

Preferred conceptual transformation:

```text
N item queries
-> collect unique keys
-> query with a bounded IN/batch API
-> index results in a map
-> apply results in memory
```

Use `Preload` or a join only when its cardinality and result shape are better than a separate batch lookup.

## Index Awareness

Before proposing an index:

1. inspect the actual production schema, not only GORM tags;
2. list the query's equality, range, join, and order columns;
3. check existing single/composite indexes and uniqueness constraints;
4. use `EXPLAIN` on representative parameters;
5. evaluate write/storage cost and redundant indexes.

Common access columns in this repository include `company_id`, `period`, `structure_id`, `customer_id`, `location_id`, `status`, `schedule_datetime`, and soft-delete timestamps. Their frequency alone does not justify individual indexes.

Indexes improve reads but consume storage and add insert/update/delete cost. Indexing every filter column is not a safe default.

## Composite Indexes

Column order matters. Equality columns commonly precede a range or ordering column, but actual selectivity and MySQL plans decide the useful order.

For a conceptual query:

```sql
WHERE company_id = ? AND status = ?
ORDER BY created_at DESC, id DESC
```

an index beginning with `(company_id, status, created_at, id)` might help, but only after checking real workload, existing keys, and `EXPLAIN`. Do not derive migrations from this example.

Keep upsert conflict columns aligned with a verified unique index. Composite keys are especially important for period/structure/customer/location records.

## Query Plans

For a slow or high-frequency query, capture the generated SQL and parameters safely and use `EXPLAIN`. Use `EXPLAIN ANALYZE` only if the deployed MySQL version supports it and executing the query is safe.

Record the sanitized SQL shape, relevant schema/index definition, representative cardinality, plan output, and environment in the issue/PR or task notes. Do not include customer data, tokens, credentials, or raw sensitive parameters.

Inspect:

- access type and selected index;
- estimated versus actual rows where available;
- temporary tables/filesort;
- join order;
- dependent subqueries;
- full scans;
- whether `DISTINCT`/`GROUP BY` compensates for avoidable row multiplication.

The debug callback in `go-helper` attempts to detect queries without `WHERE`/`LIMIT` and run `EXPLAIN`, but it uses generated SQL heuristics and is not a substitute for manual review.

If a compatible database or production-like plan is unavailable, state that the optimization is not plan-verified. Limit the change to correctness-obvious improvements (for example removing a proven N+1 through an equivalent batch query), retain rollback capability, and do not claim a measured performance gain.

## Full Scans and Sargability

Investigate high-volume queries with:

- missing/selectively weak `WHERE` conditions;
- leading-wildcard searches (`LIKE '%value%'`);
- functions applied to indexed columns;
- type conversions/collation mismatches;
- `OR` predicates across unrelated columns;
- soft-delete filters absent from custom table/raw queries.

Visit queries use expressions such as `DATE(DATE_ADD(schedule_datetime, INTERVAL 7 HOUR))`. These can prevent direct index range use. Preserve timezone semantics, but for a proven hotspot consider computing equivalent UTC/local range boundaries in Go and comparing the raw column—after tests and `EXPLAIN` confirm correctness and benefit.

## Selected Columns

- Avoid `SELECT *` or `alias.*` in performance-sensitive joins when only a subset is serialized or calculated.
- Wide visit/customer/report structs amplify network, scan, and allocation cost.
- Use explicit projection structs and columns when it materially reduces data.
- Keep low-volume simple CRUD readable; column lists create maintenance cost when schemas change.

Join-heavy `Select("v.*", ...)` patterns in `repository/visit_repository_impl.go` and `Select("c.*", ...)` in customer queries deserve review when those endpoints are slow, not automatic rewriting.

## Pagination

- Never add an accidentally unlimited public list endpoint.
- Validate a default and maximum page size at the HTTP boundary.
- Existing code uses offset pagination through `goHelper.PaginationData`; preserve its response contract for existing endpoints.
- Large `OFFSET` forces MySQL to scan/discard increasing rows. For proven high-volume feeds, investigate keyset pagination using a stable indexed order such as `(created_at, id)`.
- Keyset pagination is an API contract change; do not introduce it as an invisible optimization.

Several master/reference list repositories use unbounded `Find`. Confirm these tables are intentionally small or add bounded behavior through an explicit API-compatible change.

## Sorting and Search

- Allowlist sort columns and directions; arbitrary order strings are both unsafe and hard to index.
- Check whether common `ORDER BY` columns follow equality predicates in a useful composite index.
- Case-insensitive `UPPER(column) LIKE '%...%'` in `helper.ApplyFilter` is non-sargable for ordinary indexes. Treat broad search on large tables as a measured risk.
- Do not add a functional/full-text index without checking MySQL version, semantics, and migration ownership.

## Joins, Counts, and Aggregation

- Join only required tables and columns.
- One-to-many joins multiply rows and can corrupt pagination/counts.
- Count the intended entity, often with `COUNT(DISTINCT root.id)` after joins.
- Remove irrelevant `ORDER BY`, preload, and selected payload columns from count queries.
- Push simple count/sum/group aggregation to MySQL instead of loading thousands of rows into Go.
- Keep complex business policy in services even when the database computes raw aggregates.

## Large `IN` Lists and Batches

- Deduplicate keys before querying.
- Chunk very large `IN` lists and writes according to row width, packet limits, lock duration, and observed plans.
- Avoid one insert/update per item when a batch or set-based operation preserves the same error semantics.
- Check every batch result. Partial behavior and conflict semantics must be explicit.
- Do not choose a universal batch size; existing 100/500 values are evidence, not guaranteed optima.

## Transaction Performance

- Begin a transaction only when the first transactional database operation is ready.
- Keep it as short as correctness allows.
- Avoid HTTP/Firebase calls, file saves/reads, template rendering, large CSV processing, and heavy CPU loops inside a transaction.
- Fetch immutable reference data before the transaction when consistency allows.
- Never hold locks across user/network-controlled latency.
- Split batch jobs into restartable chunks only when partial-progress semantics are designed and tested.

Large structure/report/HTML processing services hold transactions while transforming significant datasets. These are **MIGRATE-WHEN-TOUCHED** performance risks, not templates for new synchronous operations.

## Connection Pool

The external `go-helper` connector configures:

- `SetMaxIdleConns(10)`
- `SetMaxOpenConns(100)`
- `SetConnMaxLifetime(time.Hour)`

`SetConnMaxIdleTime` is not configured in the inspected helper version. Do not guess better values. Tune from database capacity, replica topology, request concurrency, wait time, saturation, and connection churn. Remember the service creates two GORM handles and registers replicas.

## Query Performance Review Checklist

Before approving a significant query:

1. Is tenant/ownership scope correct?
2. Is `WHERE` selective enough?
3. Do verified indexes match predicates and ordering?
4. Is it loading unused columns or associations?
5. Can it cause N+1 behavior?
6. Is pagination bounded?
7. Can joins multiply rows or break counts?
8. Is sorting/search non-sargable or expensive?
9. Are calls happening inside loops?
10. Would batching/set-based work preserve semantics?
11. Is the transaction unnecessarily long?
12. Does `EXPLAIN` support the proposed optimization?
