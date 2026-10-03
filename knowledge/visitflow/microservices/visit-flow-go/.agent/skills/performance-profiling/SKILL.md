---
name: performance-profiling
description: Use when optimizing Go or database performance, reducing CPU, memory, allocations, or latency, or investigating slow endpoints and throughput regressions.
---

# Performance Profiling

## Core Loop

`MEASURE -> IDENTIFY BOTTLENECK -> CHANGE -> MEASURE AGAIN`

Do not optimize from intuition alone when representative measurement is practical. A visibly repeated query may justify investigation, not an unsupported latency claim.

## Define the Problem

Before editing, record:

- affected operation and workload;
- latency/throughput/memory/CPU symptom and target;
- representative input size and concurrency;
- baseline measurement and environment;
- correctness and compatibility constraints.

Read `../../../AGENTS.md`, `../../DATABASE_PERFORMANCE.md`, and the affected code/tests. Apply `../gorm-quality/SKILL.md` and `../mysql-performance/SKILL.md` for DB-heavy paths.

## Go Evidence

Choose tools appropriate to the symptom:

- benchmarks for repeatable hot functions;
- CPU profiles for computation;
- heap/allocation profiles for memory pressure;
- goroutine, block, or mutex profiles for concurrency stalls;
- execution traces for scheduler/latency questions;
- `go test -race` for shared-state changes.

This repository has no established benchmark or pprof deployment workflow. Do not expose profiling endpoints in production without authentication, network, overhead, and data-sensitivity review.

## Database Evidence

Inspect generated SQL, query count, cardinality, indexes, `EXPLAIN`, and—when safe—`EXPLAIN ANALYZE`. Cleaner ORM code is not automatically faster SQL. Preserve transaction and tenant correctness.

## Change Rules

- Compare before and after using the same workload and environment.
- Prefer the smallest change addressing the measured bottleneck.
- Do not introduce goroutines merely because code is slow; first prove parallelism helps and bound/cancel/synchronize it.
- Do not trade readability for tiny theoretical gains.
- Do not trade atomicity, consistency, validation, authorization, or data integrity for speed.
- Treat cache introduction as a consistency/invalidation design change, not a free optimization.

## Repository Examples

- PREFERRED: batch lookup/upsert methods in `../../../repository/visit_customer_repository_impl.go` are candidates for query-count reductions when tests preserve behavior.
- LEGACY — INVESTIGATE: database calls inside loops in `../../../service/process_data_visit_service_impl.go` and parts of `../../../service/visit_service_impl.go` are N+1 candidates.
- ACCEPTABLE: current OpenTelemetry instrumentation can help locate spans, but instrumentation presence is not a baseline or proof of improvement.

## Completion Gate

- Report workload, baseline, bottleneck evidence, change, and after-result.
- Run functional regression tests and performance checks appropriate to the claim.
- If production-like measurement is unavailable, say “unverified hypothesis” and specify the next measurement; never say “should be faster” as a conclusion.
