---
name: performance-profiling
description: Profile Go runtime CPU/memory allocations, identify database query bottlenecks, and benchmark critical code paths with reproducible baselines. Use whenever conducting performance profiling or benchmark evaluations.
---

# performance-profiling

Guides runtime CPU/memory profiling and query benchmarking in `mf-micro-service-discount-proposal`.

## Core References
- [DATABASE_PERFORMANCE.md](../../DATABASE_PERFORMANCE.md) — Query optimization rules, EXPLAIN plans.
- [QUALITY_GATES.md](../../QUALITY_GATES.md) — Performance evidence criteria.
- [GORM_BEST_PRACTICES.md](../../GORM_BEST_PRACTICES.md) — Memory allocation and batching.

## Standard Workflow
1. **Establish Baseline**:
   - Define the workload (e.g. generating discount proposal report with 5,000 rows).
   - Record baseline execution duration, memory allocation, and query count.
2. **Profile**:
   - Go benchmark profiling: `go test -bench=. -benchmem ./...`.
   - Database profiling: Execute `EXPLAIN ANALYZE` on long-running queries.
3. **Analyze Bottlenecks**:
   - Check for memory churn in reflection loops (`helper/history.go`, Excel generation in `service/`).
   - Check for full table scans in MySQL.
4. **Optimize & Compare**:
   - Apply localized improvements.
   - Run before/after benchmark comparison.

## Hard Guardrails
- **NEVER** claim performance improvements without reproducible before/after benchmark measurements.
- **NEVER** compromise correctness or transaction safety for memory/CPU micro-optimizations.
