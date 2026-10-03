---
name: mysql-performance
description: Use when creating or changing MySQL queries, filters, joins, sorting, pagination, indexes, or investigating slow database-backed behavior.
---

# MySQL Performance

## Core Principle

Review query shape and expected cardinality before changing SQL. Optimize only from evidence: generated SQL, query count, indexes, and preferably execution plans.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

For a significant query, inspect `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`, selected columns, pagination, frequency, expected rows, and deployed indexes.

## Repository Pattern Classification

- **PREFERRED:** Jakarta-local dates converted to a UTC half-open range (`>= start`, `< end`) in `repository/presence_repository_impl.go`; SQL-shape coverage is in `test/presence_repository_coverage_test.go`.
- **PREFERRED:** batched quota creation in `repository/leave_quota_repository_impl.go` rather than one insert per row.
- **ACCEPTABLE:** targeted joins used by presence/leave reports when their cardinality and selected data are understood.
- **LEGACY:** unbounded `FindAll` methods in simple CRUD repositories such as `repository/office_repository_impl.go` and `repository/work_hour_repository_impl.go`.
- **LEGACY:** function-wrapped date predicates in attendance correction, leave quota, calendar, and presence reporting queries; these can prevent useful range-index access.
- **DANGEROUS:** request-derived search/order SQL from the external pagination helper unless identifiers are allowlisted and values are bound.

## Query Review

Ask:

1. Is the predicate selective and tenant/company scoped?
2. Can a function, cast, leading wildcard, or missing predicate force a scan?
3. Do join keys and filter/sort columns align with existing indexes?
4. Can one-to-many joins multiply rows or corrupt counts?
5. Are selected columns and loaded relations actually needed?
6. Is this an N+1 or repeated query inside a loop?
7. Is pagination bounded and ordering deterministic?
8. What is the expected cardinality and request frequency?

## Index Safety

- Never add an index merely because a column appears in `WHERE`.
- Inspect existing single/composite indexes, column order, leftmost-prefix use, selectivity, query frequency, write cost, and redundant indexes.
- Model tags in `model/domain/presence.go`, `model/domain/leave.go`, `model/domain/leave_quota.go`, and `model/domain/calendar.go` are evidence, not proof of the deployed schema.
- An equality-prefix followed by range/sort columns may be useful, but confirm against the real query and MySQL plan.

## Measurement

- Capture actual generated SQL and query count.
- Use representative values with `EXPLAIN`; use `EXPLAIN ANALYZE` only when supported and safe for that statement/workload.
- SQL-mock tests verify shape, not index effectiveness.
- Do not call a change optimized without a before/after query count, plan, latency, or equivalent evidence for meaningful work.

## Load Controls

- Clamp list limits; no repository-wide maximum is established, so preserve an existing contract or obtain a product/operational limit for a new endpoint. Investigate keyset pagination before replacing deep `OFFSET` only when workload justifies it.
- Push suitable `COUNT`, `SUM`, and similar aggregation into MySQL instead of loading thousands of rows solely to aggregate in Go.
- Batch very large `IN` lists and writes where semantics allow.
- Keep transactions short; avoid remote I/O and CPU-heavy work while a transaction is open.

Read `.agent/DATABASE.md` and `.agent/DATABASE_PERFORMANCE.md` before schema or performance work.
