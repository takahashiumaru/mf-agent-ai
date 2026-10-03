---
name: mysql-performance
description: Diagnose slow queries, eliminate N+1 loop queries, analyze composite index left-prefix matching, and optimize MySQL execution plans with empirical evidence. Use whenever investigating or improving database performance.
---

# mysql-performance

Guides evidence-based MySQL query optimization and execution plan analysis in `mf-micro-service-discount-proposal`.

## Core References
- [DATABASE_PERFORMANCE.md](../../DATABASE_PERFORMANCE.md) — SARGable predicates, left-prefix indexing, N+1 elimination.
- [DATABASE.md](../../DATABASE.md) — Table indexes, compound keys, soft delete conventions.
- [TECH_DEBT.md](../../TECH_DEBT.md) — Known query and join pitfalls.

## Standard Workflow
1. **Baseline Measurement**:
   - Capture the exact SQL query and execution context.
   - Run `EXPLAIN` in MySQL to inspect `type`, `key`, `rows`, and `Extra` (`Using filesort`, `Using temporary`).
2. **Diagnose Bottlenecks**:
   - Check if queries are executed inside a Go `for` loop (N+1).
   - Check if composite indexes (e.g. `idx_discount_proposal`, `idx_cqrs_credit_notes`) are queried from left to right.
   - Check if list queries lack `.Limit(N)` or date/period bounds.
3. **Optimize with Restraint**:
   - Convert loop queries to batch `IN (?)` lookups or `.Joins()`.
   - Add bounds (`.Limit(100)` or pagination filters).
   - Rewrite non-SARGable WHERE conditions.
4. **Post-Optimization Verification**:
   - Measure query execution time and examined row counts before and after.
   - Verify result equivalence with characterization tests.

## Hard Guardrails
- **NEVER** recommend or add indexes based on speculative WHERE clauses without cardinality analysis and `EXPLAIN`.
- **NEVER** execute production DDL statements without explicit DBA authorization.
- **NEVER** sacrifice business correctness or data integrity for minor latency gains.
