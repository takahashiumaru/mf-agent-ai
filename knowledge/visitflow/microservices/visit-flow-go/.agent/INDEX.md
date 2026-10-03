# Agent Documentation Index

For data Q&A, feature availability, and feature feasibility, first read the shared [workspace answer contract](../../AGENTS.md#answer-contract-result-evidence-implications). Use the shared skills in `../../.agents/skills/`: `visitflow-database-qa` for actual results and `visitflow-code-investigation` for code/schema evidence. Reuse established read-only target/scope; report actual results first, and state missing access explicitly. These shared guides apply when this repository is opened directly as well.

## Choose one starting path

Read [AGENTS.md](../AGENTS.md) first. This index is navigation; it does not add another implementation checklist. Open linked references only for the affected concern. Combine skills when concerns overlap, then remove duplicate reading.

| Task | Skills under `skills/` | First reference |
| --- | --- | --- |
| Existing behavior, feature availability, feasibility | Workspace `visitflow-code-investigation`; performance/design discussion adds `visitflow-query-brainstorm` | Relevant route → controller → service → repository → model/schema/tests |
| Actual database totals or validation | Workspace `visitflow-database-qa` | Workspace database/evidence rules; relevant code and schema |
| Go feature or bug fix | `go-quality`, `go-testing` | [PREFERRED_PATTERNS](PREFERRED_PATTERNS.md), [WORKFLOWS](WORKFLOWS.md) |
| Repository query/model/transaction change | Add `gorm-quality` | [GORM](GORM.md), [TESTING](TESTING.md) |
| JSON/status/error compatibility, including preserving a response during refactor | Add `api-contract` | [API](API.md), [ERROR_HANDLING](ERROR_HANDLING.md) |
| Legacy cleanup/refactor | Add `safe-refactoring` | [REFACTORING](REFACTORING.md) |
| Query performance or database refactor | Add `mysql-performance`; measured performance work adds `performance-profiling` | [DATABASE_PERFORMANCE](DATABASE_PERFORMANCE.md) |
| Index/schema/migration | `database-schema`, `migration-safety`; indexes add `mysql-performance` | [DATABASE](DATABASE.md) |
| Auth, tenant/ownership, input, secrets | Add `backend-security` | [CONSTRAINTS](CONSTRAINTS.md), affected auth/controller/query |
| Logging, tracing, background operations | Add `observability`; concurrency/performance changes add relevant Go/testing skills | [GO_BEST_PRACTICES](GO_BEST_PRACTICES.md) |
| CPU/memory/throughput optimization | `performance-profiling`, `go-quality`, `go-testing` | Measure affected path before selecting a change |
| Docker/runtime | `docker-production` | Relevant Docker/runtime files |
| CI/build gates | `ci-quality-gate` | [TESTING](TESTING.md), `Makefile`, CI configuration |
| Documentation-only maintenance | Relevant topic; skill edits validate retrieval/application scenarios | Check paths, examples, commands, contradictions, and scope |

Example: a repository bug fix that preserves JSON starts with `go-quality`, `go-testing`, `gorm-quality`, and `api-contract`; inspect the affected SQL/model/mapper and tests. Add refactoring/security/performance guidance only when the change involves those concerns. All code changes finish with [QUALITY_GATES](QUALITY_GATES.md).

## Document ownership

| Owner | Purpose | Read when |
| --- | --- | --- |
| [AGENTS](../AGENTS.md) | Mandatory local rules and work sequence | Entering this repository |
| This index | Task routing and document map | Selecting scope |
| `skills/<name>/SKILL.md` | Task-specific procedure and failure modes | Triggered by the task |
| [PREFERRED_PATTERNS](PREFERRED_PATTERNS.md) | Implementation choices and scoped examples | Writing/changing code |
| [QUALITY_GATES](QUALITY_GATES.md) | Completion checklist and severity | Verifying/reviewing changes |
| [TESTING](TESTING.md) | Available facilities, commands, evidence limits | Adding/running tests |
| [CODE_QUALITY](CODE_QUALITY.md) | Classifying legacy risk and reporting findings | Assessing technical debt |
| [CHANGELOG](CHANGELOG.md) | Historical changes | History explicitly needed; not normal startup |

## Topic reference library

- Orientation: [PROJECT](PROJECT.md), [ARCHITECTURE](ARCHITECTURE.md), [DOMAIN](DOMAIN.md).
- Go and errors: [CODE_STYLE](CODE_STYLE.md), [GO_BEST_PRACTICES](GO_BEST_PRACTICES.md), [ERROR_HANDLING](ERROR_HANDLING.md).
- Persistence: [DATABASE](DATABASE.md), [DATABASE_SCHEMA](DATABASE_SCHEMA.md), [GORM](GORM.md), [GORM_BEST_PRACTICES](GORM_BEST_PRACTICES.md), [DATABASE_PERFORMANCE](DATABASE_PERFORMANCE.md).
- Contracts/safety: [API](API.md), [CONSTRAINTS](CONSTRAINTS.md).
- Execution/debt: [WORKFLOWS](WORKFLOWS.md), [REFACTORING](REFACTORING.md), [TECH_DEBT](TECH_DEBT.md).

These are references, not a required reading bundle. Schema snapshots and implementation descriptions can age: verify relevant claims in current source or permitted live metadata. Testing/tooling descriptions were rechecked on 2026-09-27; this is not a fresh audit of every topic or production deployment.

## Source entry points

- Wiring/layer layout only: `route/company_route.go` and its controller/service/repository chain. See the limitations in [preferred examples](PREFERRED_PATTERNS.md#example-boundaries).
- Visit lifecycle: `route/visit_route.go`, `service/visit_service_impl.go`, `repository/visit_repository_impl.go`.
- Customer batches: `service/visit_customer_service_impl.go`, `repository/visit_customer_repository_impl.go`.
- Location mapping: `service/customer_location_service_impl.go`.
- Reports/procedures: `repository/visit_flow_report_repository_impl.go`.
- Authentication: `auth/auth.go`.
- Mock DB and services: `test/test_db_helper_test.go`, `test/mocks_test.go`.

## Optional maintenance tools

- [FLOW_MAP](FLOW_MAP.md): locate a critical path only when needed.
- [Workspace validator](../../.agents/tools/README.md): check guidance after documentation/source moves or tooling changes. Do not run it for every routine question.

Read each selected document once per unchanged session. A link is a reference, not an instruction to recursively load the entire library. Apply all relevant safety rules while limiting code/schema inspection to the affected flow.
