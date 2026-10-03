---
name: performance-profiling
description: Use when profiling execution bottlenecks, analyzing slow sales calculations, evaluating memory footprint, and tuning query latency.
---

# Performance Profiling Skill

## Guidelines
1. **Identify Slow Calculations**: Profile CPU and memory hotspots in complex calculations ([service/sales_ff_service_impl.go](../../../service/sales_ff_service_impl.go)).
2. **Measure First**: Verify with execution plans and latency measurements before refactoring working code.
3. **Database Joins**: Ensure heavy reports leverage database grouping and indexing instead of pulling unindexed rows into memory.

See [.agent/DATABASE_PERFORMANCE.md](../../DATABASE_PERFORMANCE.md).
