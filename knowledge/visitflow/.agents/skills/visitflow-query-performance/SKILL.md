---
name: visitflow-query-performance
description: Use when diagnosing slow VisitFlow endpoints or MySQL queries, N+1 calls, expensive joins, pagination, indexes, or database load.
---

# VisitFlow Query Performance

## Start from the endpoint

Locate the owning service and trace `route → controller → service → repository → SQL`, including gateway mapping if latency is observed at the public endpoint. Read that service's `AGENTS.md`, `.agent/INDEX.md`, `.agent/DATABASE_PERFORMANCE.md`, `.agent/GORM.md`, and nearest repository. Use the `visitflow-gorm-mysql` skill for code or schema changes.

Separate total request latency from database time, external HTTP/FCM/Redis time, serialization, and file work. A slow endpoint is not proof that its visible SQL is the bottleneck.

## Evidence to collect

1. Capture the exact generated SQL shape with bound parameters kept private. Count queries per request, including preloads, loops, and follow-up counts.
2. Record representative input sizes, result cardinality, business period, tenant/structure scope, request frequency, and database connection used. The root database catalog contains dated row estimates; verify current cardinality for decisions that depend on it.
3. Inspect `WHERE`, join keys, selected columns, ordering, grouping, pagination bounds, and existing composite indexes. Look for a lost GORM chain result, predicates applied after a join, nonselective conditions, and reads sent to replicas when freshness is required.
4. Use `EXPLAIN` against the appropriate schema when access is available. Run `EXPLAIN ANALYZE` only when safe for the database and query. Do not run a costly report or procedure on production solely to gather a plan.
5. State a narrow hypothesis, make one justified change, and compare under comparable inputs if the task authorizes performance verification.

## VisitFlow hotspots to recognize

- Core visit/MCL processing combines `visits`, `visit_customers`, `structure_locations`, reports, raw SQL, and stored procedures. Period and company predicates are both correctness and performance constraints.
- Presence reports join attendance, office, calendar, work hour, and leave data. Check join cardinality and calendar date bounds.
- Survey listing can multiply rows through questions, customers, and products/materials; decide whether bounded preload, aggregation, or explicit joins match the response contract.
- Gateway login assembles user and structure data and may use Redis for subordinate data and token checks. Compare cache hit/miss paths and invalidation before optimizing MySQL alone.

## Change rules

- Prefer reducing unnecessary calls and rows before adding an index. Batch loop queries only when order, errors, and transaction semantics remain correct.
- Evaluate a proposed index against selectivity, leftmost-prefix use, sort/group requirements, duplicate indexes, storage, and write cost. A model tag is not evidence that the index exists in the target database.
- Keep tenant and ownership predicates, soft-delete behavior, API pagination, and transaction guarantees intact. Do not substitute a replica for a read that must see a prior write.
- Distinguish query optimization from a changed business result. Compare row sets/counts and edge cases when verification is in scope.

## Report

Give the original bottleneck evidence, query/plan observations, exact change, before/after evidence if measured, and remaining uncertainty. If no representative data or database access exists, present the change as a reasoned proposal rather than a proven speedup.
