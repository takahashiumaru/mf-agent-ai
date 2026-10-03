# Agent context index

## Required entry points

Read [repository rules](../AGENTS.md) and [evidence/limits](EVIDENCE.md), then choose the relevant task. Do not read every topic or run tests for every request.

| Task | Read |
| --- | --- |
| Actual numbers or records | [Data-first answers](../../.agent/DATA_ANSWERS.md), [authorized runner](../../.agent/DATA_ACCESS.md) |
| Feature existence / diagnosis | [Code investigation](../../.agents/skills/ski-code-investigation/SKILL.md), exact source/callers and schema |
| Feasibility / performance | [Analysis](../../.agent/ANALYSIS.md), affected query/index/transaction evidence |
| Documentation refresh | [Maintenance](MAINTENANCE.md), [evidence](EVIDENCE.md), [quality gates](QUALITY_GATES.md) |
| Testing requested | [Current source inventory and execution policy](TESTING.md) |


## Reading order

`AGENTS.md` → `.agent/INDEX.md` → task-specific document → affected module → nearest examples → tests.

## Task routing

| Task | Read |
|---|---|
| Understand service and integrations | [PROJECT.md](PROJECT.md), [ARCHITECTURE.md](ARCHITECTURE.md) |
| Change a domain flow | [DOMAIN.md](DOMAIN.md), [WORKFLOWS.md](WORKFLOWS.md) |
| Change a query or model | [DATABASE.md](DATABASE.md), [GORM.md](GORM.md) |
| Add or change an endpoint | [API.md](API.md), [ERROR_HANDLING.md](ERROR_HANDLING.md) |
| Style or constraints | [CODE_STYLE.md](CODE_STYLE.md), [CONSTRAINTS.md](CONSTRAINTS.md) |
| Add/fix tests | [TESTING.md](TESTING.md) |

## Evidence map

- Entrypoint and router: `main.go`, `app/router.go`
- Database setup: `app/database.go`
- Routes: `route/`; handlers: `controller/`; business logic: `service/`; persistence: `repository/`
- Models: `model/`; cross-cutting helpers and errors: `helper/`, `exception/`, `auth/`

Confirm paths and current behavior in source; this index does not replace code review.

## Skill routing

`.agent/skills/` is repository-local guidance, not proof that an agent runtime auto-discovers installed skills. `AGENTS.md` routes tasks explicitly. Read only the relevant skill:

| Task | Skill(s) |
|---|---|
| Go code/review | `skills/go-quality/SKILL.md` |
| GORM model/query/write/transaction | `skills/gorm-quality/SKILL.md`; add `skills/mysql-performance/SKILL.md` for performance work |
| Schema or migration | `skills/database-schema/SKILL.md`, `skills/migration-safety/SKILL.md` |
| Tests/behavior change | Relevant technical skill plus `skills/go-testing/SKILL.md` |
| HTTP contract | `skills/api-contract/SKILL.md` |
| Auth, access control, sensitive input | `skills/backend-security/SKILL.md` |
| Logs/traces/metrics | `skills/observability/SKILL.md` |
| Runtime profiling | `skills/performance-profiling/SKILL.md` plus relevant Go/MySQL skill |
| Docker or CI configuration | `skills/docker-production/SKILL.md` or `skills/ci-quality-gate/SKILL.md` |
| Behavior-preserving refactor | `skills/safe-refactoring/SKILL.md` plus affected technical skill |

See `.agent/TECH_DEBT.md` for scoped risks and `.agent/SECURITY.md` before security-sensitive work.

## Current evidence and shared guidance

See [EVIDENCE.md](EVIDENCE.md) for the concrete source trace, auth import scope and schema/data routing. For business-data questions, follow the workspace [data-first answer contract](../../.agent/DATA_ANSWERS.md).
