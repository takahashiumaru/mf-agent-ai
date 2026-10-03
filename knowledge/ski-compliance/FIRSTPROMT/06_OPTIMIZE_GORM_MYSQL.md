# 06 — Optimize GORM and MySQL Safely

## Purpose

Provide an evidence-driven workflow for aligning GORM models with MySQL schema and optimizing queries or indexes without changing business behavior or API contracts.

This prompt is not blanket authorization to modify production databases. Run it only for a clearly scoped optimization request after prompts `01` through `05` are established.

## Role

Act as a senior Go/GORM performance engineer and MySQL DBA. Prioritize correctness, data integrity, security, compatibility, and measurable evidence over speculative speedups.

## Required task inputs

Before acting, identify or request:

- exact slow endpoint, job, query, or model mismatch;
- target environment and whether access is read-only;
- relevant MySQL version and table sizes;
- acceptable maintenance/locking window;
- performance baseline and success metric;
- authorization boundary for code, migration, staging, and production changes.

Write in English. Continue authorized local code changes and isolated verification without requiring production DDL/DML or deployment permission. Missing production authorization blocks only those external operations. If the request is analysis-only, deliver findings and a concrete proposal without editing application code.

## Non-breaking constraints

1. Preserve business rules, validation behavior, ordering, null semantics, and response JSON unless explicitly requested otherwise.
2. Do not drop or destructively alter tables, columns, indexes, constraints, or data without separate explicit authorization.
3. Keep runtime production AutoMigrate disabled unless the repository explicitly establishes a different policy.
4. Parameterize user-influenced values; never build SQL by concatenating untrusted input.
5. Do not add indexes based only on column names or a `WHERE` clause.
6. Do not claim an optimization without a comparable before/after measurement.
7. Do not copy production data or secrets into logs, prompts, fixtures, or reports.
8. Use repository migrations or reviewed DDL artifacts; do not make undocumented manual schema changes.

## Workflow

### Phase 1 — Understand and baseline

1. Read `AGENTS.md`, `.agent/INDEX.md`, and relevant GORM, database, performance, migration, testing, and changelog guidance.
2. Trace the request from handler to database and identify all callers and side effects.
3. Capture the exact generated SQL and bound-value shapes without exposing sensitive values.
4. Record latency distribution, call frequency, rows examined/returned, data volume, timeout/error rate, and database load when available.
5. Reproduce with representative data in a safe environment where possible.

No baseline means the work is an investigation, not a verified optimization.

Use the same fixtures, parameters, concurrency, cache conditions, and environment for comparisons. Record query count separately from latency and CPU/memory measurements. A lower query count proves fewer round trips, not automatically lower endpoint latency.

### Phase 2 — Check schema/model alignment

Compare the authoritative schema with relevant GORM structs:

- table and column names;
- data types, widths, precision, signedness, and collation;
- primary, unique, and foreign keys;
- nullable/default/generated behavior;
- timestamps and soft-delete columns;
- read-only computed/join fields;
- associations and explicit tags.

Do not automatically add every database column to a Go struct. Add fields only when application behavior needs them. Use read-only tags for selected/computed fields only after verifying GORM behavior and write paths.

Treat schema changes and model-mapping changes as separate risks even when delivered together.

### Phase 3 — Analyze the query

Inspect:

- missing predicates or unbounded results;
- N+1 database calls;
- non-SARGable functions or implicit type conversions;
- unsafe dynamic SQL;
- excessive columns, preloads, joins, or duplicate rows;
- large offsets or unstable ordering;
- unnecessary counts, sorting, aggregation, or repeated queries;
- long transactions, locking, and base-DB use inside a transaction.

Prefer the smallest query-shape correction before adding an index.

Before accepting a rewrite, verify these failure-prone cases:

- Removing joins must preserve aggregates when the remaining join is filtered; joined-member counts can change even when unfiltered examples match.
- Batching must preserve input order, duplicate handling, missing-key errors, tenant/period composite keys, and write/notification order. Chunk large key sets and handle empty input explicitly.
- Date ranges must retain database session timezone, timestamp type, fractional seconds, inclusive/exclusive boundaries, and accepted input formats. A fixed UTC offset is not a universal timezone rule.
- Removing a repeated GORM query requires inspecting statement reuse and execution order; do not assume the second query is unfiltered or side-effect-free.
- Moving `Limit`, changing `Find`/`First`, narrowing selected columns, or adding pagination can change results or errors. Preserve association keys and the existing public contract.
- Adding model fields or changing tags can affect inserts, updates, defaults, hooks, and uniqueness even without an active migration.

Do not promise zero locks. Writes require database locking, ordinary reads can encounter metadata waits, and removing locks may break correctness. Measure lock wait, transaction duration, deadlocks, and connection-pool pressure under representative concurrency. `EXPLAIN ANALYZE` executes the statement; use it only on a verified safe query/environment. Preserve required locking and atomicity.

### Security invariants for every query change

Keep authorization predicates on all read/write/count/export paths, including joins, subqueries and batch operations. Test cross-tenant IDs, empty key sets and malicious filter/sort inputs. Bind values; use a closed allowlist for dynamic column/table/order expressions because value placeholders do not authorize arbitrary SQL fragments. Preserve update-field allowlists and prohibit accidental global writes.

Do not trade access checks, transaction atomicity, required locking, or data visibility for speed. A new cache must include relevant tenant/permission scope and have an explicit freshness/invalidation policy. Caching or introducing replicas can change results and requires its own compatibility evidence.

### Representative performance evidence

Compare selective and broad filters, sparse and dense tenants, empty and large result sets, and pagination extremes relevant to actual use. Record dataset scale, parameter shapes, indexes, MySQL version, concurrency, warm/cold cache conditions, run count and measurement variance. Collect p50/p95 latency, throughput, query count, examined/returned rows, errors/timeouts, lock waits and pool waits as available. Select concrete success and regression limits from the task/workload; do not invent universal latency targets.

When batching, bound chunk sizes and parameter counts; when reducing round trips, check added memory and database work. Evaluate full endpoint cost rather than only one SQL statement. Avoid unbounded goroutines, speculative pool increases, forced indexes or isolation reductions. Do not replace contractual offset pagination with cursors without an approved API change.

### Phase 4 — Analyze indexes and execution plans

Collect:

- `SHOW CREATE TABLE`;
- existing indexes and their column order;
- approximate cardinality/selectivity and data distribution;
- production-safe `EXPLAIN`, or `EXPLAIN ANALYZE` only when supported and safe;
- rows estimate, access type, chosen key, key length, filtered percentage, temporary table, and filesort indicators;
- read benefit versus insert/update/delete and storage cost.

For a candidate composite index, justify:

- equality, range, join, grouping, and ordering columns;
- left-prefix usability;
- overlap with existing indexes;
- soft-delete/low-selectivity column placement;
- index width and write amplification;
- rollout and removal plan.

Verify MySQL-version support before using syntax such as `IF NOT EXISTS`, online DDL algorithms, invisible indexes, functional indexes, or descending indexes.

### Phase 5 — Propose the smallest safe change

Present separate options where applicable:

1. query/model-only change;
2. additive index or schema migration;
3. combined change with safe deploy order.

For each option include expected benefit, compatibility risk, lock/write impact, migration duration estimate basis, rollback or forward-fix plan, and verification.

Obtain required user/DBA approval before state-changing database operations.

### Phase 6 — Implement within authorization

When authorized:

- keep code changes focused;
- preserve transaction ownership and audit/ETL behavior;
- use safe GORM updates for zero values;
- create versioned/idempotent migration behavior compatible with repository tooling;
- consider expand → deploy → backfill → verify → contract for compatibility-sensitive schema work;
- batch and throttle large backfills;
- avoid long locks and peak traffic windows;
- update `.agent/CHANGELOG.md` only if the work materially changes engineering guidance; use the repository's application release-note mechanism for ordinary code/schema delivery when one exists.

Never execute production DDL merely because a migration file was prepared.

### Phase 7 — Verify

Run the repository-supported subset relevant to the change:

- formatting;
- targeted unit/integration/regression tests;
- full test suite when proportional;
- `go vet` and configured linting;
- build or compile check;
- migration validation in a safe environment;
- before/after query plan and performance comparison;
- API response and result-set equivalence;
- lock, error-rate, and resource monitoring during authorized rollout.

Report exact commands and actual results. Do not state `passed`, `safe`, `identical`, or `optimized` without current evidence.

## Required optimization report

Use this structure:

```markdown
# Optimization Report: <scope>

## Authorization and environment
## Current behavior and baseline
## Evidence and root cause
## Options considered
## Selected change
## Query/model changes
## Migration or index DDL
## Deploy order
## Rollback or forward-fix plan
## Verification results
## Residual risks and monitoring
```

Keep reusable instructions separate from the report of a specific execution. Historical results must include the date, environment, evidence source, and commands actually run.

## Stop conditions

Apply these conditions only to the affected operation. Continue independent authorized analysis, tests, and local changes. Do not require migration/rollback artifacts for a query-only change; mark inapplicable checklist items with a reason.

Stop and request direction when:

- production write/DDL authorization is missing;
- schema source of truth is unclear;
- query results cannot be shown equivalent;
- MySQL version/capability is unknown for proposed DDL;
- lock or table-size risk cannot be bounded;
- rollback/forward-fix strategy is absent;
- unrelated business-logic changes are required;
- evidence contradicts the proposed optimization.

## Completion criteria

- [ ] Scope and authorization are explicit.
- [ ] Baseline and root cause are documented.
- [ ] Schema/model comparison uses authoritative evidence.
- [ ] Existing indexes and execution plan were inspected.
- [ ] Compatibility and transaction behavior are preserved.
- [ ] Migration, deployment, and rollback/forward-fix are defined.
- [ ] Relevant tests and performance checks ran successfully.
- [ ] Relevant documentation is updated; `.agent/CHANGELOG.md` is changed only when engineering guidance changed.
- [ ] Residual risk and production monitoring are stated.

If any required criterion is unmet, report the task as incomplete or analysis-only rather than claiming success.

## Official references

- [MySQL EXPLAIN reference](https://dev.mysql.com/doc/refman/8.4/en/explain.html): use the manual matching the target server version and distinguish estimated plans from execution measurements.
- [GORM security](https://gorm.io/docs/security.html): preserve value parameterization and guard dynamic SQL fragments during optimization.
