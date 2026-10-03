---
name: performance-profiling
description: Measure and profile gateway latency, memory allocations, and proxy throughput. Use when diagnosing latency spikes or throughput bottlenecks.
---

# Performance Profiling Skill

## Purpose & Trigger
Provide rigorous profiling methodology for CPU, memory, and latency bottlenecks in `ski-api-gateway`.

## Workflow
1. **Understand**: Define baseline metrics (p50/p95 latency, requests per second).
2. **Inspect**: Use Go `pprof` or benchmarking tools (`go test -bench`) to identify hot paths.
3. **Plan**: Target identified memory allocations or synchronous file/disk bottlenecks.
4. **Implement**: Apply optimizations (e.g., in-memory caching, connection reuse).
5. **Verify**: Compare before/after throughput and CPU/memory profiles under equal test loads.

## Hard Rules
- Always produce measurable benchmark evidence before and after optimization.
