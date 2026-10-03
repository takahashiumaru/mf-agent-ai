---
name: mysql-performance
description: Investigate and improve MySQL query, index, pagination, lock, or database-load performance with evidence. Use only when database performance is in scope.
---

# Mysql Performance

Use this skill when its trigger above matches the task. Start with the relevant repository guidance at `../../DATABASE_PERFORMANCE.md` and `.agent/INDEX.md`.

## Workflow

1. UNDERSTAND the workload and correctness contract.
2. INSPECT exact query, schema/indexes, cardinality, selectivity, and current call count.
3. PLAN a baseline using representative sparse/dense inputs and concurrency.
4. IMPLEMENT the smallest measured change.
5. TEST result equivalence and compare query count, rows, latency, locks, and pool pressure separately.
6. REVIEW write cost and operational rollout before proposing DDL.

## Hard rules

Do not propose an index from predicates alone. Verify server version before `EXPLAIN ANALYZE`; it executes the statement. Never run production DDL or risky explain operations without explicit authorization. Check scope predicates, empty filters, bounded batches, dynamic identifier allowlists, and first/deep pages.

## Verification and stop conditions

- Use fresh output from relevant tests, builds, static checks, query plans, or security-negative tests; do not claim checks passed when they were not run.
- Preserve current API, authorization, data-integrity, and side-effect contracts unless a behavior change is explicitly requested.
- Stop and ask for the missing owner/input when target schema, production access, migration policy, or required behavior is unclear. Continue independent read-only analysis.
- Keep changes scoped; inspect `git status` and review the diff before reporting completion.
