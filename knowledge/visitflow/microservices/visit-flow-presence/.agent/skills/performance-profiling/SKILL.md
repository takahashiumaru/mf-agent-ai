---
name: performance-profiling
description: Use when asked to reduce latency, CPU, memory, allocations, database load, or investigate slow endpoints and performance regressions.
---

# Performance Profiling

## Core Principle

`MEASURE → IDENTIFY BOTTLENECK → CHANGE → MEASURE AGAIN`

Do not increase complexity for theoretical speed. Transaction correctness, security, and data integrity always win over minor performance gains.

## Required Workflow

`UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW`

Define the workload, baseline, target metric, and correctness invariants before optimizing.

## Repository Evidence

- **PREFERRED:** SQL-shape regression coverage for presence date ranges in `test/presence_repository_coverage_test.go`.
- **PREFERRED:** chunked inserts in `repository/leave_quota_repository_impl.go` when batch semantics match.
- **ACCEPTABLE:** repository use of targeted joins and raw SQL for reports, but generated SQL and plans must be inspected before performance claims.
- **LEGACY:** one DB write per CSV row in office/work-hour user flows and repeated DB work inside leave/presence loops.
- **LEGACY:** function-wrapped date predicates and unbounded list queries can increase scan/load risk.
- No repository benchmark suite or exposed `pprof` endpoint is clearly established.

## Go Measurement

- Use focused benchmarks for hot pure/application paths; report `ns/op`, allocations, and workload.
- Use CPU/heap profiles for meaningful runtime bottlenecks when a representative environment is available.
- Use the race detector for concurrency correctness, not as a speed measurement.
- Inspect allocation reduction only after confirming allocations matter to the observed bottleneck.
- Do not introduce goroutines merely because an operation is slow; first determine whether time is CPU, DB, network, lock, or queue wait.

## Database Measurement

- Capture generated SQL, query count per request, parameter shapes, expected/actual row counts, and current indexes.
- Use `EXPLAIN`; use `EXPLAIN ANALYZE` only when supported and safe.
- Compare joins, preloads, and batch alternatives using the same representative data/workload.
- A cleaner GORM chain is not necessarily faster SQL. A sqlmock test does not measure MySQL.

## Before/After Evidence

For a meaningful optimization, record:

- identical workload and environment assumptions;
- baseline latency/throughput/CPU/memory/query count/plan as relevant;
- the bottleneck hypothesis;
- correctness tests and transaction invariants;
- after-result and any tradeoffs.

## Stop Conditions

Do not optimize further when the bottleneck is elsewhere, the effect is noise, the workload is unrealistic, or complexity/risk outweighs measured value. Document missing production cardinality or telemetry instead of guessing.

Use `mysql-performance` and `gorm-quality` for database work; read `.agent/DATABASE_PERFORMANCE.md`.
