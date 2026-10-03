---
name: performance-profiling
description: "Investigate or optimize CPU, memory, allocations, latency, concurrency, slow endpoints, or database performance using measurements and before/after evidence."
---

# Performance Profiling

Follow `UNDERSTAND -> INSPECT -> PLAN -> IMPLEMENT -> TEST -> REVIEW`.

## Required Method

`MEASURE -> IDENTIFY BOTTLENECK -> CHANGE -> MEASURE AGAIN`

Do not say “this should be faster” for meaningful performance work without evidence. Cleaner ORM or concurrent code is not automatically faster.

## Define the Problem

Before changing code, establish:

- operation/endpoint and representative workload;
- latency/throughput/resource symptom;
- current baseline and acceptable target;
- environment, dataset size, concurrency, and measurement noise;
- whether the bottleneck is Go, MySQL, external I/O, logging, or deployment.

Keep correctness, data integrity, and transaction behavior fixed while measuring.

## Go Investigation

Choose tools appropriate to evidence:

- focused `go test -bench` and `-benchmem` for repeatable code paths;
- CPU profiles for compute hotspots;
- heap/allocation profiles for memory pressure;
- goroutine/block/mutex profiles for stalls/leaks/contention;
- `go test -race` for concurrency correctness, not speed measurement;
- request-level timing for end-to-end latency.

No repository benchmarks or pprof endpoints are currently established. Do not expose profiling endpoints publicly or add permanent infrastructure without explicit scope/security review.

There is no preferred profiling harness in the repository. Relevant measurement anchors are GORM's slow-query threshold in `config/db.go`, `make cover` for test coverage (not performance), and repository query tests for stable workloads.

## Database Investigation

Capture:

- actual generated SQL and query count;
- bind-value/cardinality shape without exposing secrets;
- current indexes and table sizes;
- `EXPLAIN`, and `EXPLAIN ANALYZE` when supported/safe;
- rows examined/returned, sort/temp-table behavior, lock waits, and connection-pool pressure.

Use `gorm-quality` and `mysql-performance` for query changes.

## Repository Candidates

Evidence-worthy hotspots include:

- recursive structure CTEs and `GROUP_CONCAT` in `repository/users_repository_impl.go`;
- the five-table access-report join;
- wildcard searches, counts, and deep OFFSET pagination;
- full user-row projections;
- GORM Info logging and missing local pool tuning;
- concurrent login reads, which trade latency for extra DB concurrency;
- bcrypt, which is intentionally CPU-expensive and must not be weakened casually.

These are candidates, not proven bottlenecks.

## Avoid Fake Optimization

- Do not add goroutines before locating latency and defining ownership/cancellation.
- Do not weaken bcrypt, validation, authorization, or transactions for speed.
- Do not add caches without invalidation/consistency/observability requirements.
- Do not replace readable code for tiny theoretical allocation wins.
- Do not add an index without schema/workload/plan evidence.
- Do not benchmark only a synthetic path unrelated to production behavior.

## Verification

Compare before and after using the same workload/environment. Report absolute values, variability, query counts/plans, and any correctness/resource trade-offs. Re-run functional and race tests appropriate to the change.

Read `../../DATABASE_PERFORMANCE.md` and `../../CODE_QUALITY.md` for repository risks and gates.
