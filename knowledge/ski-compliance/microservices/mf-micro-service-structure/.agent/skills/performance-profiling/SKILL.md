---
name: performance-profiling
description: Measure, profile, and benchmark runtime CPU, memory allocations, and query bottlenecks. Use when conducting performance investigations or resolving slow endpoints.
---

# Performance Profiling Skill

## Purpose
Provide reproducible, evidence-based performance measurement and profiling workflows.

## When to Use
Use when investigating latency regressions, CPU spikes, or memory allocations in batch operations.

## Workflow
1. **Understand**: Identify target endpoint or batch routine (e.g. `CreateDuplicate`, `FindMarketingStructureAllLevel`).
2. **Inspect**: Establish baseline latency and memory footprint using Go benchmarks (`testing.B`) or execution profiling.
3. **Plan**: Identify bottleneck (database roundtrips, reflection overhead in `helper.CreateHistory`, view joins).
4. **Implement**:
   - Optimize query shape, preload strategies, or slice allocations.
5. **Verify**:
   - Re-run benchmark to verify measurable improvement in latency / allocs per op.

## Hard Rules
- Never claim an optimization without before/after evidence.

## References
- [.agent/DATABASE_PERFORMANCE.md](../../DATABASE_PERFORMANCE.md)
