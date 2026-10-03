# Database Performance

## Core Principle

Think about query complexity before adding database code. For every important query, estimate or measure:

- expected rows examined and returned;
- filter selectivity;
- usable indexes;
- join cardinality;
- sorting and grouping cost;
- pagination behavior;
- selected column width;
- association loading;
- request frequency and concurrency.

Do not optimize blindly. For suspected slow queries, inspect the SQL, schema/indexes, workload, and preferably `EXPLAIN` output before making a major change.

## Repository Performance Baseline

Sound current patterns:

- No obvious database call inside a per-row loop was found.
- User-role reports use one explicit join query rather than repeated lookups.
- Structure hierarchy resolution uses recursive CTEs rather than application-side N+1 traversal.
- Login performs bcrypt and notification preparation outside its short write transaction.
- Refresh-session consumption uses one delete and checks `RowsAffected`.
- Filters in `Where` and raw CTE values generally use bound parameters.

Important risks:

- User list and login queries load more columns than their outputs require.
- `%term%` search and functions on date/string columns can prevent useful index access.
- `sort` and search helpers construct SQL fragments from request text.
- Generic/report filters currently discard returned GORM chain handles and may not filter at all.
- Several list/report queries are unbounded or have no enforced maximum limit.
- OFFSET pagination can degrade at high page numbers.
- Recursive CTEs, `GROUP_CONCAT`, multi-table access reports, and unconditional counts need execution-plan evidence at scale.
- Local `config.DBConnect` does not configure the `database/sql` connection pool.
- GORM logs every query at Info level, which can add load/noise in production.

## N+1 Detection

Treat a database/network call inside a loop as a review warning:

`N parent rows -> N child queries`

Prefer one of:

- a batch query using `WHERE foreign_key IN ?`, then group by key in memory;
- a selective `Preload` for bounded full associations;
- a join for filtering/projection;
- database-side aggregation;
- a bulk repository method.

Search both direct GORM calls and repository calls inside loops. A loop in a service can hide N+1 even if the repository itself has no loop.

Current repositories do not show a clear N+1 loop. Preserve the set-based approach in `repository/user_role_repository_impl.go` and the hierarchy queries in `repository/users_repository_impl.go`.

## Index Awareness

Before adding an important filter, join, or sort:

1. Inspect the actual deployed schema/indexes; this repository has no migrations.
2. Compare the index's leading columns with equality/range predicates.
3. Check join keys, soft-delete predicates, and ordering.
4. Estimate read benefit against storage and write amplification.
5. Validate with `EXPLAIN` on representative data.

Common candidates in this repository include:

- `sessions.user_id` and unique `sessions.refresh_uuid`—already represented by tags;
- user authentication lookups (`user_name`, `email`, `device_id`, `access_token`, `deleted_at`);
- role assignment composite keys;
- `structures(period, id/user_id/boss_code/level)` access paths used by recursive queries;
- join/report keys across `user_roles`, `role_menu_permissions`, `user_departments`, and `departments`;
- stable list sort/filter columns.

Do not automatically index every candidate. Indexes increase storage, cache pressure, and INSERT/UPDATE/DELETE cost. Verify existing composite keys—especially the unusual user key/index tags—against the deployed schema first.

## Composite Indexes

Column order matters. Equality columns usually lead, followed by range/sort columns when that matches the engine and query.

Conceptually:

```sql
WHERE company_id = ?
  AND status = ?
ORDER BY created_at DESC
```

may benefit from `(company_id, status, created_at)`, but only after checking actual cardinality, existing indexes, query variants, and the MySQL plan. Do not invent indexes from a single source-code query.

## Query Plans

For slow or high-frequency queries, capture the exact generated SQL and use MySQL `EXPLAIN`; use `EXPLAIN ANALYZE` only when supported and safe for the environment/query.

Prioritize plan review for:

- `JoinUserAndStructure` and `JoinUserAndStructureMR` recursive CTEs;
- `UserAccessReport`'s multi-table join;
- wildcard user/role search;
- list queries with high offsets and counts;
- any query flagged by GORM's one-second slow threshold.

Do not run write statements through analysis tools in production without understanding their execution semantics.

## Full Table Scans and Sargability

Check for:

- missing or ineffective `WHERE` clauses;
- predicates on unindexed columns;
- leading-wildcard `LIKE '%value%'`;
- functions applied to indexed columns;
- implicit type conversions;
- OR conditions spanning different keys;
- discarded GORM chain results;
- low-selectivity soft-delete-only predicates.

Repository-specific candidates:

- `goHelper.SearchCondition` generates leading-wildcard search.
- `FindAll` applies `DATE_FORMAT(join_date, ...)` and `DATE_SUB` to a string-like date field.
- Login uses `COALESCE(NULLIF(resign_date, ''), ...)`, which can make index use difficult.
- Recursive CTE seeds can examine all `structures` rows for a period before the outer filter.

These are investigation targets, not proof that an index or rewrite is required. Use plans and representative data.

## Selected Columns

Avoid `SELECT *` on wide or sensitive tables when a query needs a small projection.

- `UserRepositoryImpl.FindAll` currently loads full users, including credential/token fields, before mapping a subset to responses.
- `JoinUserAndStructure` explicitly selects `users.*` plus joined fields even though only a subset is used to verify login and build JWT claims.
- Report code in `UserAccessReport` demonstrates the preferred explicit projection style.

Use a dedicated projection struct when that materially reduces transfer, scan work, memory, or sensitive-data exposure. Do not over-optimize tiny low-frequency lookups.

## Large `IN` Clauses

Batch very large ID collections to respect MySQL packet/parameter limits and avoid poor plans. Keep batching bounded and preserve result ordering explicitly if the caller needs it. Do not replace one efficient moderate `IN` query with many tiny queries without measurements.

## Pagination

- Validate `page` and `limit`; require positive values.
- Enforce a maximum limit for public list endpoints.
- Use a stable, allowlisted order including a unique tiebreaker.
- Never allow an accidental unbounded high-volume list.
- Investigate keyset/cursor pagination when large offsets are measurably expensive.

Current go-helper pagination defaults and raw sort handling are legacy risks. Role-menu permissions, user-role assignments, access reports, department/user-department lookups, and some repository methods have no pagination. Decide whether their cardinality is inherently bounded; otherwise add a compatible bound.

## Sorting

- Allowlist sortable columns and direction.
- Check whether the relevant index supports filtering plus ordering.
- Avoid sorting wide joined result sets before reducing rows.
- Add a deterministic unique tiebreaker.

Current controllers pass the go-helper `sort` string through to GORM `Order`. Do not copy this without validation; it is both a safety and performance risk.

## Joins

- Join only tables required for the operation.
- Select only required columns.
- Verify relationship cardinality and duplicate-row behavior.
- Apply soft-delete and ownership/tenant predicates consistently.
- Ensure join keys have appropriate indexes in the deployed schema.

`UserAccessReport` is set-based, but its five-table join has no pagination and current optional filters are discarded because returned `Where` handles are not retained. Fix correctness before tuning its indexes.

## Aggregation

Push straightforward `COUNT`, `SUM`, `MIN`, `MAX`, grouping, and existence checks to the database rather than loading thousands of rows solely to aggregate in Go. Keep complex business decisions in the service/domain layer.

Use `EXISTS` or a bounded lookup when only existence matters. Do not request total counts automatically if the API does not need them.

## Database Calls Inside Loops

For every loop containing a repository call, ask:

- Can the inputs be collected and fetched in one query?
- Can one bulk write replace per-row writes?
- Is ordering or per-item error behavior required?
- Would batching preserve transaction size and lock duration?

If per-row calls are genuinely required, bound the collection and document why.

## Transactions and Load

Keep transactions as short as correctness permits.

Avoid inside transactions:

- remote HTTP/SMTP/Firebase calls;
- bcrypt or other expensive CPU work;
- filesystem operations;
- long unbounded reads;
- sleeps/retries;
- work using the root DB instead of the transaction.

The login/refresh callback transactions are the preferred shape: expensive preparation occurs first, then session/token writes are grouped atomically. Plain read operations generally do not need an explicit transaction.

Legacy resolver warning: go-helper opens separate read and write transactions per call, while services close only one. This can hold connections/transactions unnecessarily and must not be copied into new code.

## Connection Pool

`config.DBConnect` does not call:

- `SetMaxOpenConns`
- `SetMaxIdleConns`
- `SetConnMaxLifetime`
- `SetConnMaxIdleTime`

Therefore the application uses `database/sql` defaults for its locally created connections. `main.go` opens two root GORM connections, increasing the importance of understanding total pool usage.

Do not guess pool values. Determine database capacity, service replica count, request concurrency, query latency, and server timeouts; then configure and monitor pool wait count/duration, open/in-use/idle connections, and DB saturation. Pool tuning is a deployment-level change, not a speculative code cleanup.

## Other Repository-Specific Load Risks

- `SET SESSION group_concat_max_len = 1000000` adds a round trip and mutates pooled connection session state; verify connection affinity and replace with a safer deployment/query design when touching that flow.
- GORM Info-level logging logs every query; choose production log level from observability requirements and measured overhead.
- Counting every list request adds a query; retain it only because the current API returns `count_data`, or change the contract explicitly.
- Concurrent login reads reduce latency but double simultaneous DB demand for that request; preserve only if measured benefit outweighs load.

## Query Performance Review Checklist

Before approving a significant query:

1. Is the `WHERE` clause selective enough?
2. Are the relevant deployed indexes available and ordered correctly?
3. Is it loading unnecessary columns or sensitive data?
4. Is it loading unnecessary associations?
5. Can it cause N+1 directly or through a service loop?
6. Is pagination bounded and stable?
7. Is sorting supported or likely to spill/work excessively?
8. Are DB calls happening inside loops?
9. Could a batch query/write help?
10. Does the query need `EXPLAIN` verification?
11. Are counts and joins cardinality-correct?
12. Is the transaction shorter than necessary?
