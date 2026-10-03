# Database performance guidance

> Apply [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) before this detailed topic. Older prescriptions are preferred patterns, not proof every existing path follows them. Preserve actual API/file/proxy contracts and transaction ownership. Historical passed/coverage claims are not current verification; run application tests only when requested.

The module declares GORM and a MySQL driver. Deployed MySQL version, schema cardinality, authoritative schema source, and production workload are **Needs investigation**.

## Evidence before changes

1. Capture exact SQL shape, redacted parameters, call count, result cardinality, and endpoint path.
2. Inspect authoritative schema/indexes, table sizes, selectivity, scope distribution, and write frequency.
3. Establish a safe, reproducible baseline on representative sparse/dense inputs and concurrency.
4. Compare plan estimates with runtime evidence. `EXPLAIN ANALYZE` executes a statement and is only available on supported server versions; verify version and statement safety first.
5. Compare result equivalence, query count, rows examined/returned, latency percentiles, lock waits, and pool pressure separately.

## Query review

- Look for N+1 calls and database operations inside loops.
- Preserve scope predicates; check empty filters and user-controlled SQL identifiers.
- Check indexable predicates and implicit conversions against the actual plan.
- For composite-index proposals, inspect left-prefix use, selectivity, existing overlap, and write/storage cost. Never infer an index from `WHERE` alone.
- Bound results. Use keyset pagination only when public order and cursor semantics can remain compatible.
- Review join fanout, aggregation, filesort/temp tables, large `IN` lists, and transaction duration.
- Measure pool configuration from actual settings/runtime, not assumptions.

References: MySQL [EXPLAIN](https://dev.mysql.com/doc/refman/8.0/en/explain.html) and [index use](https://dev.mysql.com/doc/refman/8.0/en/mysql-indexes.html). Confirm the deployed version first.
