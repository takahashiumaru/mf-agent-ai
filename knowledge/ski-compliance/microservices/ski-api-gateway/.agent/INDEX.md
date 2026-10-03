# .agent/INDEX.md

## Required entry points

Read [repository rules](../AGENTS.md) and [evidence/limits](EVIDENCE.md), then choose the relevant task. Do not read every topic or run tests for every request.

| Task | Read |
| --- | --- |
| Actual numbers or records | [Data-first answers](../../.agent/DATA_ANSWERS.md), [authorized runner](../../.agent/DATA_ACCESS.md) |
| Feature existence / diagnosis | [Code investigation](../../.agents/skills/ski-code-investigation/SKILL.md), exact source/callers and schema |
| Feasibility / performance | [Analysis](../../.agent/ANALYSIS.md), affected query/index/transaction evidence |
| Documentation refresh | [Maintenance](MAINTENANCE.md), [evidence](EVIDENCE.md), [quality gates](QUALITY_GATES.md) |
| Testing requested | [Current source inventory and execution policy](TESTING.md) |


## Overview

This index provides a fast task-to-document routing table for engineers and AI agents working on `ski-api-gateway`.

### Recommended Reading Flow

```text
AGENTS.md → .agent/INDEX.md → Specific Topic Document → Relevant Code Files → Test Verification
```

---

## Topic Documents

| Topic | Description | File |
|---|---|---|
| **Project Summary** | Service purpose, external systems, and configuration | [.agent/PROJECT.md](PROJECT.md) |
| **Architecture** | Layering, request flow, middleware pipeline, and reverse proxy | [.agent/ARCHITECTURE.md](ARCHITECTURE.md) |
| **Code Style** | Go naming conventions, packages, panic handling, and structuring | [.agent/CODE_STYLE.md](CODE_STYLE.md) |
| **Constraints** | Non-negotiable `MUST`, `MUST NOT`, and `INVESTIGATE FIRST` rules | [.agent/CONSTRAINTS.md](CONSTRAINTS.md) |
| **Domain Overview** | Business modules, service routing boundaries, and SKI context | [.agent/DOMAIN.md](DOMAIN.md) |
| **Database & Persistence** | Downstream database architecture & local persistence stance | [.agent/DATABASE.md](DATABASE.md) |
| **GORM & ORM Standards** | GORM patterns for microservices integrated with this gateway | [.agent/GORM.md](GORM.md) |
| **API Contract** | Route registration, CORS, JWT, API keys, and response envelopes | [.agent/API.md](API.md) |
| **Error Handling** | Centralized panic recovery, error mapping, and status codes | [.agent/ERROR_HANDLING.md](ERROR_HANDLING.md) |
| **Testing** | Unit test suite organization, mocking, and coverage rules | [.agent/TESTING.md](TESTING.md) |
| **Workflows** | Checklists for adding routes, updating auth, and debugging | [.agent/WORKFLOWS.md](WORKFLOWS.md) |
| **Technical Debt** | Classified legacy debt items and remediation paths | [.agent/TECH_DEBT.md](TECH_DEBT.md) |
| **Preferred Patterns** | Preferred vs acceptable vs legacy coding patterns | [.agent/PREFERRED_PATTERNS.md](PREFERRED_PATTERNS.md) |
| **Refactoring** | Safe refactoring workflows and protect-first methodology | [.agent/REFACTORING.md](REFACTORING.md) |
| **Quality Gates** | Mandatory compilation, test, security, and styling gates | [.agent/QUALITY_GATES.md](QUALITY_GATES.md) |
| **Go Best Practices** | Practical Go guidelines, context, and error propagation | [.agent/GO_BEST_PRACTICES.md](GO_BEST_PRACTICES.md) |
| **GORM Best Practices** | Safe GORM queries, updates, transactions, and associations | [.agent/GORM_BEST_PRACTICES.md](GORM_BEST_PRACTICES.md) |
| **Database Performance**| Query optimization, index analysis, and connection pooling | [.agent/DATABASE_PERFORMANCE.md](DATABASE_PERFORMANCE.md) |
| **Code Quality** | Proportional code review and definition of done checklist | [.agent/CODE_QUALITY.md](CODE_QUALITY.md) |
| **Security Standards** | Trust boundaries, authentication, API keys, and rate limits | [.agent/SECURITY.md](SECURITY.md) |
| **Engineering Changelog** | Historical log of AI engineering guidance updates | [.agent/CHANGELOG.md](CHANGELOG.md) |

---

## Task-to-Skill Routing Table

| Task / Goal | Primary Skill | Supporting Documents |
|---|---|---|
| Modifying or adding Go code | `go-quality` | [.agent/GO_BEST_PRACTICES.md](GO_BEST_PRACTICES.md) |
| Adding or modifying routes / proxy | `api-contract` | [.agent/API.md](API.md), `pkg/app/router.go` |
| Updating authentication / API key logic | `backend-security` | [.agent/SECURITY.md](SECURITY.md), `pkg/auth/`, `helper/api_key.go` |
| Writing or improving tests (>=90% target) | `go-testing` | [.agent/TESTING.md](TESTING.md), `test/` |
| Profiling performance or proxy latency | `performance-profiling` | [.agent/DATABASE_PERFORMANCE.md](DATABASE_PERFORMANCE.md) |
| Inspecting GORM models / queries downstream | `gorm-quality` | [.agent/GORM_BEST_PRACTICES.md](GORM_BEST_PRACTICES.md) |
| Refactoring legacy helper / middleware | `safe-refactoring` | [.agent/REFACTORING.md](REFACTORING.md), [.agent/TECH_DEBT.md](TECH_DEBT.md) |
| Dockerfile or container updates | `docker-production` | `Dockerfile`, `docker-compose.yml` |
| CI/CD pipeline modifications | `ci-quality-gate` | `.gitlab-ci.yml` |
