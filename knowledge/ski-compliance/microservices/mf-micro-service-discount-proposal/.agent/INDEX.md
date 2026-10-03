# .agent/INDEX.md — Documentation Index & Task Routing Table

## Fast task entry points

Read [repository rules](../AGENTS.md) and [current evidence](EVIDENCE.md) first. Then choose only the applicable row:

| Question | Entry point |
| --- | --- |
| Actual numbers or records | [Workspace data-first guide](../../.agent/DATA_ANSWERS.md) and [read-only access](../../.agent/DATA_ACCESS.md) |
| Feature existence or bug | [Shared code investigation](../../.agents/skills/ski-code-investigation/SKILL.md), exact route/callers, relevant schema |
| Feasibility or performance | [Analysis workflow](../../.agent/ANALYSIS.md), current query/index/transaction evidence |
| Source/model/schema differences | [Evidence](EVIDENCE.md), [workspace schema catalog](../../DATABASE_SCHEMA_CATALOG.md) |
| Verify or refresh documentation | [Maintenance](MAINTENANCE.md), [quality gates](QUALITY_GATES.md), [testing inventory](TESTING.md) |

The detailed catalog below is navigation, not a requirement to load every document or run tests for every task.

This directory contains deep-dive, evidence-based technical documentation for `mf-micro-service-discount-proposal`. AI agents and engineers should consult this index to find authoritative guidance for specific tasks without scanning the entire repository.

---

## 1. Recommended Reading Order

Always adhere to the standard discovery path:

```text
AGENTS.md (Root Overview)
   └──► .agent/INDEX.md (Routing Table)
           └──► .agent/<TOPIC>.md (Task-Specific Deep Dive)
                   └──► Target Package & Module Files
                           └──► Nearest Implementation Examples
                                   └──► Relevant Test Files
```

---

## 2. Task-to-Document Routing Table

| If your task is... | Read these documents first | Primary Code Locations |
| :--- | :--- | :--- |
| **Add a new REST API endpoint** | [API.md](API.md)<br>[ARCHITECTURE.md](ARCHITECTURE.md)<br>[WORKFLOWS.md](WORKFLOWS.md) | `route/`<br>`controller/`<br>`model/web/` |
| **Write or review Go code & error handling** | [GO_BEST_PRACTICES.md](GO_BEST_PRACTICES.md)<br>[CODE_STYLE.md](CODE_STYLE.md)<br>[ERROR_HANDLING.md](ERROR_HANDLING.md) | All `.go` files |
| **Modify business logic / proposal rules** | [DOMAIN.md](DOMAIN.md)<br>[CONSTRAINTS.md](CONSTRAINTS.md)<br>[ARCHITECTURE.md](ARCHITECTURE.md) | `service/`<br>`helper/` |
| **Write or optimize GORM / MySQL queries** | [GORM_BEST_PRACTICES.md](GORM_BEST_PRACTICES.md)<br>[DATABASE_PERFORMANCE.md](DATABASE_PERFORMANCE.md)<br>[GORM.md](GORM.md)<br>[DATABASE.md](DATABASE.md) | `repository/`<br>`model/domain/` |
| **Review security & trust boundaries** | [SECURITY.md](SECURITY.md)<br>[CONSTRAINTS.md](CONSTRAINTS.md) | `auth/`<br>`repository/`<br>`helper/` |
| **Refactor legacy code / address debt** | [TECH_DEBT.md](TECH_DEBT.md)<br>[PREFERRED_PATTERNS.md](PREFERRED_PATTERNS.md)<br>[REFACTORING.md](REFACTORING.md) | All packages |
| **Code review & Definition of Done verification**| [CODE_QUALITY.md](CODE_QUALITY.md)<br>[QUALITY_GATES.md](QUALITY_GATES.md)<br>[WORKFLOWS.md](WORKFLOWS.md) | All packages |
| **Implement or update Unit / Integration Tests** | [TESTING.md](TESTING.md)<br>[WORKFLOWS.md](WORKFLOWS.md) | `*_test.go`<br>`helper/operator_test.go` |
| **Alter database schema or entity structs** | [DATABASE.md](DATABASE.md)<br>[GORM.md](GORM.md)<br>[WORKFLOWS.md](WORKFLOWS.md) | `model/domain/`<br>`app/database/` |
| **Understand system dependencies & setup** | [PROJECT.md](PROJECT.md)<br>[ARCHITECTURE.md](ARCHITECTURE.md) | `main.go`<br>`configuration/`<br>`app/` |

---

## 3. Task-to-Skill Routing Table

| Task | Required Skill(s) |
| :--- | :--- |
| **Modify ordinary Go code** | [`go-quality`](skills/go-quality/SKILL.md) |
| **Change GORM query, model, or repository** | [`gorm-quality`](skills/gorm-quality/SKILL.md) (add [`mysql-performance`](skills/mysql-performance/SKILL.md) if performance is relevant) |
| **User-influenced queries or tenant-scoped access** | [`gorm-quality`](skills/gorm-quality/SKILL.md), [`backend-security`](skills/backend-security/SKILL.md) |
| **Change database schema or entity modeling** | [`database-schema`](skills/database-schema/SKILL.md), [`migration-safety`](skills/migration-safety/SKILL.md) |
| **Change HTTP API contract / routes / DTOs** | [`api-contract`](skills/api-contract/SKILL.md) |
| **Add or fix behavior with tests** | Relevant domain skill + [`go-testing`](skills/go-testing/SKILL.md) |
| **Review or address security vulnerabilities** | [`backend-security`](skills/backend-security/SKILL.md) |
| **Performance profiling & optimization** | [`performance-profiling`](skills/performance-profiling/SKILL.md), [`mysql-performance`](skills/mysql-performance/SKILL.md) |
| **Refactor without changing behavior** | [`safe-refactoring`](skills/safe-refactoring/SKILL.md) + affected technical skill |
| **Configure Docker / Container runtime** | [`docker-production`](skills/docker-production/SKILL.md) |
| **Configure CI/CD pipelines & release gates** | [`ci-quality-gate`](skills/ci-quality-gate/SKILL.md) |
| **Configure tracing, logging, observability** | [`observability`](skills/observability/SKILL.md) |

---

## 4. Documentation Catalog

1. **[PROJECT.md](PROJECT.md)**: High-level system architecture, service purpose, module inventory, configuration loading, and external integrations.
2. **[ARCHITECTURE.md](ARCHITECTURE.md)**: Detailed breakdown of the 5-layer pattern (`route` -> `controller` -> `service` -> `repository` -> `database`), request lifecycle, transaction boundaries, and side effects.
3. **[CODE_STYLE.md](CODE_STYLE.md)**: Concrete Go idioms observed in the repo, constructor naming conventions, interface implementations, mappers, pointer semantics, and formatting rules.
4. **[GO_BEST_PRACTICES.md](GO_BEST_PRACTICES.md)**: Standard Go engineering practices, panic/recovery error architecture, constructor injection, pointer vs value semantics, and concurrency guidelines.
5. **[CONSTRAINTS.md](CONSTRAINTS.md)**: Authoritative categorized rules (`MUST`, `MUST NOT`, `SHOULD`, `INVESTIGATE FIRST`) covering integrity, safety, transactions, and backward compatibility.
6. **[DOMAIN.md](DOMAIN.md)**: Domain language, Discount Proposal types (`SKI1`, `SKI2`, `DPL`, `DPF`, `DPL2`), Credit Notes, Customer Balances, hierarchies, state machines, and period lifecycle.
7. **[DATABASE.md](DATABASE.md)**: MySQL database schema specifications, composite primary keys, table relationships, audit columns, timestamp strategies, and soft delete variations.
8. **[GORM.md](GORM.md)**: GORM-specific guidelines, zero-value update caveats, preloading, joins, raw SQL scans, transaction helper usage, and anti-patterns.
9. **[GORM_BEST_PRACTICES.md](GORM_BEST_PRACTICES.md)**: Persistence standards, zero-value map updates, soft delete consistency, service-owned transaction rules, and parameterized joins.
10. **[DATABASE_PERFORMANCE.md](DATABASE_PERFORMANCE.md)**: Query optimization standards, composite index left-prefix matching, N+1 elimination, bounded scans, and lock duration rules.
11. **[SECURITY.md](SECURITY.md)**: Backend security standards, JWT authentication flow, tenant isolation, SQL injection prevention, SSRF controls, and secret protection.
12. **[API.md](API.md)**: Route declarations, JWT authentication flow, request binding, custom validator rules, query filters, standard response envelopes, and status codes.
13. **[ERROR_HANDLING.md](ERROR_HANDLING.md)**: Central panic/recover error architecture, custom exception types, database error mapping (duplicate/FK), and response serialization.
14. **[TESTING.md](TESTING.md)**: Existing test coverage baseline, verified test execution commands, mock strategies, and guidance for reaching high test coverage safely.
15. **[WORKFLOWS.md](WORKFLOWS.md)**: Step-by-step checklists for common engineering workflows (creating endpoints, modifying logic, tuning queries, bug fixes, schema changes).
16. **[TECH_DEBT.md](TECH_DEBT.md)**: Classified technical debt register with priority, evidence paths, failure modes, and remediation plans.
17. **[PREFERRED_PATTERNS.md](PREFERRED_PATTERNS.md)**: Recommended engineering patterns for new code and safe refactoring.
18. **[REFACTORING.md](REFACTORING.md)**: Safe migrate-when-touched refactoring workflows and guardrails for high-risk changes.
19. **[CODE_QUALITY.md](CODE_QUALITY.md)**: 10-dimension code review checklist and empirical Definition of Done.
20. **[QUALITY_GATES.md](QUALITY_GATES.md)**: Mandatory and conditional quality verification gates before completing work.
21. **[CHANGELOG.md](CHANGELOG.md)**: Historical record of AI engineering guidance updates, rule changes, and pattern deprecations.
