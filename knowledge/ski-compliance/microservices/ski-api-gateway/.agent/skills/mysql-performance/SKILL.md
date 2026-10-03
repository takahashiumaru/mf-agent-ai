---
name: mysql-performance
description: Optimize MySQL queries, analyze indexes, and eliminate N+1 bottlenecks. Use when reviewing query latency, slow queries, or database indexing.
---

# MySQL Performance Skill

## Purpose & Trigger
Provide evidence-based query and index optimization for MySQL databases powering the SKI ecosystem.

## Workflow
1. **Understand**: Capture exact slow query SQL, parameters, and volume.
2. **Inspect**: Run `EXPLAIN` to inspect query plan, access types, keys examined, and filesort/temp table indicators.
3. **Plan**: Design index improvements adhering to the left-prefix rule or rewrite queries to remove N+1 loops.
4. **Implement**: Apply optimized query structure or create versioned migration scripts.
5. **Verify**: Compare before/after query execution plans and response latency.

## Hard Rules
- Never add speculative indexes without `EXPLAIN` evidence.
- Avoid unindexed leading wildcard searches (`LIKE '%val'`).
- Always bound queries with `LIMIT`.
