# Gateway Agent Documentation Index

For data Q&A, feature availability, and feature feasibility, first read the shared [workspace answer contract](../../AGENTS.md#answer-contract-result-evidence-implications). Use the shared skills in `../../.agents/skills/`: `visitflow-database-qa` for actual results and `visitflow-code-investigation` for code/schema evidence. Reuse established read-only target/scope; report actual results first, and state missing access explicitly. These shared guides apply when this repository is opened directly as well.

## Choose a task

Start with [AGENTS.md](../AGENTS.md). Combine only skills needed for the affected concerns and deduplicate reading. Shared skills stay in the workspace; service-specific skills, when present, live under `.agent/skills/`.

| Task | Skill selection | First reference |
| --- | --- | --- |
| Existing behavior/feature feasibility | Workspace `visitflow-code-investigation`; design/performance discussion adds `visitflow-query-brainstorm` | Affected route → handler/service → persistence or external I/O → model/response/tests |
| Measured slow endpoint/query | Workspace `visitflow-query-performance`; local profiling/SQL skills as relevant | Actual SQL/query count, representative plans and measurements |
| Actual MySQL count/validation | Workspace `visitflow-database-qa` | Workspace authorization, metric definition and relevant schema |
| Go implementation or bug fix | Workspace `visitflow-go-backend`; local `go-quality`, `go-testing` | PREFERRED_PATTERNS, affected code/tests |
| GORM/query/transaction | Add workspace `visitflow-gorm-mysql`, local `gorm-quality` | GORM, DATABASE |
| JSON/status/error compatibility, including preserving responses | Add local `api-contract` | API, ERROR_HANDLING, TESTING |
| Legacy cleanup | Add local `safe-refactoring` | CODE_QUALITY, affected callers/tests |
| SQL performance/index/schema | `mysql-performance`, `database-schema`, `migration-safety` as relevant; profiling for measured performance work | DATABASE_PERFORMANCE; verified metadata |
| Auth/tenant/files/secrets | Add `backend-security` | CONSTRAINTS and actual auth/query path |
| Background work/logging | Add `observability`; Go/testing for concurrency | Relevant integration/context/error path |
| Docker or CI | `docker-production` or `ci-quality-gate` | Actual Docker/CI/Makefile and TESTING |
| Documentation maintenance | Relevant topic; skill edits include retrieval/application scenarios | Check references, current commands and contradictions |

For a response-preserving repository fix in the DB services, start with Go/testing/GORM/API guidance. For payroll, select file/external-I/O guidance instead of assuming a repository. All code changes finish with [QUALITY_GATES](QUALITY_GATES.md).

## Document ownership

- [AGENTS](../AGENTS.md): mandatory local rules and work sequence.
- This index: task routing; not another checklist.
- [PREFERRED_PATTERNS](PREFERRED_PATTERNS.md): implementation decisions and example boundaries.
- [TESTING](TESTING.md): commands, facilities, side effects and evidence limits.
- [QUALITY_GATES](QUALITY_GATES.md): final verification.
- [WORKFLOWS](WORKFLOWS.md): task recipes.
- [CHANGELOG](CHANGELOG.md): history only, read when needed.

## Local source entry points

- Proxy routes: `configuration.json`; inspect only relevant method/path/upstream metadata, without exposing credentials. Local Gin assembly: `main.go`, then `route/users_route.go`.
- Identity/session workflow: `service/user_service_impl.go`; callback login/refresh transactions are scoped examples, not approval of every legacy method.
- Writer reload: `repository/role_repository_impl.go`; resolver lifecycle still requires inspection.
- Regression tests: `test/session_refresh_coverage_test.go`, `test/user_service_test.go`, `main_coverage_test.go`.

## Topic library

- [API](API.md)
- [ARCHITECTURE](ARCHITECTURE.md)
- [CODE_QUALITY](CODE_QUALITY.md)
- [CODE_STYLE](CODE_STYLE.md)
- [CONSTRAINTS](CONSTRAINTS.md)
- [DATABASE](DATABASE.md)
- [DATABASE_PERFORMANCE](DATABASE_PERFORMANCE.md)
- [DATABASE_SCHEMA](DATABASE_SCHEMA.md)
- [DOMAIN](DOMAIN.md)
- [ERROR_HANDLING](ERROR_HANDLING.md)
- [GORM](GORM.md)
- [GORM_BEST_PRACTICES](GORM_BEST_PRACTICES.md)
- [GO_BEST_PRACTICES](GO_BEST_PRACTICES.md)
- [PROJECT](PROJECT.md)

Descriptions can age. Verify affected facts from current source or authorized metadata. Documentation maintenance on 2026-09-27 does not establish production state or a fresh passing test suite.

## Optional maintenance tools

- [FLOW_MAP](FLOW_MAP.md): locate a critical path only when needed.
- [Workspace validator](../../.agents/tools/README.md): check guidance after documentation/source moves or tooling changes. Do not run it for every routine question.

Read each selected document once per unchanged session. A link is a reference, not an instruction to recursively load the entire library. Apply all relevant safety rules while limiting code/schema inspection to the affected flow.
