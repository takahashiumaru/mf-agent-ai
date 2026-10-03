# .agent/CHANGELOG.md — AI Engineering Guidance Changelog

This changelog records material changes to the AI engineering guidance, repository constraints, architectural patterns, and skill rules for `mf-micro-service-discount-proposal`.

> **Note**: This file tracks changes to the AI engineering system itself, **not** routine application releases or standard bug fixes.

---

## 2026-09-20 — Build repository-specific agent skills

### Added
- Created 13 modular, action-oriented agent skills in `.agent/skills/`:
  - `go-quality`: Go code standards, panic error handling, layer separation.
  - `gorm-quality`: GORM queries, zero-value map updates, soft-delete rules, transactions.
  - `mysql-performance`: SARGable predicates, composite index left-prefix matching, N+1 query elimination.
  - `database-schema`: Domain entity modeling, GORM struct tags, slice aliases, response mappers.
  - `migration-safety`: MySQL DDL migration safety, expand-and-contract deployment, AutoMigrate restriction.
  - `go-testing`: Unit, integration, and HTTP test suites, table-driven tests, Testify assertions.
  - `api-contract`: REST routes, request binding, custom validation rules, standard response envelopes.
  - `backend-security`: JWT auth extraction, tenant hierarchy isolation, SQL parameterization, secret protection.
  - `observability`: OpenTelemetry distributed tracing, GORM slow-query logging, panic stack traces.
  - `performance-profiling`: CPU/memory profiling, query benchmarks, reproducible baselines.
  - `docker-production`: Multi-stage Docker builds, static Go binaries, container runtime verification.
  - `ci-quality-gate`: GitLab CI/CD pipelines, golangci-lint static analysis, automated quality gates.
  - `safe-refactoring`: 6-step migrate-when-touched refactoring loop, regression safeguards.
- Added Task-to-Skill routing table in `.agent/INDEX.md` and direct skill matrix in `AGENTS.md`.
- Updated legacy skills `database_expert` and `go_mvc_expert` to forward directly to repository-specific skills.

---

## 2026-09-20 — Define Go, GORM, and MySQL engineering standards

### Added
- Created `.agent/GO_BEST_PRACTICES.md` documenting Go design rules, panic/recovery error handling standards, constructor injection, pointer semantics, and goroutine boundaries.
- Created `.agent/GORM_BEST_PRACTICES.md` documenting persistence standards, zero-value safe updates via maps, soft-delete consistency, service transaction ownership, and parameterized joins.
- Created `.agent/DATABASE_PERFORMANCE.md` establishing evidence-first optimization rules, composite index left-prefix matching, N+1 query elimination, bounded queries, and lock duration rules.
- Created `.agent/SECURITY.md` establishing backend security standards, JWT authentication flow, tenant isolation via marketing hierarchy, SQL injection prevention, SSRF controls, and secret protection.
- Created `.agent/CODE_QUALITY.md` establishing a 10-dimension code review checklist and empirical Definition of Done.

### Changed
- Updated `AGENTS.md` and `.agent/INDEX.md` with routing to the new Go, GORM, database performance, security, and code quality standards.

---

## 2026-09-20 — Assess legacy quality and define engineering direction

### Added
- Created `.agent/TECH_DEBT.md` cataloging 10 prioritized technical debt items (e.g. unparameterized SQL joins in credit note amortization, double pointer GORM updates, disabled role checks, soft-delete inconsistencies).
- Created `.agent/PREFERRED_PATTERNS.md` defining preferred patterns for 5-tier layer separation, service-level transaction ownership, zero-value safe updates, and bounded queries.
- Created `.agent/REFACTORING.md` establishing the 6-step safe migrate-when-touched workflow and identifying high-risk changes requiring dedicated tasks.
- Created `.agent/QUALITY_GATES.md` defining mandatory pre-completion gates (`go fmt`, `go vet`, `go test`, `go build`, transaction safety, secret prevention) and conditional verification standards.

### Changed
- Updated `AGENTS.md` and `.agent/INDEX.md` with routing for technical debt review, preferred patterns, refactoring, and quality gates.

---

## 2026-09-20 — Initialize evidence-based repository context

### Added
- Created root `AGENTS.md` operational entrypoint and verified tech stack definition (Go 1.23, Gin, GORM, MySQL).
- Created `.agent/INDEX.md` task-to-document routing table and document catalog.
- Created `.agent/PROJECT.md` documenting service purpose, module layout, and upstream GitLab microservice dependencies.
- Created `.agent/ARCHITECTURE.md` documenting the strict 5-tier architecture, request lifecycle, service transaction ownership, and async MSSQL ETL sync.
- Created `.agent/CODE_STYLE.md` documenting Go naming conventions, constructors, slice aliases, mapper methods, and panic-recovery idioms.
- Created `.agent/CONSTRAINTS.md` defining `MUST`, `MUST NOT`, `SHOULD`, and `INVESTIGATE FIRST` guardrails.
- Created `.agent/DOMAIN.md` documenting proposal types (`SKI1`, `SKI2`, `DPL`, `DPF`, `DPL2`), credit notes, customer balance tracking, state machine, and period closing rules.
- Created `.agent/DATABASE.md` documenting MySQL schema, composite primary keys, soft delete nuances (`gorm.DeletedAt` vs `*time.Time`), and audit tables (`histories`).
- Created `.agent/GORM.md` documenting zero-value update caveats, preloading, raw SQL queries, and transaction helper usage.
- Created `.agent/API.md` documenting Gin routing, JWT authentication metadata extraction, custom validators, query filters, and `WebResponse` envelope.
- Created `.agent/ERROR_HANDLING.md` documenting centralized panic-recovery error handling, sentinel errors, and MySQL error mapping.
- Created `.agent/TESTING.md` documenting testing baseline, verified commands, and test gap analysis.
- Created `.agent/WORKFLOWS.md` providing step-by-step checklists for adding endpoints, modifying logic, tuning queries, fixing bugs, and updating schema.
- Added `.agent/CHANGELOG.md` to enforce continuous documentation tracking for engineering guidance.

### Changed
- Updated `.agent/workflows/run_app.md` to accurately reflect MySQL database dependencies and configuration for `mf-micro-service-discount-proposal`.

## 2026-09-27 — Evidence-first agent entry points

- Replaced the long entry point with selective routing, shared data-first/PROD-DEV policy and explicit compatibility exceptions. Added CLAUDE.md.
- Added EVIDENCE and MAINTENANCE; corrected history documentation and stale test inventory.
- Replaced absolute transaction/envelope rules with source-aware compatibility rules; clarified requested-test policy and historical verification limits across topic guides.
- No application source or runtime configuration changed; no tests, builds, startup or database operations performed.

## 2026-09-27 — `docs: improve AI agent guidance`

- Added selective task entry points, shared workspace data-first and database environment rules, and Claude Code guidance.
- Recorded repository-specific evidence/limits and current testing inventory; clarified that historical assertions are not current verification.
- Preserved existing source and user changes; documentation only.
