# Engineering Documentation Index

## Required entry points

Read [repository rules](../AGENTS.md) and [evidence/limits](EVIDENCE.md), then choose the relevant task. Do not read every topic or run tests for every request.

| Task | Read |
| --- | --- |
| Actual numbers or records | [Data-first answers](../../.agent/DATA_ANSWERS.md), [authorized runner](../../.agent/DATA_ACCESS.md) |
| Feature existence / diagnosis | [Code investigation](../../.agents/skills/ski-code-investigation/SKILL.md), exact source/callers and schema |
| Feasibility / performance | [Analysis](../../.agent/ANALYSIS.md), affected query/index/transaction evidence |
| Documentation refresh | [Maintenance](MAINTENANCE.md), [evidence](EVIDENCE.md), [quality gates](QUALITY_GATES.md) |
| Testing requested | [Current source inventory and execution policy](TESTING.md) |


Welcome to the internal engineering guidance repository for `mf-micro-service-structure`. Use this index to route directly to authoritative documentation and skills based on your specific task.

## Recommended Reading Order

```text
AGENTS.md → .agent/INDEX.md → Task-Specific Document / Skill → Affected Module → Nearest Tests
```

---

## Documentation Directory

| Document | Topic & Scope | When to Read |
|---|---|---|
| [PROJECT.md](PROJECT.md) | Service overview, responsibilities, runtime environments, and external integrations | Onboarding or understanding system context |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Layer boundaries, dependency injection, request lifecycle, and transaction control | Modifying application structure or wiring new components |
| [CODE_STYLE.md](CODE_STYLE.md) | Idiomatic Go style, naming conventions, panic-recover patterns, and struct conventions | Writing or reviewing Go code |
| [CONSTRAINTS.md](CONSTRAINTS.md) | Mandatory constraints (`MUST`, `MUST NOT`, `SHOULD`, `INVESTIGATE FIRST`) | Before implementing features, schema changes, or refactoring |
| [DOMAIN.md](DOMAIN.md) | Marketing structure levels (Lv1-Lv6), offices, territory outlets/customers, closing periods | Writing or altering business logic |
| [DATABASE.md](DATABASE.md) | MySQL schema, tables, views, relations, soft deletes, and history audit table | Inspecting or altering persistence models |
| [GORM.md](GORM.md) | GORM v1.25 usage, queries, preloads, joins, zero-value updates, and anti-patterns | Modifying repositories, queries, or model tags |
| [API.md](API.md) | Gin routes, JWT authentication, request binding, validation, and JSON envelopes | Adding or changing HTTP endpoints and DTOs |
| [ERROR_HANDLING.md](ERROR_HANDLING.md) | Panic/recover flow, `PanicIfError`, custom error types, and HTTP status code mapping | Handling errors or changing exception rules |
| [TESTING.md](TESTING.md) | Test structure, existing tests, verification commands, and test gap analysis | Writing unit, integration, or regression tests |
| [WORKFLOWS.md](WORKFLOWS.md) | Step-by-step checklists for endpoints, business logic, query optimization, and schema | Executing common development tasks |
| [CHANGELOG.md](CHANGELOG.md) | Historical record of AI engineering guidance and rule evolution | Reviewing rule history or deprecations |
| [TECH_DEBT.md](TECH_DEBT.md) | Catalog of classified technical debt items with risk level and recommendations | Identifying debt or scoping refactoring tasks |
| [PREFERRED_PATTERNS.md](PREFERRED_PATTERNS.md) | Canonical patterns for new code vs legacy alternatives to avoid | Implementing new features or cleaning existing code |
| [REFACTORING.md](REFACTORING.md) | Migrate-when-touched methodology and safeguards against breaking changes | Refactoring or modernizing legacy code |
| [QUALITY_GATES.md](QUALITY_GATES.md) | Mandatory and conditional gates for compilation, linting, tests, security, and reviews | Prior to submitting or completing changes |
| [GO_BEST_PRACTICES.md](GO_BEST_PRACTICES.md) | Comprehensive Go rules for control flow, types, concurrency, and allocations | Writing high-quality Go code |
| [GORM_BEST_PRACTICES.md](GORM_BEST_PRACTICES.md) | GORM safety rules for transactions, updates, deletions, and associations | Working with database operations in GORM |
| [DATABASE_PERFORMANCE.md](DATABASE_PERFORMANCE.md) | MySQL query profiling, indexing, execution plans, and locking guidelines | Query optimization and performance tuning |
| [CODE_QUALITY.md](CODE_QUALITY.md) | Review checklist and Definition of Done for pull requests | Reviewing code changes |
| [SECURITY.md](SECURITY.md) | Trust boundaries, JWT auth, tenant isolation, SQL parameterization, and input safety | Performing security audits or handling sensitive flows |
| [OPTIMIZATION_REPORT.md](OPTIMIZATION_REPORT.md) | GORM and MySQL query optimization analysis and index recommendations | Performance tuning and query optimization |

---

## Agent Skills Routing Table

When assigned a task, invoke or follow the specialized skill below:

| Task Type | Relevant Skill | Primary Reference |
|---|---|---|
| Modifying or reviewing Go code | [go-quality](skills/go-quality/SKILL.md) | [GO_BEST_PRACTICES.md](GO_BEST_PRACTICES.md) |
| Changing GORM queries, updates, or transactions | [gorm-quality](skills/gorm-quality/SKILL.md) | [GORM_BEST_PRACTICES.md](GORM_BEST_PRACTICES.md) |
| Profiling queries, adding indexes, or tuning SQL | [mysql-performance](skills/mysql-performance/SKILL.md) | [DATABASE_PERFORMANCE.md](DATABASE_PERFORMANCE.md) |
| Changing database models, fields, or constraints | [database-schema](skills/database-schema/SKILL.md) | [DATABASE.md](DATABASE.md) |
| Database schema migrations or DDL changes | [migration-safety](skills/migration-safety/SKILL.md) | [CONSTRAINTS.md](CONSTRAINTS.md) |
| Adding or enhancing tests and assertions | [go-testing](skills/go-testing/SKILL.md) | [TESTING.md](TESTING.md) |
| Adding or modifying HTTP endpoints, DTOs, routes | [api-contract](skills/api-contract/SKILL.md) | [API.md](API.md) |
| Security review, auth checks, parameterization | [backend-security](skills/backend-security/SKILL.md) | [SECURITY.md](SECURITY.md) |
| Adding telemetry, metrics, traces, or structured logs | [observability](skills/observability/SKILL.md) | [ARCHITECTURE.md](ARCHITECTURE.md) |
| Bottleneck analysis, latency benchmarking | [performance-profiling](skills/performance-profiling/SKILL.md) | [DATABASE_PERFORMANCE.md](DATABASE_PERFORMANCE.md) |
| Dockerfile, container runtime, build optimization | [docker-production](skills/docker-production/SKILL.md) | `Dockerfile`, `docker-compose.yml` |
| CI/CD pipeline configuration, quality checks | [ci-quality-gate](skills/ci-quality-gate/SKILL.md) | `.gitlab-ci.yml`, `.golangci.yml` |
| Refactoring legacy code safely | [safe-refactoring](skills/safe-refactoring/SKILL.md) | [REFACTORING.md](REFACTORING.md) |
