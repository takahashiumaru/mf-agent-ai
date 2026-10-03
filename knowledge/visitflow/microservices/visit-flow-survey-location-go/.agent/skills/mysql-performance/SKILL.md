---
name: mysql-performance
description: Use when creating or changing significant MySQL queries, joins, filters, sorting, pagination, indexes, large-table access, or investigating slow database behavior.
---

# MySQL Performance

## Outcome

Improve query performance with evidence while protecting correctness, transaction guarantees, and write cost.

## Required Reading

Read `../../../AGENTS.md`, `../../DATABASE.md`, and `../../DATABASE_PERFORMANCE.md`. For ORM work also apply `../gorm-quality/SKILL.md`.

## Query Review

For a new or materially changed query, inspect:

- `WHERE` selectivity and tenant/ownership predicates;
- join type, join cardinality, and indexed join columns;
- `ORDER BY`, `GROUP BY`, selected columns, `LIMIT`, and `OFFSET`;
- expected table size, returned cardinality, frequency, and query count;
- existing single/composite indexes and their column order;
- preload or loop behavior that can produce N+1 queries;
- transaction scope and whether reads require primary consistency.

## Evidence Loop

1. Capture the generated SQL and parameters safely.
2. Establish query count and a representative workload.
3. Inspect current indexes.
4. Use `EXPLAIN`; use `EXPLAIN ANALYZE` only where safe and appropriate.
5. Change the query or index with the smallest justified intervention.
6. Compare before and after under the same workload.

Do not call a query optimized based only on appearance.

## Index Safety

- Never add an index merely because a column appears in `WHERE`.
- Evaluate selectivity, leftmost-prefix behavior, joins, sort/group use, query frequency, write frequency, storage, and duplicate/redundant indexes.
- Preserve correctness and transaction guarantees; never trade them for a theoretical speed gain.
- Coordinate index creation with `../database-schema/SKILL.md` and `../migration-safety/SKILL.md`.

## Query Shape

- Keep endpoint pagination bounded. Investigate keyset pagination only when deep `OFFSET` is measurably costly and contract changes are acceptable.
- Perform suitable `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX` in MySQL rather than loading large datasets solely to aggregate in Go.
- Batch database work in loops when semantics and error handling remain correct.
- Avoid unnecessary columns and associations on high-volume paths.

## Repository Examples


## Completion Gate

- State what was measured, what bottleneck was found, and the before/after evidence.
- If production data or plans are unavailable, label conclusions as hypotheses and list the exact evidence still required.
- Confirm no redundant index, unbounded result, ownership leak, or excessive transaction was introduced.

## Local navigation and limits

Use `../../PREFERRED_PATTERNS.md` for scoped examples and `../../TESTING.md` for facilities. Survey route/service/repository anchors are outlet_survey or distributor; product repositories use customer_material filenames. Repositories take `*gorm.DB`; services select the read/write handle. SQL mocks check generated statements and calls, not live isolation or replication.
