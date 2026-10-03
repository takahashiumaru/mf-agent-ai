---
name: mysql-performance
description: Profile, optimize, and verify MySQL query performance, indexes, and execution plans with evidence. Use whenever analyzing slow queries, adding indexes, or tuning SQL views.
---

# MySQL Performance Skill

## Purpose
Guide evidence-based query optimization and index design for MySQL database tables and views.

## When to Use
Use when query latency is high, analyzing large multi-level hierarchy scans, or proposing index migrations.

## Workflow
1. **Understand**: Capture the exact slow query and parameter shape.
2. **Inspect**: Inspect existing table indexes (`SHOW CREATE TABLE`) and data distribution.
3. **Plan**: Formulate the smallest safe query rewrite or composite index addition.
4. **Implement**:
   - Rewrite queries to avoid N+1 loops and unbounded scans.
   - For candidate indexes, ensure left-prefix alignment with `(period, ...)`.
5. **Verify**:
   - Run `EXPLAIN` to confirm index access type (`ref`/`range`) and rows examined.
   - Measure before and after execution latency.

## Hard Rules
- No speculative indexes based solely on a `WHERE` clause without `EXPLAIN` evidence.
- No production DDL execution without explicit user/DBA authorization.

## References
- [.agent/DATABASE_PERFORMANCE.md](../../DATABASE_PERFORMANCE.md)
- [.agent/DATABASE.md](../../DATABASE.md)
