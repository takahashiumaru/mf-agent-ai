# Agent Knowledge Base Index

## Required entry points

Read [repository rules](../AGENTS.md) and [evidence/limits](EVIDENCE.md), then choose the relevant task. Do not read every topic or run tests for every request.

| Task | Read |
| --- | --- |
| Actual numbers or records | [Data-first answers](../../.agent/DATA_ANSWERS.md), [authorized runner](../../.agent/DATA_ACCESS.md) |
| Feature existence / diagnosis | [Code investigation](../../.agents/skills/ski-code-investigation/SKILL.md), exact source/callers and schema |
| Feasibility / performance | [Analysis](../../.agent/ANALYSIS.md), affected query/index/transaction evidence |
| Documentation refresh | [Maintenance](MAINTENANCE.md), [evidence](EVIDENCE.md), [quality gates](QUALITY_GATES.md) |
| Testing requested | [Current source inventory and execution policy](TESTING.md) |


This routing directory helps AI coding agents find the exact context required for any task without scanning the whole repository.

## Documentation Index

| Category | Documentation File | Description |
| :--- | :--- | :--- |
| **Project & Architecture** | [.agent/PROJECT.md](PROJECT.md) | Business purpose, modules, configuration, and external systems |
| | [.agent/ARCHITECTURE.md](ARCHITECTURE.md) | Layer responsibilities, dependency flow, request lifecycle, DI |
| | [.agent/DOMAIN.md](DOMAIN.md) | Sales FF, Sales Distributor, Bridging, Closings, and State rules |
| **Coding & Quality** | [.agent/CODE_STYLE.md](CODE_STYLE.md) | Go conventions, naming, interfaces, constructors, and pointers |
| | [.agent/GO_BEST_PRACTICES.md](GO_BEST_PRACTICES.md) | Idiomatic Go standards, flat control flow, error guidelines |
| | [.agent/GORM_BEST_PRACTICES.md](GORM_BEST_PRACTICES.md) | Safe GORM update strategies, zero-value handling, transaction rules |
| | [.agent/CODE_QUALITY.md](CODE_QUALITY.md) | Code review checklist, non-overengineering principles |
| | [.agent/SECURITY.md](SECURITY.md) | Trust boundaries, JWT verification, SQL parameterization, secrets |
| | [.agent/QUALITY_GATES.md](QUALITY_GATES.md) | Definition of Done and gate criteria for proposed changes |
| **Patterns & Refactoring** | [.agent/PREFERRED_PATTERNS.md](PREFERRED_PATTERNS.md) | Gold standard layered patterns, implementation templates |
| | [.agent/TECH_DEBT.md](TECH_DEBT.md) | Known technical debt, legacy patterns, and risk matrix |
| | [.agent/REFACTORING.md](REFACTORING.md) | Safe incremental refactoring guidelines and boundaries |
| **Database & API** | [.agent/DATABASE.md](DATABASE.md) | MySQL schema details, composite keys, indexing, and auditing |
| | [.agent/DATABASE_PERFORMANCE.md](DATABASE_PERFORMANCE.md) | MySQL performance optimization, index order, N+1 prevention |
| | [.agent/GORM.md](GORM.md) | Query conventions, transactions, Preload vs Joins, Updates |
| | [.agent/API.md](API.md) | Gin routes, handlers, DTO validation, `WebResponse`, and Auth |
| | [.agent/ERROR_HANDLING.md](ERROR_HANDLING.md) | Panic-recover error mapping, MySQL error decoding, status codes |
| **Operations & History** | [.agent/TESTING.md](TESTING.md) | Test structure, test running commands, and test conventions |
| | [.agent/WORKFLOWS.md](WORKFLOWS.md) | Step-by-step guides for new endpoints, updates, bugs, and queries |
| | [.agent/CONSTRAINTS.md](CONSTRAINTS.md) | MUST / MUST NOT rules, invariants, and safety boundaries |
| | [.agent/CHANGELOG.md](CHANGELOG.md) | **Mandatory Agent Commit & Evolution Changelog** |

---

## Repository Engineering Skills (`.agent/skills/`)

| Skill | Path | Description |
| :--- | :--- | :--- |
| `go-quality` | [.agent/skills/go-quality/SKILL.md](skills/go-quality/SKILL.md) | Idiomatic Go, error handling, struct conventions |
| `gorm-quality` | [.agent/skills/gorm-quality/SKILL.md](skills/gorm-quality/SKILL.md) | GORM query safety, zero-value updates, transactions |
| `mysql-performance` | [.agent/skills/mysql-performance/SKILL.md](skills/mysql-performance/SKILL.md) | Query performance, composite index utilization |
| `database-schema` | [.agent/skills/database-schema/SKILL.md](skills/database-schema/SKILL.md) | Schema design, composite primary keys, audit fields |
| `migration-safety` | [.agent/skills/migration-safety/SKILL.md](skills/migration-safety/SKILL.md) | Safe schema migrations without runtime AutoMigrate |
| `go-testing` | [.agent/skills/go-testing/SKILL.md](skills/go-testing/SKILL.md) | Table-driven testing and execution commands |
| `api-contract` | [.agent/skills/api-contract/SKILL.md](skills/api-contract/SKILL.md) | Gin routes, DTOs, WebResponse envelope, validation |
| `backend-security` | [.agent/skills/backend-security/SKILL.md](skills/backend-security/SKILL.md) | JWT auth, SQL injection prevention, validation |
| `observability` | [.agent/skills/observability/SKILL.md](skills/observability/SKILL.md) | OpenTelemetry tracer, slow query logging |
| `performance-profiling` | [.agent/skills/performance-profiling/SKILL.md](skills/performance-profiling/SKILL.md) | Performance profiling and calculation optimization |
| `docker-production` | [.agent/skills/docker-production/SKILL.md](skills/docker-production/SKILL.md) | Production Dockerfile, deploy.sh, resource limits |
| `ci-quality-gate` | [.agent/skills/ci-quality-gate/SKILL.md](skills/ci-quality-gate/SKILL.md) | GitLab CI/CD stages and static analysis linters |
| `safe-refactoring` | [.agent/skills/safe-refactoring/SKILL.md](skills/safe-refactoring/SKILL.md) | Incremental refactoring and technical debt reduction |
| `go-gorm-clean-code` | [.agent/skills/go-gorm-clean-code/SKILL.md](skills/go-gorm-clean-code/SKILL.md) | Clean-code refactoring for Go and GORM without changing business behavior |

---

## Recommended Agent Workflow

```
1. AGENTS.md (High-level map & critical rules)
     ↓
2. .agent/INDEX.md (Locate domain/task documentation or skill)
     ↓
3. Task-specific .agent/ doc or skill (Read rules & patterns)
     ↓
4. Target module files in route/, controller/, service/, repository/, model/
     ↓
5. Inspect nearest reference implementation
     ↓
6. Implement minimal changes & verify with tests/linter
     ↓
7. Record changes into .agent/CHANGELOG.md before commit/push!
```
