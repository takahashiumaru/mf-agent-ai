---
name: mysql-performance
description: "Review or optimize MySQL queries, joins, filtering, sorting, pagination, indexes, or database load, including suspected slow endpoints and large-table access."
---

# MySQL Performance

Use with `gorm-quality` for ORM code and `performance-profiling` when optimization is the explicit goal.

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Workflow

Follow `MEASURE -> UNDERSTAND -> OPTIMIZE -> VERIFY`.

For a significant query inspect:

- generated SQL and query count;
- `WHERE`, `JOIN`, `GROUP BY`, `ORDER BY`, `LIMIT`, and `OFFSET`;
- selected columns and expected result cardinality;
- actual deployed indexes and approximate table size when available;
- execution frequency and transaction scope.

Do not call a query optimized from appearance alone. Use `EXPLAIN`, and `EXPLAIN ANALYZE` only when supported and safe.

## Query Review

Ask:

1. Can it scan most/all rows?
2. Is the filter selective and sargable?
3. Are join/filter/order columns supported by appropriate indexes?
4. Can joins multiply root rows or make counts wrong?
5. Are unnecessary/sensitive columns loaded?
6. Can service or repository loops cause N+1?
7. Is pagination bounded and stable?
8. Is sorting expensive?
9. Can batching or aggregation reduce calls?
10. What is the expected row count and request frequency?

## Repository Evidence

PREFERRED — set-based explicit joins in `repository/user_role_repository_impl.go` and parameterized recursive CTEs in `repository/users_repository_impl.go`; fix their known filtering/projection issues rather than replacing them with per-row queries.

Risks requiring evidence:

- Leading-wildcard search from `goHelper.SearchCondition`.
- Function-wrapped date predicates and string date fields in user filtering/login.
- `users.*` and full `domain.User` loads where projections would suffice.
- Unbounded role-permission, user-role, and access-report lists.
- Large OFFSET values and total counts on every paginated request.
- Recursive CTE and five-table report join cardinality.
- `SET SESSION group_concat_max_len` round trip and pooled-session mutation.

No obvious current N+1 loop was found. Preserve that property.

## Index Rules

Never add an index merely because a column appears in `WHERE`.

Inspect existing single/composite indexes, leftmost-prefix order, selectivity, query frequency, join/order usage, duplicate indexes, write frequency, and storage/write cost. Confirm the deployed schema because this repository has no migration source of truth.

Important access paths include refresh UUID/user ID, authentication lookups, composite role assignments, and structure period/boss/user hierarchy queries. These are candidates for analysis, not automatic index recommendations.

## Pagination, Aggregation, and Batching

- Validate positive limits and enforce a maximum for public lists.
- Use stable allowlisted ordering with a unique tiebreaker.
- Investigate keyset pagination only when deep OFFSET is measurably costly and the API can support it.
- Aggregate `COUNT`/`SUM`/`AVG`/`MIN`/`MAX` in MySQL when Go would otherwise load many rows solely to aggregate.
- Review every DB call inside a loop; batch safely when semantics permit.
- Avoid enormous `IN` lists; use bounded batches based on observed limits/workload.

## Transaction and Pool Load

- Keep transactions short and do not include external I/O or expensive CPU work unless correctness requires it.
- `config.DBConnect` does not configure max-open, max-idle, lifetime, or idle-time settings. Do not guess values; derive them from DB capacity, replica count, concurrency, latency, and pool metrics.
- GORM Info-level SQL logging may add production load; change it only with observability evidence.

## Review Gate

- Query shape and count inspected.
- N+1, projection, cardinality, bounds, ordering, and transaction scope reviewed.
- Index recommendation backed by deployed schema and workload.
- Before/after evidence captured for meaningful optimization.

Read `../../DATABASE_PERFORMANCE.md` and `../../DATABASE.md` when deeper repository detail is needed.
