# 05 — Build Repository-Specific Agent Skills

## Purpose

Create a compact, progressively loaded skill system that guides future agents through safe Go, GORM, MySQL, API, security, testing, observability, Docker, CI, and refactoring work.

Run this prompt only after prompts `01` through `04` have produced an evidence-based knowledge base and preferred engineering standards.

## Role

Act as a maintainer of AI engineering instructions. Convert established repository guidance into task-oriented skills; do not invent repository behavior and do not modify application code.

## Authorized outputs

Create or update:

```text
.agent/skills/go-quality/SKILL.md
.agent/skills/gorm-quality/SKILL.md
.agent/skills/mysql-performance/SKILL.md
.agent/skills/database-schema/SKILL.md
.agent/skills/migration-safety/SKILL.md
.agent/skills/go-testing/SKILL.md
.agent/skills/api-contract/SKILL.md
.agent/skills/backend-security/SKILL.md
.agent/skills/observability/SKILL.md
.agent/skills/performance-profiling/SKILL.md
.agent/skills/docker-production/SKILL.md
.agent/skills/ci-quality-gate/SKILL.md
.agent/skills/safe-refactoring/SKILL.md
.agent/INDEX.md
AGENTS.md
.agent/CHANGELOG.md
```

Detailed supporting material may be placed under each skill's `references/` directory when necessary. Preserve useful existing content.

These 13 topics are a capability checklist, not a requirement to generate 13 files for every repository. Create only skills supported by actual tooling and distinct workflows; record omitted topics and reasons. More skills are not automatically better: overlap increases context cost and conflicts. Write all guidance in English.

`.agent/skills/` is this pack's documentation convention, not a universally auto-discovered agent skill directory. Detect the target agent's supported discovery mechanism. Use explicit routing from `AGENTS.md` when automatic discovery is unavailable; do not claim installation or activation merely because files exist. Resolve each relative reference from its containing document and validate the target.

## Required inputs

Read before writing skills:

- `AGENTS.md` and `.agent/INDEX.md`;
- `.agent/ARCHITECTURE.md`, `.agent/CODE_STYLE.md`, and `.agent/CONSTRAINTS.md`;
- `.agent/PREFERRED_PATTERNS.md`, `.agent/TECH_DEBT.md`, and `.agent/REFACTORING.md`;
- `.agent/GO_BEST_PRACTICES.md` and `.agent/GORM_BEST_PRACTICES.md`;
- `.agent/DATABASE.md` and `.agent/DATABASE_PERFORMANCE.md`;
- `.agent/API.md`, `.agent/TESTING.md`, and `.agent/QUALITY_GATES.md`.
- `.agent/SECURITY.md` for trust boundaries, security requirements and negative tests.

If a required input is absent, stop and report it instead of manufacturing guidance.

## Skill design contract

Every `SKILL.md` must:

1. use valid YAML frontmatter;
2. use a lowercase kebab-case name matching its directory;
3. state both what the skill does and when it must be used;
4. remain concise and action-oriented, preferably 50–150 lines;
5. route to only the references needed for a specific task;
6. contain a workflow, hard rules, verification, and stop/escalation conditions;
7. reference repository-relative paths;
8. distinguish verified repository rules from general recommendations;
9. avoid duplicating large sections of source documents;
10. never contain secrets, absolute machine paths, or unverifiable claims.

Use frontmatter like:

```yaml
---
name: gorm-quality
description: Review and modify GORM reads, writes, associations, and transactions safely. Use whenever a task changes GORM models, repositories, SQL behavior, or transaction flow.
---
```

## Shared workflow

Every coding-oriented skill must enforce:

```text
UNDERSTAND → INSPECT → PLAN → IMPLEMENT → TEST → REVIEW
```

Before implementation, require the agent to identify:

- current and desired behavior;
- affected layers, callers, and side effects;
- data, transaction, API, security, and migration risk;
- relevant preferred examples and tests;
- the smallest safe change and its verification.

Best practice is not permission for unrelated refactoring.

## Skill requirements

### `go-quality`

Use for any Go code change or review. Cover simplicity, errors, context, interfaces, constructors, packages, concurrency, allocation awareness, formatting, and repository-specific legacy boundaries.

### `gorm-quality`

Use for GORM models, repositories, queries, writes, associations, or transactions. Cover context, errors, transaction reuse, `Save`, zero-value updates, write whitelisting, preload/joins, N+1, raw SQL, scopes, hooks, soft delete, and rows affected.

Create focused references for transactions, updates, relationships, or performance only when the core skill would otherwise become too large.

### `mysql-performance`

Use when query performance, indexes, locks, pagination, aggregation, or database load is in scope. Require query evidence, existing-index inspection, data distribution, `EXPLAIN`, write-cost analysis, and before/after measurement. Prohibit speculative indexes and production DDL without authorization.

Require checks for tenant predicates, dynamic identifier allowlists, empty filters, batch bounds and result equivalence. Define query count, p50/p95 latency, rows examined/returned, lock waits and connection-pool pressure as separate measurements when available. Include selective and broad inputs, sparse/dense tenants, first/deep pages and realistic concurrency. Preserve atomicity, cancellation and required locks. Route operative details to `.agent/DATABASE_PERFORMANCE.md`; a query-only change does not require a schema migration.

### `database-schema`

Use for models, tables, columns, keys, indexes, types, nullability, or constraints. Require schema-source-of-truth checks, GORM-tag alignment, compatibility analysis, and explicit migration impact.

### `migration-safety`

Use for any schema or data migration. Cover expand/migrate/contract sequencing, large-table risk, online DDL capability, defaults/nullability, backfill batching, deploy order, rollback/forward-fix strategy, and the repository's AutoMigrate policy.

### `go-testing`

Use when adding or changing behavior or tests. Cover test level selection, table-driven cases, deterministic dependencies, mocks/fakes consistent with the repository, database isolation, regression tests, race checks, and exact verified commands.

### `api-contract`

Use for routes, handlers/controllers, DTOs, validation, authentication, status codes, response envelopes, pagination, filtering, or public error behavior. Require backward-compatibility and consumer-impact review.

### `backend-security`

Use for auth, authorization, validation, SQL, files, outbound requests, secrets, sensitive logs, or dependencies. Cover parameterization, ownership checks, least privilege, secret handling, SSRF/path risks when relevant, and avoid claiming a full security audit from a narrow review.

Route to `.agent/SECURITY.md`. Require tracing untrusted input to sensitive operations, verifying object/action-level authorization, and testing denied cases as well as valid requests. Cover mass assignment, SQL identifier injection, resource exhaustion and relevant token/session validation. Report severity, confidence, path/symbol, exploit preconditions, affected scope, smallest fix and verification gap. Use synthetic local fixtures; do not actively attack production or expose secrets. Security-relevant behavior changes need explicit fix scope; discovery alone is not authorization.

Keep these existing security/performance skills focused instead of adding duplicate skills. Both are required capabilities for a Go/GORM/MySQL backend with API and database access; explain any genuinely inapplicable capability rather than silently omitting it.

### `observability`

Use for logs, metrics, traces, correlation IDs, slow queries, and background jobs. Define signal ownership, cardinality limits, sensitive-data rules, error-status recording, and repository-supported instrumentation.

### `performance-profiling`

Use when runtime or database performance is an explicit goal. Require a reproducible baseline, appropriate profiler/benchmark/query-plan evidence, bottleneck identification, controlled change, and before/after comparison.

### `docker-production`

Use for Dockerfile, image, container runtime, or deployment-container changes. Cover reproducible/multi-stage builds where compatible, cache use, minimal runtime, non-root execution, signal handling, health checks, secrets, `.dockerignore`, certificates/timezone needs, and image verification.

### `ci-quality-gate`

Use for CI configuration or release gates. Derive commands from repository tooling. Separate mandatory from conditional gates, preserve useful failure output, use safe caching, and avoid making flaky or unavailable tools unconditional without a rollout plan.

### `safe-refactoring`

Use when behavior should remain stable. Require characterization, callers/side-effects inspection, incremental edits, test protection, diff review, and rollback awareness. Route large cross-module, API, schema, or dependency changes to dedicated plans.

## Skill routing

Update `.agent/INDEX.md` with a task-to-skill table. Route narrowly:

| Task | Required skill(s) |
|---|---|
| Modify ordinary Go code | `go-quality` |
| Change GORM query or model | `gorm-quality`; add `mysql-performance` when performance is relevant |
| Change user-influenced queries or tenant-scoped access | `gorm-quality`, `backend-security`; add `mysql-performance` for performance work |
| Change schema | `database-schema`, `migration-safety` |
| Change HTTP contract | `api-contract` |
| Add/fix behavior | relevant domain skill plus `go-testing` |
| Security-sensitive change | `backend-security` |
| Performance investigation | `performance-profiling` plus relevant Go/MySQL skill |
| Refactor without behavior change | `safe-refactoring` plus affected technical skill |

Do not require every skill for every task.

## Validation

Before finishing:

1. Confirm every skill has valid frontmatter and a unique matching name.
2. Check descriptions clearly state trigger conditions.
3. Check links and referenced paths exist.
4. Search for contradictions, placeholders, duplicated bulk content, secrets, and absolute paths.
5. Confirm dangerous operations include authorization and stop conditions.
6. Confirm each skill defines fresh verification evidence.
7. Review the diff and update `.agent/CHANGELOG.md`.

## Mandatory post-generation audit

After generating the skills, audit `AGENTS.md`, `.agent/INDEX.md`, and every `.agent/skills/*/SKILL.md` before considering the system complete. Check for:

- duplicated or conflicting rules;
- vague, generic, or unsupported guidance;
- missing repository-specific examples;
- incorrect architectural assumptions;
- overly long skill files or weak trigger descriptions;
- overlapping skill responsibilities;
- missing routing in `.agent/INDEX.md`;
- guidance that encourages blind refactoring or optimization;
- rules that could accidentally change business behavior;
- missing Go, GORM, MySQL, migration, API, security, testing, or CI safeguards;
- legacy examples incorrectly presented as preferred patterns.

Simplify rather than adding more skills. The final routing must remain:

```text
AGENTS.md
→ .agent/INDEX.md
→ classify the task
→ load only relevant skills
→ inspect affected code and tests
→ plan
→ implement
→ test and apply proportional quality gates
```

The audit must preserve this priority:

```text
correctness → data integrity → security → business compatibility → maintainability → measured performance
```

Architectural purity is not a goal by itself.

## Completion report

Report:

- skills created or updated;
- routing added;
- reference files added and why;
- repository patterns encoded;
- dangerous or legacy patterns guarded against;
- validation actually performed;
- duplicated/conflicting guidance removed during the post-generation audit;
- unresolved areas requiring human confirmation.

## Next step

After the skill system is validated, use `06_OPTIMIZE_GORM_MYSQL.md` only for an explicitly authorized optimization task.
